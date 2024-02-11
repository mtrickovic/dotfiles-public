" This is my personal vimrc file for enhanced editing experience and
" productivity.

set nocompatible    " Disable compatibility with vi.

filetype on         " Enable file type detection.
syntax on           " Turn on syntax highlighting.

set number          " Add line numbers.

set nobackup        " Do not save backup files.
set fileencoding=utf-8    " Set file encoding to UTF-8.

set confirm        " Confirm :q in case of unsaved changes.

set shiftwidth=4   " Set shift width to 4 spaces.
set tabstop=4      " Set tab width to 4 columns.
set expandtab      " Use spaces instead of tabs.

set nowrap         " Do not wrap lines.

set ignorecase     " Ignore capital letters during search.
set smartcase      " Override ignorecase for capital letters.
set incsearch      " Incrementally highlight matching characters during search.
set hlsearch       " Use highlighting when doing a search.

set autoindent     " Enable automatic indentation (based on the previous line).

set textwidth=80   " Set the maximum width to 80 columns
set colorcolumn=80 " Set highlights the 80th column with a different color

set backspace=indent,eol,start  " Allow backspacing over indentation,
                                " line breaks, and the start of insert mode

autocmd FileType java setlocal textwidth=132   " Tune textwidth for Java code.
autocmd Filetype makefile setlocal noexpandtab " Don't replace tabs with spaces
                                               " when editing makefiles.
autocmd FileType tex,xml setlocal indentexpr=  " Disable automatic code
                                               " indentation when editing TeX
                                               " and XML files.
autocmd BufWritePre * :%s/\s\+$//e | :%s/\%$/\r/    " Add a new line at the end
                                                    " of the file beofre saving.

noremap n nzz                   " Center view on the search result.
noremap <F4> mqggVG=`qzz        " Fix indentation in whole file;
                                " overwrites marker 'q' position.
noremap <F12> :set list!<CR>    " Toggle showing the non-printable characters.

inoremap <F4> <Esc>mqggVG=`qzza " Fix indentation in whole file; overwrites
                                " marker 'q' position.
inoremap <F8> <Esc>:nohl<CR>a   " Turn the search results highlight off.

vnoremap <F5> :sort i<CR>       " Sort selection or paragraph.

inoremap jj <Esc>               " Exit to Normal mode.

if has('gui_running')
    set background=light        " Set a light background for GUI.
else
    set background=dark         " Set a dark background for console.
endif
