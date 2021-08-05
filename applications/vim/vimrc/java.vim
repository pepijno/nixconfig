autocmd BufNewFile,BufRead *.java set filetype=java
function! JavaPrefFunction()
	syntax enable
	filetype plugin indent on

	let g:ale_linters = {
				\  'java': ['analyzer'],
				\}

	let g:ale_fixers = { 'java': ['checkstyle', 'trim_whitespace', 'remove_trailing_lines'] }

	" Optional, configure as-you-type completions
	set completeopt=menu,menuone,preview,noselect,noinsert
	let g:ale_completion_enabled = 1

	nnoremap <Leader>ag :ALEGoToDefinition<CR>
	nnoremap <Leader>af :ALEFix<CR>
	nnoremap <Leader>al :ALELint<CR>
endfunction
autocmd Filetype java call JavaPrefFunction()
