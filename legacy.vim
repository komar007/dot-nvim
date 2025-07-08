autocmd FileType c,cpp set errorformat=%f:%l:%c:\ error:\ %m,%f:%l:%c:\ warning:\ %m
autocmd BufNewFile,BufRead *.h,*.c set filetype=c

:command SanitizeXML :%s/>/>\r/g | :%s/</\r</g | :%g/^\s*$/d | :normal gg=G
:command FixStrays :%s/\(^\| \)\([auiwzoAUIWZO]\) /\1\2\~/g

let g:netrw_browsex_viewer = "chromium-browser"
