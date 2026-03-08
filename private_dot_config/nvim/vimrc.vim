" set mouse=
" syntax enable
" filetype plugin on
set omnifunc=syntaxcomplete#Complete


" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

set autoindent
set number relativenumber
set hlsearch
set ignorecase
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start
set autoindent
set smartindent
set scrolloff=5

if v:version >= 800
  " better ascii friendly listchars
  set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
endif

" mark trailing spaces as errors
match ErrorMsg /\s\+$/

set ttyfast


fun! TrimWhitespace()
  if exists('b:noStripWhitespace')
    return
  endif
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()
autocmd FileType markdown let b:noStripWhitespace=1

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

map <F4> :set list!<CR>

"from rwxrob: fix bork bash detection
fun! s:DetectBash()
    if getline(1) == '#!/usr/bin/bash' || getline(1) == '#!/bin/bash' || getline(1) == "#!/usr/bin/env bash"
        set ft=bash
        set shiftwidth=2
        set tabstop=2
        set softtabstop=2
    endif
endfun
autocmd BufNewFile,BufRead * call s:DetectBash()

