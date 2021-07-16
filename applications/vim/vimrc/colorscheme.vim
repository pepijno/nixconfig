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
