"Enables intuitive navigation between windows in vim.
"Note that this script assumes the CTRL+[hjkl] shortcuts have their default
"actions

"Map the Tab and Space keys to the window toggle commands
noremap <silent> <tab> :call WoggleHorizontally()<CR>
noremap <silent> <space> :call WoggleVertically()<CR>

"Map the arrow keys to the corresponding window move commands
noremap <up> <C-w>k
noremap <down> <C-w>j
noremap <left> <C-w>h
noremap <right> <C-w>l

let s:originalHorizontalWindowNumber = -1
let s:originalVerticalWindowNumber = -1
let s:extremeLeft = -1
let s:extremeUpper = -1
let s:middlish = 0
let s:extremeRight = 1
let s:extremeLower = 1

function s:GetHorizontalWindowPos()
    let startWindowNumber = winnr()
    execute "normal! \<C-w>h"
	let isExtremeLeft = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeLeft
		return s:extremeLeft
	endif
    execute "normal! \<C-w>l"
	let isExtremeRight = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeRight
		return s:extremeRight
	endif
	return s:middlish
endfunction

function s:GetVerticalWindowPos()
    let startWindowNumber = winnr()
    execute "normal! \<C-w>k"
	let isExtremeUpper = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeUpper
		return s:extremeUpper
	endif
    execute "normal! \<C-w>j"
	let isExtremeLower = winnr() == startWindowNumber
	:exe startWindowNumber . "wincmd w"
	if isExtremeLower
		return s:extremeLower
	endif
	return s:middlish
endfunction

function s:IsFullHeightWindow(windowNumber)
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

function s:IsFullWidthWindow(windowNumber)
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

function WoggleHorizontally()
    let horizontalWindowPos = s:GetHorizontalWindowPos()
	if horizontalWindowPos == s:middlish | return | endif
	let startWindowNumber = winnr()
	if s:originalHorizontalWindowNumber != -1 && s:IsFullHeightWindow(startWindowNumber)
		:exe s:originalHorizontalWindowNumber . "wincmd w"
		if winnr() != startWindowNumber
			let s:originalHorizontalWindowNumber = startWindowNumber
			return
		endif
	endif
	if horizontalWindowPos == s:extremeLeft
		execute "normal! \<C-w>l"
	else
		execute "normal! \<C-w>h"
	endif
	if winnr() != startWindowNumber
		let s:originalHorizontalWindowNumber = startWindowNumber
	else
		let s:originalHorizontalWindowNumber = -1
	endif
endfunction

function WoggleVertically()
    let verticalWindowPos = s:GetVerticalWindowPos()
	if verticalWindowPos == s:middlish | return | endif
	let startWindowNumber = winnr()
	if s:originalVerticalWindowNumber != -1 && s:IsFullWidthWindow(startWindowNumber)
		:exe s:originalVerticalWindowNumber . "wincmd w"
		if winnr() != startWindowNumber
			let s:originalVerticalWindowNumber = startWindowNumber
			return
		endif
	endif
	if verticalWindowPos == s:extremeUpper
		execute "normal! \<C-w>j"
	else
		execute "normal! \<C-w>k"
	endif
	if winnr() != startWindowNumber
		let s:originalVerticalWindowNumber = startWindowNumber
	else
		let s:originalVerticalWindowNumber = -1
	endif
endfunction
