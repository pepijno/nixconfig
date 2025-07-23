local uv = vim.uv

local function read_file(path)
	local fd = assert(uv.fs_open(path, "r", 438))
	local stat = assert(uv.fs_fstat(fd))
	local data = assert(uv.fs_read(fd, stat.size, 0))
	assert(uv.fs_close(fd))
	return data
end

local resolve_qualified_name = function(id)
	local function find_in_text(raw_query, content)
		local query = vim.treesitter.query.parse("java", raw_query)

		local lang_tree = vim.treesitter.get_string_parser(content, "java")
		local root = lang_tree:parse()[1]:root()

		local result = ""
		for _, node, _ in query:iter_captures(root, content, 0, -1) do
			result = vim.treesitter.get_node_text(node, content)
			break
		end
		return result
	end

	local splitted = vim.split(id, "::")
	local filename = splitted[1]
	table.remove(splitted, 1)
	table.remove(splitted, #splitted)
	-- read the file
	local content = read_file(filename)

	-- get the package name
	local package_query = [[

      ((package_declaration (scoped_identifier) @package.name))

      ((package_declaration (identifier) @package.name))

  ]]

	-- local class_name_query = [[
	--    ((class_declaration (identifier) @target))
	--  ]]

	local package_line = find_in_text(package_query, content)
	-- local name = find_in_text(class_name_query, content)

	return package_line .. "." .. table.concat(splitted, "::")
end

--- @param classname string name of class
--- @param testname string name of test
--- @return string unique_key based on classname and testname
local build_unique_key = function(classname, testname)
	classname = classname:gsub("%$", "::")
	return classname .. "::" .. testname
end

local function is_parameterized_test(testcases, name)
	-- regex to match the name with some parameters and index at the end
	-- example: subtractAMinusBEqualsC(int, int, int)[1]
	-- local regex = name .. "%(([^%)]+)%)%[([%d]+)%]"
	local regex = name .. "[%(%{].*%[%d+%]$"

	for k, _ in pairs(testcases) do
		if string.match(k, regex) then
			return true
		end
	end

	return false
end

local function extract_test_failures(testcases, name)
	-- regex to match the name with some parameters and index at the end
	-- example: subtractAMinusBEqualsC(int, int, int)[1]
	local regex = name .. "::#%d+$"

	local failures = {}
	for k, v in pairs(testcases) do
		if string.match(k, regex) then
			if v.short then
				failures[#failures + 1] = v
			end
		end
	end

	return failures
end

ResultBuilder = {}

function ResultBuilder.build_result(tree, lines)
	local results = {}
	local testcases = {}

	for _, line in ipairs(lines) do
		-- Pattern to extract status
		local status = line:match("##teamcity%[(%w+)%s")

		if status == "testFailed" or status == "testFinished" then
			local id_part = line:match("id='(.-)'")
			local class = id_part:match("class:(.-)|]")
			local nested_classes = {}
			for nested_class in id_part:gmatch("nested%-class:(.-)|]") do
				table.insert(nested_classes, nested_class)
			end
			local method = id_part:match("method:(.-)%((.-)%)|]")
			if method == nil then
				method = id_part:match("test%-template:(.-)%((.-)%)|]")
			end
			local test_template_invocation = id_part:match("test%-template%-invocation:(.-)|]")
			local message = line:match("message='(.-)'")
			local expected = line:match("expected='(.-)'")
			local actual = line:match("actual='(.-)'")
			local details = line:match("details='(.-)'")
			local unique_key = table.concat(vim.tbl_flatten({ class, nested_classes, method, test_template_invocation }), "::")

			if testcases[unique_key] == nil then
				testcases[unique_key] = {
					class = class,
					method = method,
				}
				if status == "testFailed" then
					testcases[unique_key].status = "failed"
					testcases[unique_key].short = message
					if expected then
						testcases[unique_key].short = testcases[unique_key].short .. "expected='" .. expected .. "', actual='" .. actual .. "'"
					end
					testcases[unique_key].details = details
				else
					testcases[unique_key].status = "passed"
				end
			end
		end
	end

	for _, v in tree:iter_nodes() do
		local node_data = v:data()
		local is_test = node_data.type == "test"

		if is_test then
			local unique_key = build_unique_key(resolve_qualified_name(node_data.id), node_data.name)
			local is_parameterized = node_data.parameters ~= nil

			if is_parameterized then
				local test_failures = extract_test_failures(testcases, unique_key)

				local failure_messages = {}
				for _, failure in ipairs(test_failures) do
					local name = failure.method
					local failure_message = name .. " -> " .. failure.short
					failure_messages[#failure_messages + 1] = failure_message
				end

				-- sort the messages alphabetically
				table.sort(failure_messages)

				local message = table.concat(failure_messages, "\n")
				if #test_failures > 0 then
					results[node_data.id] = {
						status = "failed",
						short = message,
						errors = { { message = message } },
					}
				else
					results[node_data.id] = {
						status = "passed",
					}
				end
			else
				local test_case = testcases[unique_key]

				if not test_case then
					results[node_data.id] = {
						status = "skipped",
					}
				elseif test_case.status == "failed" then
					local details = test_case.details
					local method = test_case.method
					local line
					if details then
						line = details:match(method .. "%(.+:([0-9]+)%)")
					end
					-- NOTE: errors array is expecting lines properties to be 0 index based
					if line ~= nil then
						line = line - 1
					end
					results[node_data.id] = {
						status = "failed",
						short = test_case.short,
						errors = { { message = test_case.short} },
					}
				else
					results[node_data.id] = {
						status = "passed"
					}
				end
			end
		end
	end

	return results
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
function ResultBuilder.build_results(spec, _, tree)
	local filename = spec.context.results_path or "/tmp/neotest-java/TEST-junit-jupiter.xml"
	local ok, data = pcall(function()
		return read_file(filename)
	end)
	if not ok then
		print("Error reading file: " .. filename)
		return {}
	end

	local lines = vim.split(data, "\n")

	return ResultBuilder.build_result(tree, lines)
end

return ResultBuilder
