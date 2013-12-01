scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_hateblo#define()
	return s:converter
endfunction


let s:converter = {
\	"name" : "converter_hateblo",
\	"description" : "date - title"
\}


function! s:converter.filter(candidates, context)
	let candidates = deepcopy(a:candidates)

	for candidate in candidates
    let title = matchstr(candidate.word, '\zs.*\ze (')
    let time  = matchstr(candidate.word, '(\zs[0-9]\{4}-[0-9]\{2}-[0-9]\{2}\zeT.*)$')
    if title != ''
		  let candidate.abbr = time . ' ' . title
    endif
	endfor
	return candidates
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
