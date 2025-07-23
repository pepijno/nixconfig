---@class List
local List = {}

---Returns a new list
---@param o? table
---@return List
function List:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

---Appends a value into to the list
---@param value any
function List:push(value)
	table.insert(self, value)
end

---Returns a list of mapped values
---@param mapper fun(value: any): any
---@return List
function List:map(mapper)
	local mapped = List:new()

	for _, v in ipairs(self) do
		mapped:push(mapper(v))
	end

	return mapped
end

---Flatten a list
---@return List
function List:flatten()
	local flatten = List:new()

	for _, v1 in ipairs(self) do
		for _, v2 in ipairs(v1) do
			flatten:push(v2)
		end
	end

	return flatten
end

local function join(...)
	return table.concat({ ... }, "/")
end

local function resolve_paths(root, paths)
	return List:new(paths)
		:map(function(path_pattern)
			return vim.fn.glob(join(root, path_pattern), true, true)
		end)
		:flatten()
end

local plug_jar_map = {
	["java-test"] = {
		"junit-jupiter-api_*.jar",
		"junit-jupiter-engine_*.jar",
		"junit-jupiter-migrationsupport_*.jar",
		"junit-jupiter-params_*.jar",
		"junit-platform-commons_*.jar",
		"junit-platform-engine_*.jar",
		"junit-platform-launcher_*.jar",
		"junit-platform-runner_*.jar",
		"junit-platform-suite-api_*.jar",
		"junit-platform-suite-commons_*.jar",
		"junit-platform-suite-engine_*.jar",
		"junit-vintage-engine_*.jar",
		"org.apiguardian.api_*.jar",
		"org.eclipse.jdt.junit4.runtime_*.jar",
		"org.eclipse.jdt.junit5.runtime_*.jar",
		"org.opentest4j_*.jar",
		"com.microsoft.java.test.plugin-*.jar",
	},
	["java-debug-adapter"] = { "*.jar" },
}

---Returns a list of .jar file paths for given list of jdtls plugins
---@param plugin_names string[]
---@return string[] # list of .jar file paths
local function get_plugin_paths(plugin_names)
	return List:new(plugin_names)
		:map(function(plugin_name)
			local root = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/share/" .. plugin_name)
			return resolve_paths(root, plug_jar_map[plugin_name])
		end)
		:flatten()
end

local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients

local request = function(bufnr, method, params, handler)
	local clients = get_clients({ bufnr = bufnr, name = "jdtls" })
	local _, client = next(clients)
	if not client then
		vim.notify("No LSP client with name `jdtls` available", vim.log.levels.WARN)
		return
	end
	local co
	if not handler then
		co = coroutine.running()
		if co then
			handler = function(err, result, ctx)
				coroutine.resume(co, err, result, ctx)
			end
		end
	end
	client.request(method, params, handler, bufnr)
	if co then
		return coroutine.yield()
	end
end

local function make_code_action_params(from_selection)
	local params
	if from_selection then
		params = vim.lsp.util.make_given_range_params()
	else
		params = vim.lsp.util.make_range_params()
	end
	local bufnr = vim.api.nvim_get_current_buf()
	params.context = {
		diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr),
	}
	return params
end

local function java_action_organize_imports(_, ctx)
	request(0, "java/organizeImports", ctx.params, function(err, resp)
		if err then
			print("Error on organize imports: " .. err.message)
			return
		end
		if resp then
			vim.lsp.util.apply_workspace_edit(resp, "utf-16")
		end
	end)
end

local bundles = get_plugin_paths({ "java-test", "java-debug-adapter" })
local workspace_path = vim.fn.stdpath("data") .. "/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name
local os_config = "mac"
return {
	{
		ft = { "java" },
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			local neotest_java = require("neotest-java")
			neotest_java.setup()
			vim.keymap.set("n", "<leader>tt", function()
				neotest_java.run_build_and_test(false)
			end, { desc = "Run test under cursor" })

			vim.keymap.set("n", "<leader>ta", function()
				neotest_java.run_build_and_test(true)
			end, { desc = "Run all tests" })

			local neotest = require("neotest")
			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { desc = "Toggle summary" })
			vim.keymap.set("n", "<leader>tw", function()
				neotest.output_panel.toggle()
			end, { desc = "Toggle window" })

			neotest.setup({
				log_level = vim.log.levels.DEBUG,
				discovery = {
					enabled = false,
				},
				adapters = {
					neotest_java.interface({}),
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "java", "kotlin", "xml" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		ft = { "java" },
		opts = {
			handlers = {
				-- By assigning an empty function, you can remove the notifications
				-- printed to the cmd
				["$/progress"] = function(_, result, ctx) end,
			},
			servers = {
				jdtls = {
					cmd = {
						"/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/bin/java",
						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dosgi.checkConfiguration=true",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-Xms1G",
						"--add-modules=ALL-SYSTEM",
						"--add-opens",
						"java.base/java.util=ALL-UNNAMED",
						"--add-opens",
						"java.base/java.lang=ALL-UNNAMED",
						"-javaagent:" .. vim.fn.stdpath("data") .. "/mason/share/lombok-nightly/lombok.jar",
						"-jar",
						vim.fn.glob(
							vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
						),
						"-configuration",
						vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_" .. os_config,
						"-data",
						workspace_dir,
					},
					init_options = {
						bundles = bundles,
						extendedClientCapabilities = {
							advancedExtractRefactoringSupport = true,
							advancedOrganizeImportsSupport = true,
							classFileContentsSupport = true,
							executeClientCommandSupport = true,
							generateConstructorsPromptSupport = true,
							generateDelegateMethodsPromptSupport = true,
							generateToStringPromptSupport = true,
							hashCodeEqualsPromptSupport = true,
							inferSelectionSupport = {
								"extractMethod",
								"extractVariable",
								"extractConstant",
								"extractVariableAllOccurrence",
							},
							moveRefactoringSupport = true,
							overrideMethodsPromptSupport = true,
						},
						workspace = workspace_dir,
					},
				},
			},
		},
		init = function()
			vim.keymap.set("n", "<leader>ltf", function()
				java_action_organize_imports(nil, { params = make_code_action_params(false) })
			end, { desc = "Organize imports" })
		end,
	},
	-- {
	-- 	"williamboman/mason.nvim",
	-- 	opts = function(_, opts)
	-- 		if type(opts.ensure_installed) == "table" then
	-- 			vim.list_extend(opts.ensure_installed, { { name = "jdtls", version = "v1.31.0" } })
	-- 		end
	-- 	end,
	-- },
}
