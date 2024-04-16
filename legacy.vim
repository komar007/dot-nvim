" -- neovide
set gfn=Jetbrains\ Mono\ Light:h9
set linespace=-4
let g:neovide_cursor_animation_length=0.07
let g:neovide_cursor_trail_size=0.05
let g:neovide_scroll_animation_length=0

" -- basic behaviour
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set sessionoptions=buffers,curdir,folds,tabpages
set ignorecase smartcase
set autoindent smartindent

autocmd BufEnter * let &titlestring = "vim - " . expand("%:t")
set title

" -- look and feel
set cursorline
set number
set wildmenu
set wildmode=longest,list,list,full
set mouse=a
set mousemodel=extend
set timeoutlen=500

map <F2> :set cursorcolumn!<CR>
map <F3> :IBLToggle<CR>

" -- filetype customs
autocmd FileType latex                setlocal spell
autocmd FileType c,cpp                compiler gcc
autocmd FileType c,cpp                set formatoptions=tcqlronj textwidth=78
autocmd FileType c,cpp,rust           set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType c,cpp                set errorformat=%f:%l:%c:\ error:\ %m,%f:%l:%c:\ warning:\ %m

nmap <Leader> :A<CR>

autocmd FileType pascal               compiler fpc
autocmd FileType haskell              set expandtab
autocmd FileType java,cs,python,json  set tabstop=4 shiftwidth=4 expandtab
autocmd FileType make                 set tabstop=8 shiftwidth=8 noexpandtab
autocmd FileType html,xhtml,eruby,xml set tabstop=2 shiftwidth=2 expandtab

autocmd BufNewFile,BufRead *.h,*.c set filetype=c

nnoremap <Leader>y mY"*yiw`Y

:command SanitizeXML :%s/>/>\r/g | :%s/</\r</g | :%g/^\s*$/d | :normal gg=G
:command FixStrays :%s/\(^\| \)\([auiwzoAUIWZO]\) /\1\2\~/g

let g:netrw_browsex_viewer = "chromium-browser"

set tags=./tags;/

" easier combo than ctrl+shift+6
nnoremap <silent> <C-6> <C-^>

set inccommand=split

set updatetime=500
if exists('+nocscopeverbose')
  set nocscopeverbose
endif

" next/prev problem
nnoremap <silent> ]l :lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> [l :lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> gl :lua vim.diagnostic.open_float()<CR>

set scrolloff=10

:command Fmt lua vim.lsp.buf.format()
