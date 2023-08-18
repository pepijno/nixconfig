local M = {}

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

M.setup = function()
	-- Remap space as leader key
	map("", "<Space>", "<Nop>", opts)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- undo breakpoints
	map("i", ",", ",<C-g>u", opts)
	map("i", ".", ".<C-g>u", opts)
	map("i", "`", "`<C-g>u", opts)
	map("i", ";", ";<C-g>u", opts)
	map("i", "!", "!<C-g>u", opts)
	map("i", "?", "?<C-g>u", opts)
	map("i", "{", "{<C-g>u", opts)
	map("i", "}", "}<C-g>u", opts)
	map("i", "(", "(<C-g>u", opts)
	map("i", ")", ")<C-g>u", opts)
	map("i", "[", "[<C-g>u", opts)
	map("i", "]", "]<C-g>u", opts)

	-- Move text up and down
	-- map("i", "<C-j>", "<ESC>:m .+1<CR>==li", opts) -- move line down
	-- map("i", "<C-k>", "<ESC>:m .-2<CR>==li", opts) -- move line up
	map("n", "<C-j>", ":m .+1<CR>==", opts)
	map("n", "<C-k>", ":m .-2<CR>==", opts)
	map("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
	map("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

	-- Stay in indent mode
	map("v", "<", "<gv", opts)
	map("v", ">", ">gv", opts)

	-- Explorer
	map("n", "<leader>pv", vim.cmd.Ex, opts)

	local function switch_case()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		local word = vim.fn.expand("<cword>")
		local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

		-- Detect camelCase
		if word:find("[a-z][A-Z]") then
			-- Convert camelCase to snake_case
			local snake_case_word = word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
			vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
			-- Detect snake_case
		elseif word:find("_[a-z]") then
			-- Convert snake_case to camelCase
			local camel_case_word = word:gsub("(_)([a-z])", function(_, l)
				return l:upper()
			end)
			vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
		else
			print("Not a snake_case or camelCase word")
		end
	end

	map("n", "<leader>s", switch_case, opts)
	map("v", "<leader>s", switch_case, opts)
end

return M
