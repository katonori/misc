"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set params
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmode=list:longest
set smartindent
set expandtab
set incsearch
set sw=4
set bs=2
set tabstop=4
set laststatus=2
set hlsearch
set encoding=utf-8
set ruler
set nonumber
"set number
set statusline=%f:%l(%L)\ %m%r%h%w\ [%{&fenc}][%{&ff}]%y%6l,%-6c[%p%%(%l)]
set cursorline
set cursorcolumn
set fileformats=unix,dos,mac
set grepprg=mgrep
set nf="hex"
set ignorecase
set smartcase
set smarttab
set showcmd
set nowrapscan
set timeoutlen=1000
set directory=~/vim_swap
"set foldmethod=syntax
set foldmethod=marker
set foldlevel=10
set foldlevelstart=10

set guioptions=M
set filetype=off
"set relativenumber number
"set scrolloff=5
set scrolloff=0
let g:clipboard = "tmux"
"set clipboard=
set belloff=all
set completeopt=longest,menuone
"set diffopt=internal,filler,algorithm:histogram,indent-heuristic
set isf-==
set viminfo+='1000,s1000

let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"autocmd BufReadPost * normal g;|zz
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | exe "normal zz"

au! QuickfixCmdPost vimgrep,grep,make if len(getqflist()) != 0 | bo copen | wincmd p | endif

"
" python mode {{{
"
let g:pymode_folding = 0
let g:pymode_lint_ignore = "E501,E226,E225,E228"
let g:pymode_lint_write = 0
autocmd! FileType python
autocmd  FileType python nnoremap <leader>l :PyLint<CR>
" }}}

" md preview
autocmd FileType markdown set makeprg=pandoc\ -r\ markdown\ -t\ html\ -c\ ~/devel/css/markdown.css\ %\ -o\ /tmp/md.html\ &&\ open\ /tmp/md.html
autocmd FileType log set makeprg=cat\ %
autocmd FileType text set makeprg=cat\ %

let g:Gtags_No_Auto_Jump=1
let g:errorformat="%*[^\"]\"%f\"%*\D%l: %m,\"%f\"%*\D%l: %m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l) :%m,%f:%l:%m,\"%f\"\, line %l%*\D%c%*[^ ] %m,%D%*\a[%*\d]: Entering directory %*[`']%f',%X%*\a[%*\d]: Leaving directory %*[`']%f',%D%*\a: Entering directory %*[`']%f',%X%*\a: Leaving directory %*[` ']%f',%DMaking %*\a in %f,%f|%l| %m"
"let &makeprg="make -j " . system('cat /proc/cpuinfo | grep "core id" | wc -l | tr -d "\r" | tr -d "\n"')

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

"
" Tab settings {{{
"
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    <c-t> [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [Tag]l :tablast<CR>
map <silent> [Tag]r :tabnext<CR>
map <silent> [Tag]e :tabprevious<CR>
map <silent> [Tag]c :tab sp<CR>
map <silent> [Tag]n :tabnew .<CR>
map <silent> [Tag]gf <c-w>gf
map <silent> [Tag]gF <c-w>gF
" }}}

"
" filetype
"
autocmd BufRead,BufNewFile *.log setfiletype log
autocmd BufRead,BufNewFile log setfiletype log
autocmd BufRead,BufNewFile log setfiletype log
autocmd BufWritePost COMMIT_EDITMSG !bash $MISC_DIR/git_hook/commit-msg %

augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"cnoremap <C-D> <Del>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <C-A> <Home>
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nnoremap <space>n :next<CR>
nnoremap <space>p :prev<CR>
nnoremap <space>l $
nnoremap <space>h ^
nnoremap * :Search \<<c-r><c-w>\><cr>
nnoremap <Leader><C-M> :make<CR>
nnoremap <C-W>C :cclose<CR>
nnoremap <Leader>C :set cursorcolumn!<CR>
nnoremap <Leader>N :set relativenumber! number!<CR>
nnoremap <Leader>S :if exists("g:syntax_on") \| syntax off \| else \| syntax enable \| endif<CR>
nnoremap <Leader>Q :QuickfixsignsToggle<CR>
nnoremap <C-j> 5j
nnoremap <C-k> 5k
xnoremap <C-j> 5j
xnoremap <C-k> 5k
vnoremap <C-j> 5j
vnoremap <C-k> 5k
nnoremap <c-_>r :reg<cr>
nnoremap <leader>C : <c-r><c-w><Home>
"nnoremap + :let @t=@/<cr>:let @/='[A-Z]'<cr>n:let @/=@t<cr>
"nnoremap - :let @t=@/<cr>:let @/='[A-Z]'<cr>N:let @/=@t<cr>
nnoremap <leader>y :call writefile(split(@@, '\n'), $HOME . "/yank.txt")<cr>
nnoremap <leader>p :read $HOME/yank.txt<cr>
nnoremap cn :cnext<CR>
nnoremap cp :cprev<CR>
nnoremap zn :cnext<cr>
nnoremap zp :cprev<cr>
nnoremap <space>d :silent execute("!echo 'cd " . expand("%:p:h") . "' >" . "~/.vimrc.cwd")<cr><c-l>
nnoremap md d`z
nnoremap my "ry`z<c-o>
nnoremap mD d'z
nnoremap mY "ry'z<c-o>
nnoremap m= ='z<c-o>
nnoremap m> >'z<c-o>
nnoremap m< <'z<c-o>
nnoremap QQ :wqa<cr>
nnoremap <space>F /^[^\t #\/}]<cr>
"nnoremap <space>L /\(\<for\>\)\\|\(\<while\>\)\\|\(\<do\>\)<cr>
nnoremap ( F 
nnoremap ) f 
inoremap <c-s> <esc>:w<cr>
nnoremap <c-s> <esc>:w<cr>
"nnoremap n nzz
nnoremap <c-q> @@
nnoremap <space>[ [`
nnoremap <space>] ]`

nnoremap <m-d> dd
vnoremap <m-d> dd
xnoremap <m-d> dd

noremap <leader>r :%s/<c-r><c-w>/
noremap <leader>lm :REefmMK log<cr>
noremap <leader>s :SvnGetStat 

vnoremap <C-j> 4j
vnoremap <C-k> 4k
vnoremap [[ :<c-u>let @t=@/<cr>:let @/='{'<cr>N:let @/=@t<cr>mv`>V`v
vnoremap ]] :<c-u>let @t=@/<cr>:let @/='}'<cr>`>n:let @/=@t<cr>mv`<V`v
vnoremap <leader>C y: <c-r>"<Home>
vnoremap <leader>r y:%s/<c-r>=escape(@",'\/')<cr>/
vnoremap <silent> * "vy:Search \V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
vnoremap <silent> <leader>g "vy:exec ":vimgrep /" . escape(getreg('v'), '\/') . "/j %"<CR>
"vnoremap <C-R> y:<C-R>=substitute(@", "\n", "", "g")<CR><CR>
vnoremap <C-R> y:call <SID>ExecLines(@")<cr>
function! s:ExecLines(lines) range
    for i in split(a:lines, "\n")
        exec i
    endfor
endfunction

" grep
nnoremap <leader>g :vimgrep /<C-R><C-W>/j %<CR>:let @/="<C-R><C-W>"<CR>:set hlsearch<CR>
nnoremap gG :vimgrep /<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')/j %<CR>

"
" key maps for quickfix
"
autocmd! FileType qf
"autocmd  FileType qf nnoremap <buffer> <CR> <CR>zz:wincmd p<CR>
autocmd  FileType qf nnoremap <buffer> q :wincmd p<CR>:cclose<CR>


nnoremap <leader>C :cclose<cr>

nnoremap mm :marks<cr>
nnoremap mr :reg<cr>

nnoremap <space>f :let @0="+" . line(".") . " " . expand("%:p")<cr>

nnoremap ml :doautocmd User<cr>
nnoremap <space>c :ccl<cr>:copen 50<cr>

" input mode
inoremap <c-b> <left>
inoremap <c-f> <right>
" }}}

command -nargs=0 GetCurFile echo expand("%:p")
command -nargs=0 NOHL :nohl | :SearchReset

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
if has('gui_running')
    colorscheme evening
else
    colorscheme ron
    set bg=dark
endif
"colorscheme evening
" overwrite settings
hi CursorLine term=reverse ctermbg=18 guibg=gray40
hi CursorColumn term=reverse ctermbg=18 guibg=gray40

hi JpSpace cterm=underline ctermbg=red
au BufRead,BufNew * match JpSpace /　/

"hi EasyMotionTarget ctermfg=cyan cterm=bold
hi EasyMotionTarget ctermfg=cyan
hi EasyMotionTarget2First ctermfg=yellow
" }}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Utility functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufWritePost * :call AddExePermission()
function AddExePermission()
    let line = getline(1)
    if strpart(line, 0, 2) == "#!"
        call system("chmod +x ". expand("%"))
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Vundle
"
call plug#begin()

"
" ps.vim {{{
"
Plug 'katonori/ps.vim', {'on': []}
if stridx(system("uname -a "), "Linux") != -1
    let g:PS_PsCmd = "ps axuf"
else
    let g:PS_PsCmd = "ps aux"
endif
let g:PS_KillCmd = "kill -9"
let g:PS_RegExRule = '\w\+\s\+\zs\d\+\ze'
autocmd FileType ps nnoremap <buffer> <silent> K :PsKillLine<CR>
autocmd FileType ps vnoremap <buffer> <silent> K :PsKillAllLines<CR>
autocmd FileType ps nnoremap <buffer> <silent> <C-K> 8k
" }}}

"
" vim-fugitive {{{
"
Plug 'tpope/vim-fugitive', {'on': []}
autocmd! FileType gitcommit
autocmd! FileType gitcommit nmap <c-d> :let @t=winnr()<cr>:normal dd<cr>:exec @t . "wincmd w"<cr>
autocmd! FileType fugitive
autocmd! FileType fugitive nmap <c-d> :let @t=winnr()<cr>:normal dd<cr>:exec @t . "wincmd w"<cr>
" }}}

"Plug 'kana/vim-textobj-user'
let g:textobj_multiblock_blocks = [
    \ [ ",", ","],
    \ [ ",", ")"],
    \ [ "(", ")" ],
    \ [ "[", "]" ],
    \ [ "{", "}" ],
    \ [ '<', '>' ],
    \ [ '"', '"', 1 ],
    \ [ "'", "'", 1 ],
\ ]
omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)


"
" vim-easymotion {{{
"
Plug 'Lokaltog/vim-easymotion', {'on': []}
" Show target key with upper case to improve readability
let g:EasyMotion_use_upper = 1
" Jump to first match with enter & space
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_smartcase = 1
let g:EasyMotion_keys='asdghklwertyuiopzxcvbnmfj;'
" map settings
nmap <space>w <Plug>(easymotion-w)
xmap <space>w <Plug>(easymotion-w)
nmap <space>b <Plug>(easymotion-b)
xmap <space>b <Plug>(easymotion-b)
nmap <space>e <Plug>(easymotion-e)
xmap <space>e <Plug>(easymotion-e)
nmap <space>S <Plug>(easymotion-s2)
xmap <space>S <Plug>(easymotion-s2)
nmap <space>s <Plug>(easymotion-s)
xmap <space>s <Plug>(easymotion-s)
nmap <space>t <Plug>(easymotion-t)
xmap <space>t <Plug>(easymotion-t)
nmap <space>f <Plug>(easymotion-bd-fl)
xmap <space>f <Plug>(easymotion-bd-fl)
nmap <space>j <Plug>(easymotion-j)
xmap <space>j <Plug>(easymotion-j)
nmap <space>k <Plug>(easymotion-k)
xmap <space>k <Plug>(easymotion-k)
" }}}

Plug 'honza/vim-snippets', {'on': []}

"
" unite.vim {{{
"
Plug 'Shougo/denite.nvim', {'on': []}
Plug 'roxma/nvim-yarp', {'on': []}
Plug 'roxma/vim-hug-neovim-rpc', {'on': []}
Plug 'chemzqm/denite-extra', {'on': []}
" Define mappings
autocmd! FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction
let g:unite_source_grep_max_candidates = 200
let g:unite_source_rec_find_args=["-maxdepth=2"]
nnoremap Uu :Unite -direction=below<cr>
nnoremap Uf :Unite -direction=below file_mru<cr>
nnoremap UF :Unite -direction=below file_rec<cr>
nnoremap Ul :Unite -direction=below line<cr>
nnoremap <c-g><c-s> :Snippets<cr>
inoremap <c-g><c-s> <esc>:Snippets<cr>
nnoremap <c-g>f :Denite file_mru<cr>
"nnoremap Uf :History<cr>
"nnoremap UF :Files<cr>
"nnoremap Ul :BLines<cr>
"}}}

Plug 'Shougo/neomru.vim', {'on': []}
Plug 'vim-scripts/MultipleSearch', {'on': []}

"
" Switch.vim {{{
"
Plug 'AndrewRadev/switch.vim', {'on': []}
let g:switch_custom_definitions =
    \ [
    \   {
    \     'True':       'False',
    \     'False':      'True',
    \   },
    \ ]
nnoremap + :Switch<cr>
" }}}


"
" fzf {{{
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all', 'on': [] }
Plug 'junegunn/fzf.vim', {'on': []}
let g:fzf_layout = { 'window': 'bel split' }
"let g:fzf_preview_window = 'right:60%'
let g:fzf_preview_window = []
command! -bang -nargs=* LinesWithPreview
    \ call fzf#vim#grep(
    \   'rg --with-filename --color always --column --line-number --no-heading --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --no-sort --color hl:2,hl+:14'}, 'up:50%', '?'),
    \   1) 
"   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
nnoremap <c-g>g :LinesWithPreview<CR>
nnoremap <c-g>r :Rg <c-r><c-w>
nnoremap <c-g>L :BLines<cr>
nnoremap <c-g>t :Tags<cr>
"let g:fzf_layout = { 'window': '~40%' }
"nnoremap Ff :History!<cr>
nnoremap Ff :call fzf#vim#history(fzf#vim#with_preview('up:30%'), 1)<CR>
" }}}

"Plug 'simeji/winresizer'
"let g:winresizer_vert_resize = 1
"let g:winresizer_horiz_resize = 1
"let g:winresizer_start_key = '<c-x><c-e>'

"
" ultisnips {{{
"
Plug 'SirVer/ultisnips', {'on': []}
let g:UltiSnipsSnippetDirectories=[$MISC_DIR."/UltiSnips"]
let g:UltiSnipsListSnippets="<c-x><c-o>"
let g:UltiSnipsExpandTrigger="<c-o>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

function! UltiSnipsCallUnite()
    Unite -start-insert -winheight=100 -immediately -no-empty ultisnips
    return ''
endfunction

inoremap <silent> <F12> <C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
nnoremap <silent> <F12> a<C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
" }}}

Plug 'vim-scripts/YankRing.vim', {'on': []}

Plug 'osyo-manga/vim-vigemo', {'on': []}
nmap g/ <Plug>(vigemo-search)

Plug 'tomasr/molokai', {'on': []}
Plug 'mechatroner/rainbow_csv', {'on': []}
Plug 'airblade/vim-gitgutter', {'on': []}
hi GitGutterAdd ctermfg=green ctermbg=blue term=bold
hi GitGutterDelete ctermfg=red ctermbg=blue term=bold
hi GitGutterChange ctermfg=yellow ctermbg=blue term=bold
hi GitGutterChangeDelete ctermfg=brown ctermbg=blue term=bold
Plug 'junegunn/vim-peekaboo', {'on': []}
let g:peekaboo_window="vert bo 60new"
Plug 'junegunn/rainbow_parentheses.vim', {'on': []}
Plug 'simeji/winresizer', {'on': []}
let g:winresizer_start_key = '<leader>w'
Plug 'mbbill/undotree', {'on': []}

Plug 'maralla/completor.vim', {'on': []}
let g:completor_disable_ultisnips = 1
let g:completor_auto_trigger = 1
let g:completor_min_chars = 3

Plug 'preservim/nerdcommenter', {'on': []}
Plug 'tpope/vim-surround', {'on': []}

"
" gtags
"
nnoremap <C-G>r :Gtags -r <C-R><C-W><CR>
nnoremap <C-G>d :Gtags <C-R><C-W><CR>
nnoremap <C-G>g :Gtags -g <C-R><C-W><CR>

Plug 'Vimjas/vim-python-pep8-indent', {'on': []}

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

call plug#end()


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gD <plug>(lsp-declaration)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
"command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
"let lsp_log_verbose=1
"let lsp_log_file = expand('~/lsp.log')
let g:lsp_diagnostics_echo_cursor = 1 


" Load Event
function! s:load_plug(timer)
    call plug#load(
                \ 'ps.vim',
                \ 'vim-fugitive',
                \ 'vim-easymotion',
                \ 'vim-snippets',
                \ 'denite.nvim',
                \ 'nvim-yarp',
                \ 'vim-hug-neovim-rpc',
                \ 'denite-extra',
                \ 'neomru.vim',
                \ 'MultipleSearch',
                \ 'switch.vim',
                \ 'fzf',
                \ 'fzf.vim',
                \ )
    call plug#load(
                \ 'ultisnips',
                \ 'YankRing.vim',
                \ 'vim-vigemo',
                \ 'molokai',
                \ 'rainbow_csv',
                \ 'vim-gitgutter',
                \ 'vim-peekaboo',
                \ 'rainbow_parentheses.vim',
                \ 'winresizer',
                \ 'undotree',
                \ 'completor.vim',
                \ 'nerdcommenter',
                \ 'vim-surround',
                \ 'vim-python-pep8-indent',
                \ )
endfunction

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif
let g:lsp_log_file = expand('~/vim-lsp.log') 
call lsp#register_server({
        \ 'name': 'clangd-14',
        \ 'cmd': {server_info->['clangd-14']},
        \ 'allowlist': ['c','cpp'],
        \ })
" load after 500ms
call timer_start(500, function("s:load_plug"))
