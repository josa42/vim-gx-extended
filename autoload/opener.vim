function! opener#openVimPlugin(line)
  let p = substitute(substitute(a:line, "^Plug '", '', 1), "'.*", '', 1)

  if match(p, "^[^/]*/[^/]*$") == 0
    call opener#open('https://github.com/' . p)
    return v:true

  elseif match(p, "^[~/].*") == 0
    call opener#open(p)
    return v:true
  endif
endfunction

function! opener#openNpmImport(line)
  let p = a:line
  let p = substitute(p, ';$', '', '')
  let p = substitute(p, '^import\s\s*.*\s\s*from\s\s*', '', '')
  let p = trim(p, "'" . '"')

  call opener#open('https://npmjs.com/package/' . p)

  return v:true
endfunction

function! opener#openNpmRequire(line)
  let p = a:line
  let p = substitute(p, ';$', '', '')
  let p = substitute(p, '^.*require(', '', '')
  let p = substitute(p, ')$', '', '')
  let p = trim(p, "'" . '"')

  call opener#open('https://npmjs.com/package/' . p)

  return v:true
endfunction


" https://github.com/vim/vim/blob/master/runtime/plugin/netrwPlugin.vim
function opener#open(url) abort
  " echom 'open ' . a:url
  call netrw#BrowseX(a:url, v:false)

  " if has("unix") && executable("exo-open") && executable("xdg-open") && executable("setsid")
  "  call s:shell("setsid xdg-open " . shellescape(a:url) . '&')
  "  " let ret= v:shell_error
  "
  " elseif has("unix") && executable("xdg-open")
  "  call s:shell("xdg-open ".shellescape(a:url) . '&')
  "  " let ret= v:shell_error
  "
  " elseif has("macunix") && executable("open")
  "  call s:shell("open " . shellescape(a:url))
  "  " let ret= v:shell_error
  " else
  "   " error no support
  " endif
endfunction

" function! s:shell(cmd)
"   execute 'silent !' + a:cmd
" endfun
