nnoremap <space> :exec "Cbreak " . expand("%p") . ":" . line(".")<CR>
nnoremap B :exec "Cbreak " . expand("%p") . ":" . line(".")<CR>
nnoremap R :Crun<CR>
nnoremap <C-N> :Cnext<CR>
nnoremap > :Cnext<CR>
nnoremap . :Cstep<CR>
nnoremap , :Cfinish<CR>
