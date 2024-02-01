require("core")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	require("core.bootstrap").init_lazy(lazypath)
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins/langs" },
	},
	lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
}, {
	checker = { enabled = true },
})

-- vim.schedule(function()
-- 	vim.cmd "MasonInstallAll"
--
-- 	-- Keep track of which mason pkgs get installed
-- 	local packages = table.concat(vim.g.mason_binaries_list, " ")
--
-- 	require("mason-registry"):on("package:install:success", function(pkg)
-- 		packages = string.gsub(packages, pkg.name:gsub("%-", "%%-"), "") -- rm package name
--
-- 		-- run above screen func after all pkgs are installed.
-- 		if packages:match "%S" == nil then
-- 			vim.schedule(function()
-- 				api.nvim_buf_delete(0, { force = true })
-- 				vim.cmd "echo '' | redraw" -- clear cmdline
-- 			end)
-- 		end
-- 	end)
-- end)
