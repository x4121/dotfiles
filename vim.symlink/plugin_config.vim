
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
map <leader>nb :NERDTreeFromBookmark<space>
map <leader>nf :NERDTreeFind<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Goyo & Limelight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  IndentLinesDisable
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=7
  Limelight!
  IndentLinesEnable
endfunction

" solarized base01
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = '#585858'

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


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
nmap <leader>gf :GFiles<cr>
nmap <leader>gs :GFiles?<cr>
nmap <leader>gc :Commits<cr>
nmap <leader>gb :BCommits<cr>
nmap <c-f> :Files<cr>
nmap <c-b> :Buffers<cr>
nmap <c-m> :History<cr>
nmap <c-s> :Rg<space>
map <cr> <cr>

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Search content with ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings'
  \     .' --ignore-case --hidden --follow --glob "!.git/*"'
  \     .' --color "always" '.shellescape(<q-args>), 1, <bang>0)


""""""""""""""""""""""""""""""
" => easymotion
""""""""""""""""""""""""""""""
nmap <leader>/ <Plug>(easymotion-sn)
let g:EasyMotion_smartcase = 1


""""""""""""""""""""""""""""""
" => UltiSnips
""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsListSnippets = "<F1>"
let g:UltiSnipsEditSplit = "vertical"


""""""""""""""""""""""""""""""
" => Dispatch
""""""""""""""""""""""""""""""
nmap <leader>dm :Make<cr>
nmap <leader>dd :Dispatch<cr>
nmap <leader>d  :Dispatch
nmap <leader>ds :Start
nmap <leader>df :Focus


""""""""""""""""""""""""""""""
" => Hardmode
""""""""""""""""""""""""""""""
let g:hardtime_default_on = 1
let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:hardtime_ignore_buffer_patterns = ["NERD.*"]
let g:hardtime_ignore_quickfix = 1


""""""""""""""""""""""""""""""
" => Airline
""""""""""""""""""""""""""""""
" disable distractive symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''

" simpler line/column numbering
let g:airline_section_z = airline#section#create_right(['%l/%L:%v'])
" disable unnecessary stuff
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tagbar#enabled = 0

" disable for tpm
" to generate tmuxline.conf run
"   `vim +'Tmuxline airline' +'TmuxlineSnapshot! ~/.tmux/tmuxline.conf' +qall`
let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I#F│#W',
      \'cwin' : '#I#F│#W',
      \'x'    : ' #{maildir_counter_1}/#{maildir_counter_2}/#{maildir_counter_3}',
      \'y'    : '%Y-%m-%d %H:%M',
      \'z'    : '#h',
      \'options': {
      \  'status-justify': 'left'}
      \}
