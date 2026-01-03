" Enable syntax highlighting
syntax on  " Highlights syntax based on file type (e.g., keywords, comments, strings)

" Enable file type detection and associated plugins
filetype on          " Detect the type of file being edited
filetype plugin on   " Enable file type-specific plugins
filetype indent on   " Enable file type-specific indentation rules

" Set the color scheme to Dracula (ensure it is installed)
" colorscheme dracula  " Provides a dark, modern aesthetic with high contrast

" Define the leader key for custom mappings (here, it's space)
let mapleader=" "    " Leader key simplifies custom key bindings

" Enable mouse support in all modes (normal, insert, visual, etc.)
set mouse=a          " Allows mouse clicks for selection, scrolling, resizing

" Disable Vi compatibility mode
set nocompatible     " Enables modern Vim features, improving functionality

" Customize backspace behavior for convenience
set backspace=indent,eol,start " Allows backspacing over indentation, line breaks, and insertion points

" Display line numbers and relative line numbers
set number           " Shows absolute line numbers for easy navigation
set relativenumber   " Displays relative numbers for quick line movements (e.g., 5j)

" Highlight the line where the cursor is located
set cursorline       " Improves visibility of the current editing location

" Customize search behavior
set ignorecase       " Case-insensitive searching for convenience
set smartcase        " Makes searches case-sensitive if uppercase letters are used
set incsearch        " Shows search matches as you type
set hlsearch         " Highlights all matches for the current search

" Set history and command-line completion
set history=1000     " Stores 1000 commands and search entries for reuse
set wildmenu         " Enhances command-line completion with a visual menu
set wildmode=list:longest " Completes the longest match and lists all options

" Display a detailed status line
set statusline=      " Clear the default status line
set statusline+=\ %F\ %M\ %Y\ %R  " Show file name, modified status, and readonly flag
set statusline+=%=   " Center the remaining status line content
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ " Add buffer, position, and encoding info
set laststatus=2     " Always display the status line

" Set encoding for files and the editor
set encoding=utf-8       " Sets the internal character encoding to UTF-8
set fileencoding=utf-8   " Saves files using UTF-8 encoding

" Enable undo history persistence
set undodir=~/.vim/undodir  " Directory to store undo files (must exist or be created)
set undofile                " Saves undo history for each file, even across sessions

" Integrate system clipboard for yank and paste
set clipboard=unnamed  " Uses the system clipboard by default, improving integration with macOS

" Configure indentation and tab settings
set expandtab      " Converts tabs to spaces, ensuring consistent alignment
set shiftwidth=4   " Sets the width for each level of auto-indentation
set tabstop=4      " Sets the number of spaces a tab character represents
set autoindent     " Copies the previous line's indentation automatically
set smartindent    " Adds intelligent indentation based on code structure

" Improve completion menu behavior
set completeopt=menu,menuone,noselect  " Shows a menu for completion but doesn’t auto-select items

" Optimize redraw behavior for performance
set lazyredraw     " Skips unnecessary screen redraws, improving speed for large files
 
