if exists('g:loaded_shadow') | finish | endif
let s:save_cpo = &cpo
set cpo&vim


augroup shadow
  autocmd!
  autocmd BufRead,BufNewFile * call s:shadow_read()
  autocmd FileChangedShell * call s:shadow_force_modeline()
augroup END

function! s:shadow_force_modeline()
  if !filereadable(expand('%') . '.shd') | return | endif
  edit
endfunction

function! s:shadow_read()
  if !filereadable(expand('%') . '.shd') | return | endif
  % delete _
  execute printf("read ++ff=%s %s", &ff, expand("%") . '.shd')
  0 delete _

  augroup shadow-buffer
    autocmd! * <buffer>
    autocmd BufWriteCmd <buffer> call s:shadow_write()
  augroup END
endfunction

function! s:shadow_write()
  if !filereadable(expand('%') . '.shd') | return | endif
  silent execute printf("write! ++ff=%s %s", &ff, expand("%") . '.shd')
  set nomodified

  let system = exists('g:loaded_vimproc') ? 'vimproc#system' : 'system'
  let nl = (&ff == 'mac') ? "\r" : (&ff == 'unix') ? "\n" : "\r\n"

  let cmd = getline(1)[3:-1]
  "let cmd = substitute(cmd, '%', expand('%'), '')
  let body = join(getline(2, '$'), nl)
  let result = {system}(cmd, body)
  call s:writefile_with_ff(result, expand("%"), &ff)
endfunction

function! s:writefile_with_ff(content, fname, ff)
  if a:ff == 'mac'
    echoerr "shadow.vim doesn't support &ff=mac yet."
  elseif a:ff == 'unix'
    call writefile(split(a:content, "\n"), expand("%"), 'b')
  elseif a:ff == 'dos'
    call writefile(map(split(a:content, "\n"), "v:val . \"\\r\""), expand("%"), 'b')
  else
    echoerr "give shadow.vim &ff"
  endif
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
  call GitAdd('')
endfunction

command! -nargs=0 ShadowCancel autocmd! shadow-buffer

let &cpo = s:save_cpo
unlet s:save_cpo
let g:loaded_shadow = 1