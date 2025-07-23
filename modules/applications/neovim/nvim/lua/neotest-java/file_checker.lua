local file = require("neotest.lib.file")

local fileChecker = {
	test_file_patterns = {
		"IT%.java$",
		"Test%.java$",
		"Tests%.java$",
		"Spec%.java$",
		"IntegrationTest%.java$",
		"IntegrationTests%.java$",
	},
	test_file_body = {
		"@Test",
	},
	test_base_file_path = {
		"src/test",
	},
}
local function fileNameMatchesPattern(file_path)
	for _, pattern in ipairs(fileChecker.test_file_patterns) do
		if string.find(file_path, pattern) then
			return true
		end
	end
	return false
end

local function packagePathMatchesPattern(file_path)
	for _, path in ipairs(fileChecker.test_base_file_path) do
		if string.find(file_path, path) then
			return true
		end
	end
	return false
end

local function fileBodyContainsPattern(file_path)
	for _, annotation in ipairs(fileChecker.test_file_body) do
		if string.find(file.read(file_path), annotation) then
			return true
		end
	end
	return false
end

---@async
---@param file_path string
---@return boolean
function fileChecker.is_test_file(file_path)
	return fileNameMatchesPattern(file_path)
		or (packagePathMatchesPattern(file_path) and fileBodyContainsPattern(file_path))
end

function fileChecker.is_integration_test(file_name)
	return file_name:find("IT") ~= nil
end

return fileChecker
