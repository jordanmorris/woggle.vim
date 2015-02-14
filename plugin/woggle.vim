set nocompatible
vnoremap <C-C> "+y
execute pathogen#infect()
execute pathogen#helptags()
set clipboard=unnamed
set nobackup
colorscheme darkblue
set wrap
set linebreak
set nolist
set wrapmargin=0
set shiftwidth=4
set tabstop=4
set expandtab
set nu

map <A-p> :CtrlPBuffer<CR>

"NERDTree stuff BEGIN
"How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"
map <C-n>n :NERDTreeToggle<CR>
map <C-n>1 :NERDTreeFromBookmark Club3<CR>

let originalHorizontalWindowNumber = -1
let originalVerticalWindowNumber = -1
let extremeLeft = -1
let extremeUpper = -1
let middlish = 0
let extremeRight = 1
let extremeLower = 1

function GetHorizontalWindowPos()
    let startWindowNumber = winnr()
    execute "normal! \<C-w>h"
	let isExtremeLeft = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeLeft
		return g:extremeLeft
	endif
    execute "normal! \<C-w>l"
	let isExtremeRight = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeRight
		return g:extremeRight
	endif
	return g:middlish
endfunction

function GetVerticalWindowPos()
    let startWindowNumber = winnr()
    execute "normal! \<C-w>k"
	let isExtremeUpper = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeUpper
		return g:extremeUpper
	endif
    execute "normal! \<C-w>j"
	let isExtremeLower = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeLower
		return g:extremeLower
	endif
	return g:middlish
endfunction

function IsFullHeightWindow(windowNumber)
    let startWindowNumber = winnr()
	:exe a:windowNumber . "wincmd w"
    execute "normal! \<C-w>k"
	let isExtremeUpper = winnr() == a:windowNumber
	:exe a:windowNumber . "wincmd w"
    execute "normal! \<C-w>j"
	let isExtremeBottom = winnr() == a:windowNumber
	:exe startWindowNumber . "wincmd w"
	return isExtremeUpper && isExtremeBottom
endfunction

function IsFullWidthWindow(windowNumber)
    let startWindowNumber = winnr()
	:exe a:windowNumber . "wincmd w"
    execute "normal! \<C-w>h"
	let isExtremeLeft = winnr() == a:windowNumber
	:exe a:windowNumber . "wincmd w"
    execute "normal! \<C-w>l"
	let isExtremeRight = winnr() == a:windowNumber
	:exe startWindowNumber . "wincmd w"
	return isExtremeLeft && isExtremeRight
endfunction

function ToggleWindowHorizontally()
    let horizontalWindowPos = GetHorizontalWindowPos()
	if horizontalWindowPos == g:middlish | return | endif
	let startWindowNumber = winnr()
	if g:originalHorizontalWindowNumber != -1 && IsFullHeightWindow(startWindowNumber)
		:exe g:originalHorizontalWindowNumber . "wincmd w"
		if winnr() != startWindowNumber
			let g:originalHorizontalWindowNumber = startWindowNumber
			return
		endif
	endif
	if horizontalWindowPos == g:extremeLeft
		execute "normal! \<C-w>l"
	else
		execute "normal! \<C-w>h"
	endif
	if winnr() != startWindowNumber
		let g:originalHorizontalWindowNumber = startWindowNumber
	else
		let g:originalHorizontalWindowNumber = -1
	endif
endfunction

function ToggleWindowVertically()
    let verticalWindowPos = GetVerticalWindowPos()
	if verticalWindowPos == g:middlish | return | endif
	let startWindowNumber = winnr()
	if g:originalVerticalWindowNumber != -1 && IsFullWidthWindow(startWindowNumber)
		:exe g:originalVerticalWindowNumber . "wincmd w"
		if winnr() != startWindowNumber
			let g:originalVerticalWindowNumber = startWindowNumber
			return
		endif
	endif
	if verticalWindowPos == g:extremeUpper
		execute "normal! \<C-w>j"
	else
		execute "normal! \<C-w>k"
	endif
	if winnr() != startWindowNumber
		let g:originalVerticalWindowNumber = startWindowNumber
	else
		let g:originalVerticalWindowNumber = -1
	endif
endfunction

noremap <tab> :call ToggleWindowHorizontally()<CR>
noremap <space> :call ToggleWindowVertically()<CR>

"NERDTree stuff END
