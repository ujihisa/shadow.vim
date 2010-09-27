augroup shadow
  autocmd!
  autocmd BufReadPost * call ShadowRead()
  autocmd BufWritePre * call ShadowWritePre()
  autocmd BufWritePost * call ShadowWritePost()
augroup END

function! ShadowRead()
  let b:actual = expand("%")
  let b:shadow = b:actual . ".shd"
  if !filereadable(b:shadow) | return | endif

  call setline(1, readfile(b:shadow, 'b'))
endfunction

function! ShadowWritePre()
  if !filereadable(b:shadow) | return | endif
  call writefile(getline(1, '$'), b:shadow, 'b')
endfunction

function! ShadowWritePost()
  if !filereadable(b:shadow) | return | endif

  let system = (globpath(&rtp, 'plugin/vimproc.vim') != '') ? 'vimproc#system' : 'system'
  let nl = (&ff == 'mac') ? "\r" : (&ff == 'unix') ? "\n" : "\r\n"

  let cmd = getline(1)[3:-1]
  "let cmd = substitute(cmd, '%', expand('%'), '')
  let body = join(getline(2, '$'), nl)
  let result = {system}(cmd, body, 'b')
  call writefile(split(result, nl), b:actual, 'b')
endfunction
