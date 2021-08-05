" Color scheme
function! SetColorscheme()
	set termguicolors
	" if strftime("%H") >= 8 && strftime("%H") < 20
	" 	let g:ayucolor="light"
	" else
		let g:ayucolor="light"
	" endif
	colorscheme ayu
	hi Normal guibg=NONE ctermbg=NONE
endfunction

augroup backgr
	autocmd!
	autocmd CursorMoved,CursorHold,CursorHoldI,WinEnter,WinLeave,FocusLost,FocusGained,VimResized,ShellCmdPost * nested call SetColorscheme()
augroup END

" yank highlighting
let g:highlightedyank_highlight_duration = -1

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
