" select all
nnoremap sa ggVG

" map kj to escape
inoremap kj <ESC>
cnoremap kj <ESC>
vnoremap kj <ESC>

" Move lines
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==li
inoremap <C-k> <esc>:m .-2<CR>==li
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Undo breakpoints
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ` `<C-g>u
inoremap ; ;<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap { {<C-g>u
inoremap } }<C-g>u
inoremap ( (<C-g>u
inoremap ) )<C-g>u
inoremap [ [<C-g>u
inoremap ] ]<C-g>u

" (Un)quote word
nnoremap <leader>q" ciw""<Esc>P
nnoremap <leader>q' ciw''<Esc>P
nnoremap <leader>qd daW"=substitute(@@,"'\\\|\"","","g")<CR>P

" Create new file
nnoremap <leader>cf :e %:h/

" Reload vimrc
nnoremap <silent> <leader>rc :so $HOME/.config/nvim/init.vim<CR>
