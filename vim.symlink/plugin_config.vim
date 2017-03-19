
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => YankRing
""""""""""""""""""""""""""""""
if has("win16") || has("win32")
    " Don't do anything
else
    let g:yankring_history_dir = '~/.vim/temp/'
endif


""""""""""""""""""""""""""""""
" => fugitive
""""""""""""""""""""""""""""""
set diffopt+=vertical


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let g:NERDTreeMinimalUI = 1
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark 
map <leader>nf :NERDTreeFind<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Goyo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => indent highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '┆'
let g:indentLine_faster = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_ignore = ['\m\c\.h$', '\m\.sbt$']

" Scala has fsc and scalac checkers--running both is pretty redundant and
" slow. An explicit `:SyntasticCheck scalac` can always run the other.
let g:syntastic_scala_checkers = ['fsc']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ensime-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Typechecking after writing
autocmd BufWritePost *.scala silent :EnTypeCheck

au FileType scala nnoremap <silent> K :EnType<cr>

au FileType scala nnoremap <leader>r :EnRename<cr>
au FileType scala nnoremap <leader>i :EnAddImport<cr>
au FileType scala nnoremap <leader>I :EnSuggestImport<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-fish
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set up :make to use fish for syntax checking.
compiler fish

" Set this to have long lines wrap inside comments.
setlocal textwidth=79

" Enable folding of block structures in fish.
setlocal foldmethod=expr


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-orgmode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map for pdfpc
map <localleader>pb :OrgExportToBeamerPDF<cr>:!pdfpc %:r.pdf<cr>
" Map for org-latex-export-to-pdf
au FileType org map <leader>xp :! emacs % -q --load %:p:h/emacs.init --batch -f org-latex-export-to-pdf --kill<cr><cr>
" Map for org-beamer-export-to-pdf
au FileType org map <leader>xb :! emacs % -q --load %:p:h/emacs.init --batch -f org-beamer-export-to-pdf --kill<cr><cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map for tagbar
nmap <silent><leader>tt :TagbarToggle<cr>


""""""""""""""""""""""""""""""
" => fzf
""""""""""""""""""""""""""""""
map <leader>gf :GFiles<cr>
map <leader>gs :GFiles?<cr>
map <leader>gc :Commits<cr>
map <leader>gb :BCommits<cr>
map <c-f> :Files<cr>
map <c-b> :Buffers<cr>
map <c-m> :History<cr>
