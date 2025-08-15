vim.pack.add({ "https://github.com/rktjmp/hotpot.nvim" })

if pcall(require, "hotpot") then
	require("conf")
else
	vim.print("Unable to require hotpot")
end
