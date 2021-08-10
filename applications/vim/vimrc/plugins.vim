" vim-abolish
nnoremap <leader>rp :Subvert/

" toggle tagbar
nmap <leader>tt :TagbarToggle<CR>

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" quick-scope
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary gui=underline cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary gui=underline cterm=underline
augroup END

" Cheatsheet
nnoremap <silent> <leader>cheat :Cheatsheet<CR>
lua << EOF
require("cheatsheet").setup({
bundled_cheatsheets = {
	disabled = {
		"nerd-fonts",
		"unicode"
		}
	},
bundled_plugin_cheatsheets = false,
});
EOF

" Lualine
lua << EOF
require('lualine').setup {
	options = {theme = 'gruvbox_light'}
	}
EOF

" Toggle undo tree
nnoremap <leader>ut :UndotreeToggle<CR>

" map s to search for two chars
nmap s <Plug>(easymotion-overwin-f2)
nmap t <Plug>(easymotion-t2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" Jumping to next/prev
nmap n <Plug>(easymotion-next)
nmap N <Plug>(easymotion-prev)

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)


" Zettelkasten stuff
let g:zettelkasten = "~/Repos/zettelkasten/"
command! -nargs=1 NewZettel :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . "-<args>.md"
nnoremap <leader>zn :NewZettel 

lua << EOF
local actions = require('telescope.actions');
local actions_state = require('telescope.actions.state')

-- or create your custom action
function actions.create_md_link(prompt_bufnr)
	local entry = actions_state.get_selected_entry()
	actions.close(prompt_bufnr)
	local link = "[" .. entry.value .. "](" .. entry.value .. ")"
	vim.api.nvim_put({link}, "", true, true);
end

require('telescope').setup{
	defaults = {
		layout_config = {
			prompt_position = "top",
			},
		vimgrep_arguments = {
			"rg",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--fixed-strings",
			},
		prompt_prefix = "❯ ",
		selection_caret = "❯ ",
		color_devicons = true,
		selection_strategy = "reset",
		layout_strategy = "flex",
		mappings = {
			i = {
				["<C-i>"] = actions.create_md_link
				},
			n = {
				["<C-c>"] = actions.close,
				["<C-i>"] = actions.create_md_link
				}
			},
		set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
		}
}
require('telescope').load_extension('fzy_native')
EOF

nnoremap <silent> <leader>ff <cmd>lua require('telescope.builtin').find_files({["layout_config.preview_width"] = 0.2})<CR>
nnoremap <silent> <leader>fz <cmd>lua require('telescope.builtin').find_files({ cwd = vim.g.zettelkasten })<CR>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').tags()<cr>

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

lua << EOF
function format_range_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'
  vim.api.nvim_feedkeys('g@', 'n', false)
end
vim.api.nvim_set_keymap("n", "<leader>lm", "<cmd>lua format_range_operator()<CR>", {noremap = true})
EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

nnoremap <silent> <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>ls <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>ltd <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>lr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>la <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>lf <cmd>lua vim.lsp.buf.formatting()<CR>
vnoremap <silent> <leader>lf <cmd>lua vim.lsp.buf.formatting()<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
" Goto previous/next diagnostic warning/error
nnoremap <silent> <leader>lp <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <leader>ln <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

lua << EOF
require('formatter').setup({
logging = false,
filetype = {
	rust = {
		-- Rustfmt
		function()
			return {
				exe = "rustfmt",
				args = {"--emit=stdout"},
				stdin = true
				}
		end
		},
    zig = {
		-- zig fmt
		function()
			return {
				exe = "zig",
				args = {"fmt --stdin"},
				stdin = true
				}
		end
		}
	}
})

vim.api.nvim_exec([[
augroup FormatAutogroup
	autocmd!
	autocmd BufWritePost *.rs FormatWrite
augroup END
]], true)
EOF
nnoremap <silent> <C-f> :Format<CR>
