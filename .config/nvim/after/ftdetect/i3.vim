augroup init#after#ftdetect#i3
  autocmd!
  " set ft to i3 config for *.conf files (works well with i3-vim-syntax)
  autocmd BufNewFile,BufReadPost *i3/conf.d/*.conf,*sway/conf.d/*.conf setf i3
  " auto merge+reload i3 config
  autocmd BufWritePost *i3/conf.d/*.conf silent !~/.local/bin/i3merge reload
  " auto reload sway config
  autocmd BufWritePost ~/.sway/config,~/.config/sway/config,*sway/conf.d/*.conf silent !swaymsg reload
  " read skeleton i3 config file on new file
  autocmd BufNewFile *i3/conf.d/*.conf 0read ~/.config/i3/conf.d/skel | exe "normal! G"
augroup END

