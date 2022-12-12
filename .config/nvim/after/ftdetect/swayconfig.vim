augroup init#after#ftdetect#swayconfig
  au!
  au BufNewFile,BufReadPost *sway/config.d/*.conf setf swayconfig
augroup END


