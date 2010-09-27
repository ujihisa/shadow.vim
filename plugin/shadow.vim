if exists('g:loaded_shadow') | finish | endif
let s:save_cpo = &cpo
set cpo&vim


augroup shadow
  autocmd!
  autocmd BufReadPost * call s:shadow_read()
augroup END

function! s:shadow_read()
  if !filereadable(expand('%') . '.shd') | return | endif
  let b:actual = expand("%")
  let b:shadow = b:actual . ".shd"

  autocmd BufWriteCmd <buffer> call s:shadow_write()

  % delete _
  call setline(1, readfile(b:shadow, 'b'))
endfunction

function! s:shadow_write()
  if !filereadable(expand('%') . '.shd') | return | endif
  call writefile(getline(1, '$'), b:shadow, 'b')
  set nomodified

  let system = exists('g:loaded_vimproc') ? 'vimproc#system' : 'system'
  let nl = (&ff == 'mac') ? "\r" : (&ff == 'unix') ? "\n" : "\r\n"

  let cmd = getline(1)[3:-1]
  "let cmd = substitute(cmd, '%', expand('%'), '')
  let body = join(getline(2, '$'), nl)
  let result = {system}(cmd, body)
  call writefile(split(result, nl), b:actual, 'b')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
let g:loaded_shadow = 1
