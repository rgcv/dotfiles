augroup init#after#ftdetect#i3
  au!
  " set ft to i3 config for *.conf files
  au BufNewFile,BufRead *i3/conf.d/*.conf setf i3config
  " read skeleton i3 config file on new file
  au BufNewFile *i3/conf.d/*.conf 0read ~/.config/i3/conf.d/skel | exe "normal! G"
  " auto merge+reload i3 config
  au BufWritePost *i3/conf.d/*.conf silent !~/.local/bin/i3merge reload
augroup END
