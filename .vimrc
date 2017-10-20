set nocompatible
set et
set ai
set sw=4
set ts=8
set ruler
set si
set nu
set is
set ic
set sm
set sta
syn on
set backspace=indent,eol,start
set hlsearch
set nobackup
set nowritebackup
set wildmenu
set incsearch
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

hi LineTooLong cterm=bold ctermbg=red guibg=LightYellow

au FileType make set noet

set pastetoggle=<F3>


autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala            setfiletype vala
au BufRead,BufNewFile *.vapi            setfiletype vala

" Disable valadoc syntax highlight
" "let vala_ignore_valadoc = 1
"
" " Enable comment strings
let vala_comment_strings = 1
"
" " Highlight space errors
let vala_space_errors = 1
" " Disable trailing space errors
" "let vala_no_trail_space_error = 1
" " Disable space-tab-space errors
" let vala_no_tab_space_error = 1
"
" " Minimum lines used for comment syncing (default 50)
" "let vala_minlines = 120

autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m