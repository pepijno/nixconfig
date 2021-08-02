autocmd BufNewFile,BufRead *.rs set filetype=rust
function! RustPrefFunction()
	syntax enable
	filetype plugin indent on

	let g:ale_linters = {
				\  'rust': ['analyzer'],
				\}

	let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }

	" Optional, configure as-you-type completions
	set completeopt=menu,menuone,preview,noselect,noinsert
	let g:ale_completion_enabled = 1

	nnoremap <Leader>ag :ALEGoToDefinition<CR>
	nnoremap <Leader>af :ALEFix<CR>
	nnoremap <Leader>al :ALELint<CR>
endfunction
autocmd Filetype rust call RustPrefFunction()
