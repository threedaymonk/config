if !exists('g:test#ruby#testrbl#file_pattern')
  let g:test#ruby#testrbl#file_pattern = '\v_test\.rb$'
endif

function! test#ruby#testrbl#test_file(file) abort
  return a:file =~# g:test#ruby#testrbl#file_pattern
endfunction

function! test#ruby#testrbl#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#testrbl#build_args(args) abort
  return a:args
endfunction

function! test#ruby#testrbl#executable() abort
  return 'testrbl -Itest'
endfunction
