local async = require("neotest.async")
local neotest = require("neotest")
local lib = require("neotest.lib")
local file = require("neotest.lib.file")
local FileChecker = require("neotest-java.file_checker")
local ResultBuilder = require("neotest-java.result_builder")
local CommandBuilder = require("neotest-java.command_builder")
local job = require("plenary.job")
local Popup = require("nui.popup")

local function run_bash_process(command, callback)
	local popup = Popup({
		enter = true,
		focusable = true,
		border = {
			style = "rounded",
		},
		position = "50%",
		size = {
			width = "80%",
			height = "60%",
		},
	})

	popup:mount()

	local function handle_output_line(line)
		if line ~= "" then
			vim.schedule(function()
				vim.api.nvim_buf_set_lines(popup.bufnr, -1, -1, false, { line })
				vim.api.nvim_buf_call(popup.bufnr, function()
					vim.api.nvim_command("normal! G")
				end)
			end)
		end
	end

	local function handle_data(data, prefix)
		prefix = prefix or ""
		if data then
			for _, line in ipairs(vim.split(data, "\n")) do
				handle_output_line(prefix .. line)
			end
		end
	end

	vim.system(command, {
		text = true,
		stdout = vim.schedule_wrap(function(_, data)
			handle_data(data)
		end),
		stderr = vim.schedule_wrap(function(_, data)
			handle_data(data, "Error: ")
		end),
	}, function(obj)
		if obj.code == 0 then
			vim.schedule(function()
				vim.api.nvim_win_close(popup.winid, true)
				callback()
			end)
		end
	end)
end

local uv = vim.uv

local function read_file(path)
	local fd = assert(uv.fs_open(path, "r", 438))
	local stat = assert(uv.fs_fstat(fd))
	local data = assert(uv.fs_read(fd, stat.size, 0))
	assert(uv.fs_close(fd))
	return data
end

local excluded_directories = {
	"target",
	"build",
	"out",
	"bin",
	"resources",
	"main",
}

local filter_dir = function(_, rel_path, _)
	for _, v in ipairs(excluded_directories) do
		if string.find(rel_path, "test") then
			return true
		end

		if string.find(rel_path, v) then
			return false
		end
	end

	return true
end

local get_match_type = function(captured_nodes)
	if captured_nodes["test.name"] then
		return "test"
	end
	if captured_nodes["namespace.name"] then
		return "namespace"
	end
end

local build_position = function(file_path, source, captured_nodes)
	local match_type = get_match_type(captured_nodes)
	if match_type then
		local name = vim.treesitter.get_node_text(captured_nodes[match_type .. ".name"], source)
		local definition = captured_nodes[match_type .. ".definition"]
		local parameters
		if captured_nodes[match_type .. ".parameters"] then
			parameters = vim.treesitter.get_node_text(captured_nodes[match_type .. ".parameters"], source)
		end
		if parameters == "()" then
			parameters = nil
		end

		return {
			type = match_type,
			path = file_path,
			name = name,
			range = { definition:range() },
			parameters = parameters,
		}
	end
end

local discover_positions = function(file_path)
	local query = [[

      ;; Test class
        (class_declaration
          name: (identifier) @namespace.name
        ) @namespace.definition

      ;; @Test and @ParameterizedTest functions
      (method_declaration
        (modifiers
          (marker_annotation
            name: (identifier) @annotation 
              (#any-of? @annotation "Test" "ParameterizedTest" "CartesianTest")
            )
        )
        name: (identifier) @test.name
        parameters: (formal_parameters) @test.parameters
      ) @test.definition

    ]]

	return lib.treesitter.parse_positions(file_path, query, { nested_namespaces = true, build_position = build_position })
end

local function get_parse_root(content, lang)
	local lang_tree = vim.treesitter.get_string_parser(content, lang, { injections = { [lang] = "" } })
	local root = lang_tree:parse()[1]:root()
	return root, lang
end

local function normalise_query(lang, query)
	if type(query) == "string" then
		local parse_query = vim.treesitter.query.parse or vim.treesitter.parse_query
		query = parse_query(lang, query)
	end
	return query
end

local find_pom_artifactId = function(dir)
	local query = [[
(element
  (STag
    (Name) @project.tag.name (#eq? @project.tag.name "project"))
  (content
    (element
      (STag
        (Name) @artifactId.tag.name (#eq? @artifactId.tag.name "artifactId"))
      (content) @content
    )
  )
)
	]]
	local pom = dir .. "/pom.xml"
	local content = read_file(pom)

	local root, lang = get_parse_root(content, "xml")
	local parsed_query = normalise_query(lang, query)
	for _, match in parsed_query:iter_matches(root, content) do
		local captured_nodes = {}
		for i, capture in ipairs(parsed_query.captures) do
			captured_nodes[capture] = match[i]
		end
		return vim.treesitter.get_node_text(captured_nodes.content, content)
	end
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

	local package_query = [[

      ((package_declaration (scoped_identifier) @package.name))

      ((package_declaration (identifier) @package.name))

  ]]

	local splitted = vim.split(id, "::")
	local filename = splitted[1]
	if #splitted == 1 then
		local content = read_file(filename)

		local class_name_query = [[
	    ((class_declaration (identifier) @target))
	  ]]

		local package_line = find_in_text(package_query, content)
		local name = find_in_text(class_name_query, content)

		return package_line .. "." .. name
	else
		table.remove(splitted, 1)
		table.remove(splitted, #splitted)
		-- read the file
		local content = read_file(filename)

		-- get the package name
		local package_line = find_in_text(package_query, content)

		return package_line .. "." .. table.concat(splitted, "\\$")
	end
end

---@class neotest.Adapter
local neotestJava = {
	interface = {
		name = "neotest-java",
		config = {
			ignore_wrapper = false,
		},
	},
}

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
neotestJava.interface.root = function(dir)
	return lib.files.match_root_pattern("pom.xml")(dir)
end

---Filter directories when searching for test files
---@async
---@param name string Name of directory
---@param rel_path string Path to directory, relative to root
---@param root string Root directory of project
---@return boolean
neotestJava.interface.filter_dir = function(name, rel_path, root)
	return filter_dir(name, rel_path, root)
end

---@async
---@param file_path string
---@return boolean
neotestJava.interface.is_test_file = function(file_path)
	return FileChecker.is_test_file(file_path)
end

---Given a file path, parse all the tests within it.
---@async
---@param file_path string Absolute file path
---@return neotest.Tree | nil
neotestJava.interface.discover_positions = function(file_path)
	return discover_positions(file_path)
end

---@param args neotest.RunArgs
---@return nil | neotest.RunSpec | neotest.RunSpec[]
neotestJava.interface.build_spec = function(args)
	local command = CommandBuilder:new({
		junit_jar = vim.fn.stdpath("data") .. "/neotest-java/junit-platform-launcher-1.10.2.jar",
	})
	local position = args.tree:data()
	local root = lib.files.match_root_pattern(".git")(position.path)
	local module_root = lib.files.match_root_pattern("pom.xml")(position.path)
	local absolute_path = position.path

	local reports_dir = module_root .. "/target"
	command:reports_dir(reports_dir)

	if position.type == "namespace" then
		position = args.tree:parent():data()
	end

	command:test_reference(resolve_qualified_name(position.id), position.name, position.type)

	local results_path = async.fn.tempname()
	local x = io.open(results_path, "w")
	x:write("")
	x:close()
	local stream_path = async.fn.tempname()
	x = io.open(stream_path, "w")
	x:write("")
	x:close()
	local stream_data, stop_stream = lib.files.stream_lines(stream_path)

	local had = {}
	return {
		command = command:build(module_root, results_path, stream_path),
		cwd = root,
		symbol = position.name,
		stream = function()
			return function()
				local lines = stream_data()
				local results = {}
				for _, line in ipairs(lines) do
					local status = line:match("##teamcity%[(%w+)%s")

					if status == "testFailed" or status == "testFinished" then
						local id_part = line:match("id='(.-)'")
						-- Pattern to extract class
						local class = id_part:match("class:(.-)|]")
						-- Pattern to extract nested-class
						local nested_classes = {}
						for nested_class in id_part:gmatch("nested%-class:(.-)|]") do
							table.insert(nested_classes, nested_class)
						end
						-- Pattern to extract method
						local method = id_part:match("method:(.-)%((.-)%)|]")
						-- Pattern to extract message
						local message = line:match("message='(.-)'")
						local expected = line:match("expected='(.-)'")
						local actual = line:match("actual='(.-)'")
						local details = line:match("details='(.-)'")
						local unique_key = table.concat(vim.tbl_flatten({ class, nested_classes, method }), "::")

						local splitted = vim.split(unique_key, ".", { plain = true })
						local id = absolute_path .. "::" .. splitted[#splitted]
						if had[id] ~= nil then
							goto continue
						end
						had[id] = 1
						if status == "testFailed" then
							local m = message
							if expected then
								m = m .. "expected='" .. expected .. "', actual='" .. actual .. "'"
							end
							results[id] = {
								status = "failed",
								short = m,
								errors = { { message = m } },
							}
						else
							results[id] = {
								status = "passed",
							}
						end
						-- if testcases[unique_key] == nil then
						-- 	testcases[unique_key] = {
						-- 		class = class,
						-- 		method = method,
						-- 	}
						-- 	if status == "testFailed" then
						-- 		testcases[unique_key].status = "failed"
						-- 		testcases[unique_key].short = message
						-- 			.. "expected='"
						-- 			.. expected
						-- 			.. "', actual='"
						-- 			.. actual
						-- 			.. "'"
						-- 		testcases[unique_key].details = details
						-- 	else
						-- 		testcases[unique_key].status = "passed"
						-- 	end
						-- end
					end
					::continue::
				end
				return results
			end
		end,
		context = {
			results_path = results_path,
			module_root = module_root,
			stop_stream = stop_stream,
		},
	}
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
neotestJava.interface.results = function(spec, result, tree)
	spec.context.stop_stream()
	return ResultBuilder.build_results(spec, result, tree)
end

setmetatable(neotestJava.interface, {
	__call = function(_, opts)
		opts = opts or {}
		local config = neotestJava.interface.config or {}
		neotestJava.interface.config = vim.tbl_extend("force", config, opts)
		return neotestJava.interface
	end,
})

neotestJava.run_build_and_test = function(run_all)
	local filename = vim.fn.expand("%")
	local module_root = lib.files.match_root_pattern("pom.xml")(filename)
	local artifactId = find_pom_artifactId(module_root)
	local classpath_filename = module_root .. "/target/classpath.txt"

	local callback
	if run_all then
		callback = function()
			vim.defer_fn(neotest.summary.open, 500)
			neotest.run.run(vim.fn.expand("%"))
		end
	else
		callback = function()
			vim.defer_fn(neotest.summary.open, 500)
			neotest.run.run()
		end
	end

	run_bash_process({
		"mvn",
		"-T15",
		"test-compile",
		"dependency:build-classpath",
		"-DskipTests",
		"-am",
		"-pl",
		":" .. artifactId,
		"-Dmdep.outputFile=" .. classpath_filename,
	}, callback)
end

neotestJava.setup = function()
	local filepath = vim.fn.stdpath("data") .. "/neotest-java/junit-platform-launcher-1.10.2.jar"
	if file.exists(filepath) then
		return
	end

	local stderr = {}
	job
		:new({
			command = "curl",
			args = {
				"--output",
				filepath,
				"https://repo1.maven.org/maven2/org/junit/platform/junit-platform-launcher/1.10.2/junit-platform-launcher-1.10.2.jar",
				"--create-dirs",
			},
			on_stderr = function(_, data)
				table.insert(stderr, data)
			end,
			on_exit = function(_, code)
				if code == 0 then
					lib.notify("Downloaded junit")
				else
					local output = table.concat(stderr, "\n")
					lib.notify(string.format("Error while downloading: \n %s", output), "error")
				end
			end,
		})
		:start()
end

return neotestJava
