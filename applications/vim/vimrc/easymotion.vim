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

