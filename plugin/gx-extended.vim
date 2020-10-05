let g:opener = {}

augroup gx-extended
  autocmd!
  autocmd FileType * let b:opener = {}
  autocmd FileType vim call extend(b:opener, {
    \   "^Plug '.*'": function('opener#openVimPlugin'),
    \ })
  autocmd FileType javascript call extend(b:opener, {
    \   "^import ": function('opener#openNpmImport'),
    \   '^.*require\(.*\)': function('opener#openNpmRequire'),
    \ })
augroup END

function! OpenLine()
  let line = getline(line('v'))

  let opener = extend(copy(g:opener), b:opener)

  for p in items(opener)
    if match(line, p[0]) == 0
      if p[1](line) == v:true
        return
      endif
    endif
  endfor

  call netrw#BrowseX(netrw#GX(), netrw#CheckIfRemote(netrw#GX()))
endfunction

nnoremap <silent> gx :call OpenLine()<cr>
