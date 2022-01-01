setlocal textwidth=100
augroup init#after#ftplugin#pkgbuild
  autocmd!
  autocmd FileWritePost PKGBUILD !updpkgsums % && makepkg --printsrcinfo > %:h/.SRCINFO
augroup END
