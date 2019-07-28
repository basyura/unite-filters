function! unite#filters#sorter_go_imports#define()
  return s:sorter
endfunction

let s:sorter = {
      \ 'name' : 'sorter_go_imports',
      \ 'description' : 'sort go imports',
      \}

function! s:sorter.filter(candidates, context)
  return sort(a:candidates, function('s:sort'))
endfunction

function! s:sort(lhs, rhs)
  if a:lhs.word =~ '\/'
    if a:rhs.word =~ '\/'
      return a:lhs.word < a:rhs.word ? -1 : 1
    endif
    return 1
  endif

  if a:rhs.word =~ '\/'
    return -1
  endif

  return a:lhs.word < a:rhs.word ? -1 : 1
       
endfunction
