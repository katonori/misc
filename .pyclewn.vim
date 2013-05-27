nnoremap <space> :exec "Cbreak " . expand("%p") . ":" . line(".")<CR>
nnoremap B :exec "Cbreak " . expand("%p") . ":" . line(".")<CR>
nnoremap r :Crun<CR>
nnoremap c :Ccontinue
nnoremap <C-N> :Cnext<CR>
nnoremap > :Cnext<CR>
nnoremap . :Cstep<CR>
nnoremap , :Cfinish<CR>

nnoremap PP :Cprint <C-R><C-W>
nnoremap PO :Cprint *<C-R><C-W>
nnoremap P` :Cdbgvar <C-R><C-W>
"exec ":Csymcompletion"
