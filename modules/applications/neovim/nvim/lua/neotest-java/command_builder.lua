local function wrap_command_as_bash(command)
	return ([=[
	bash -c '
	  %s
	'
	]=]):format(command)
end

local CommandBuilder = {}

function CommandBuilder:new(config)
	self.__index = CommandBuilder
	self._junit_jar = config.junit_jar
	return setmetatable({}, self)
end

function CommandBuilder:test_reference(qualified_name, node_name, type)
	self._test_references = self._test_references or {}

	local method_name
	if type == "test" then
		method_name = node_name
	end

	self._test_references[#self._test_references + 1] = {
		qualified_name = qualified_name,
		method_name = method_name,
		type = type,
	}
end

function CommandBuilder:reports_dir(reports_dir)
	self._reports_dir = reports_dir
end

function CommandBuilder:build(module_root, results_path, stream_path)
	local build_dir = module_root .. "/target"
	local output_dir = build_dir .. "/classes"
	local test_output_dir = build_dir .. "/test-classes"
	local classpath_filename = build_dir .. "/classpath.txt"
	local reference = self._test_references[1]
	local resources = module_root .. "/src/main/resources:" .. module_root .. "/src/test/resources"

	local ref
	if reference.type == "test" then
		ref = reference.qualified_name .. "," .. reference.method_name
	elseif reference.type == "file" then
		ref = reference.qualified_name
	end
	assert(ref)

	local command = "java -ea "
		.. " -DTRITON_HOME=/Users/poverbeeke/triton "
		.. " -cp "
		.. self._junit_jar
		.. ":\"/Users/poverbeeke/Applications/IntelliJ IDEA Ultimate.app/Contents/lib/idea_rt.jar\""
		.. ":\"/Users/poverbeeke/Applications/IntelliJ IDEA Ultimate.app/Contents/plugins/junit/lib/junit-rt.jar\""
		.. ":\"/Users/poverbeeke/Applications/IntelliJ IDEA Ultimate.app/Contents/plugins/junit/lib/junit5-rt.jar\""
		.. ":"
		.. resources
		.. ":$(cat "
		.. classpath_filename
		.. "):"
		.. output_dir
		.. ":"
		.. test_output_dir
		.. " com.intellij.rt.junit.JUnitStarter -ideVersion5 -junit5 "
		.. ref
		.. " | tee " .. results_path
		.. " | tee " .. stream_path

	command = command:gsub("%s+", " ")
	command = wrap_command_as_bash(command)

	-- vim.print(command)
	return command
end

return CommandBuilder
