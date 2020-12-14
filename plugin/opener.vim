let g:opener = {}

augroup opener_config
  autocmd!

  autocmd FileType vim call opener#appendRules('open', [
    \   ["^Plug '.*'", function('opener#openVimPlugin')],
    \ ])
  autocmd FileType javascript call opener#appendRules('open', [
    \   ["^import ", function('opener#openNpmImport')],
    \   ['^.*require\(.*\)', function('opener#openNpmRequire')],
    \ ])

  autocmd FileType vim call opener#appendRules('goto', [
    \   ['^.*lua +require\(.*\)', function('opener#gotoLuaRequire')],
    \ ])
  autocmd FileType lua call opener#appendRules('goto', [
    \   ['^.*require\(.*\)', function('opener#gotoLuaRequire')],
    \ ])
  autocmd FileType javascript call opener#appendRules('goto', [
    \   ['.*', function('opener#gotoGlob')],
  \ ])
augroup END

nnoremap <silent> gx :call opener#open()<cr>
nnoremap <silent> gf :call opener#goto('edit')<cr>
nnoremap <silent> gF :call opener#goto('tabe')<cr>

