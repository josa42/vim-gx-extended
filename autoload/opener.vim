function! opener#open()
  let line = getline(line('v'))

  let rules = s:getRules('opener_open')

  for rules in rules
    if match(line, rule[0]) == 0
      if rule[1](line) == v:true
        return
      endif
    endif
  endfor

  let gx = netrw#GX()
  if match(gx, '\vhttps?://') == 0
    return opener#openURL(gx)
  endif

  call netrw#BrowseX(gx, netrw#CheckIfRemote(gx))
endfunction

function! opener#goto(cmd)
  let line = getline(line('v'))

  let rules = s:getRules('opener_goto')

  for rule in rules
    if match(line, rule[0]) == 0
      if rule[1](line, a:cmd) == v:true
        return
      endif
    endif
  endfor

  normal! gf
endfunction

function s:getRules(key)
  return get(g:, a:key, []) + get(b:, a:key, [])
endfunction

function! opener#appendRules(key, rules)
  let key = 'opener_' . a:key
  let b:[key] = get(b:, key, []) + a:rules
endfunction

function! opener#openVimPlugin(line)
  let p = substitute(substitute(a:line, "^Plug '", '', 1), "'.*", '', 1)

  if match(p, "^[^/]*/[^/]*$") == 0
    call opener#openURL('https://github.com/' . p)
    return v:true

  elseif match(p, "^[~/].*") == 0
    call opener#openURL(p)
    return v:true
  endif
endfunction

function! opener#openNpmImport(line)
  let p = a:line
  let p = substitute(p, ';$', '', '')
  let p = substitute(p, '^import\s\s*.*\s\s*from\s\s*', '', '')
  let p = trim(p, "'" . '"')

  call opener#openURL('https://npmjs.com/package/' . p)

  return v:true
endfunction

function! opener#openNpmRequire(line)
  let p = a:line
  let p = substitute(p, ';$', '', '')
  let p = substitute(p, '^.*require(', '', '')
  let p = substitute(p, ')$', '', '')
  let p = trim(p, "'" . '"')

  call opener#openURL('https://npmjs.com/package/' . p)

  return v:true
endfunction

function! opener#gotoLuaRequire(line, cmd)
  let p = a:line
  let p = substitute(p, ';$', '', '')
  let p = substitute(p, '^.*require(', '', '')
  let p = substitute(p, ')$', '', '')
  let p = trim(p, "'" . '"')

  " call opener#openURL('https://npmjs.com/package/' . p)
  echo p

  for path in split(&rtp, ',')
    let fpath = path . '/lua/' . substitute(p, '\.', '/', 'g') . '.lua'
    if s:exists(fpath)
      execute a:cmd . ' ' . fpath
      return v:true
    endif
  endfor

  return v:false
endfunction

function! opener#gotoGlob(line, cmd)
  let path = expand('<cfile>')
  let glob_root = get(g:, 'opener_glob_root', '**')
  let files = glob(glob_root . '/' . path . '*', v:false, v:true)
  if len(files) > 0
    echo files[0]
    execute a:cmd . ' ' . files[0]
    return v:true
  end

endfunction

function! s:exists(fpath)
  return empty(glob(a:fpath)) == 0
endfunction

" https://github.com/vim/vim/blob/master/runtime/plugin/netrwPlugin.vim
function! opener#openURL(url) abort
  call netrw#BrowseX(a:url, v:false)
endfunction

