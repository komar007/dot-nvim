" -- basic behaviour
set sessionoptions=buffers,curdir,folds,tabpages
set ignorecase smartcase
set smartindent

" -- filetype customs
autocmd FileType latex                setlocal spell
autocmd FileType c,cpp                set formatoptions=tcqlronj textwidth=78
autocmd FileType cpp,rust             set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType c,cpp                set errorformat=%f:%l:%c:\ error:\ %m,%f:%l:%c:\ warning:\ %m
autocmd FileType c,go                 set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

autocmd BufNewFile,BufRead *.h,*.c set filetype=c

nnoremap <Leader>y mY"*yiw`Y

:command SanitizeXML :%s/>/>\r/g | :%s/</\r</g | :%g/^\s*$/d | :normal gg=G
:command FixStrays :%s/\(^\| \)\([auiwzoAUIWZO]\) /\1\2\~/g

let g:netrw_browsex_viewer = "chromium-browser"

set tags=./tags;/
