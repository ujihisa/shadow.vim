if exists('g:loaded_shadow') | finish | endif
let s:save_cpo = &cpo
set cpo&vim


augroup shadow
  autocmd!
  autocmd BufRead,BufNewFile * call s:shadow_read()
augroup END

function! s:shadow_read()
  if !filereadable(expand('%') . '.shd') | return | endif
  % delete _
  call setline(1, readfile(expand("%") . '.shd', 'b'))

  autocmd BufWriteCmd <buffer> call s:shadow_write()
endfunction

function! s:shadow_write()
  if !filereadable(expand('%') . '.shd') | return | endif
  call writefile(getline(1, '$'), expand("%") . '.shd', 'b')
  set nomodified

  let system = exists('g:loaded_vimproc') ? 'vimproc#system' : 'system'
  let nl = (&ff == 'mac') ? "\r" : (&ff == 'unix') ? "\n" : "\r\n"

  let cmd = getline(1)[3:-1]
  "let cmd = substitute(cmd, '%', expand('%'), '')
  let body = join(getline(2, '$'), nl)
  let result = {system}(cmd, body)
  call writefile(split(result, nl), expand("%"), 'b')
endfunction

" for debug
if exists('g:shadow_debug')
  nnoremap <Space>- :<C-u>QuickRun cat -into 1<Cr>
endif

" experimental functions
function! Shadowize()
  if filereadable(expand("%") . '.shd')
    echoerr "The shadow file already exists"
    return
  endif
  call system(printf("cp %s %s", expand("%"), expand("%") . '.shd'))
endfunction

function! GitAddBoth()
  if filereadable(expand("%") . '.shd')
    call GitAdd(expand("%") . '.shd')
  endif
  call GitAdd()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
let g:loaded_shadow = 1
