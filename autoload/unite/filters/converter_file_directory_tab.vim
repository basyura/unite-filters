"original is unite.vim's converter_file_directory
"
"=============================================================================
" FILE: converter_file_directory_tab.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu (at) gmail.com>
"          basyura <basyura (at) gmail.com>
" Last Modified: 10 May 2013.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_file_directory_tab#define() "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_file_directory_tab',
      \ 'description' : 'converter to separate file and directory',
      \}

function! s:converter.filter(candidates, context)
  let candidates = copy(a:candidates)

  let max = min([max(map(copy(candidates), "
        \ unite#util#wcswidth(s:convert_to_abbr(
        \  get(v:val, 'action__path', v:val.word), a:context))"))+2,
        \ get(g:, 'unite_converter_file_directory_width', 45)])

  for candidate in candidates

    let path = get(candidate, 'action__path', candidate.word)

    if a:context.source.name == 'tab'
      let path = substitute(path, ' (.*)$', '', '')
      let path = substitute(path, '.\{-} ', '', '')
      if path =~ '^Users'
        let path = '/' . path
      endif
      let candidate.word = path
      let abbr = fnamemodify(path, ':p:t')
    else
      let abbr = s:convert_to_abbr(path, a:context)
    endif

    let abbr = unite#util#truncate(abbr, max) . ' '
    let path = unite#util#substitute_path_separator(
          \ fnamemodify(path, ':~:.:h'))
    let path = substitute(path, '^' . $HOME, '~', '')
    if path ==# '.'
      let path = ''
    endif
    let candidate.abbr = abbr . unite#util#truncate_smart(path, winwidth(0) - max - 8, 10, '...')
  endfor

  return candidates
endfunction

function! s:convert_to_abbr(path, context)
  if a:context.source.name == 'tab'
    let path = a:path
    let path = substitute(path, ' (.*)$', '', '')
    let path = substitute(path, '.\{-} ', '', '')
    return fnamemodify(path, ':p:t')
  endif
  return printf('%s (%s)', fnamemodify(a:path, ':p:t'),
        \ fnamemodify(a:path, ':p:h:t'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
