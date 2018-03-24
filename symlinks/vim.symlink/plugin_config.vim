"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => YankRing
""""""""""""""""""""""""""""""
if has("win16") || has("win32")
    " Don't do anything
else
    let g:yankring_history_dir = '~/.vim/temp'
endif
nnoremap <leader>y :YRShow<cr>


""""""""""""""""""""""""""""""
" => fugitive
""""""""""""""""""""""""""""""
set diffopt+=vertical


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<space>
map <leader>nf :NERDTreeFind<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
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

let g:limelight_conceal_ctermfg = 239
let g:limelight_conceal_guifg = '#504945'

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
let g:syntastic_ignore_files = ['\m\c\.h$', '\m\.sbt$']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_elixir_checkers = ['elixir']
let g:syntastic_rust_checkers = ['rustc']
let g:syntastic_scala_checkers = ['fsc']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => autoformat
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <F5> :Autoformat<CR>

function! StartNailgunScalaFmt()
  execute(':silent! !scalafmt_ng >/dev/null 2>/dev/null &')
  execute(':silent !ng-nailgun ng-alias scalafmt org.scalafmt.cli.Cli')
  execute(':redraw!')
endfunction

au FileType scala call StartNailgunScalaFmt()
" kill scalafmt_ng if no vim process is running
au VimLeave * :silent! !sh -c "sleep 2 && pidof vim || pidof vi || pkill -f 'scalafmt_ng'" >/dev/null &
let g:formatdef_scalafmt = "'ng-nailgun scalafmt --stdin'"
let g:formatters_scala = ['scalafmt']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-fish
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set up :make to use fish for syntax checking.
try
  compiler fish
catch
endtry

" Set this to have long lines wrap inside comments.
setlocal textwidth=79

" Enable folding of block structures in fish.
setlocal foldmethod=expr


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
let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:hardtime_ignore_buffer_patterns = ["NERD.*"]
let g:hardtime_ignore_quickfix = 1


""""""""""""""""""""""""""""""
" => Airline
""""""""""""""""""""""""""""""
let g:airline_theme='gruvbox'
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
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" simpler line/column numbering
try
    let g:airline_section_z = airline#section#create_right(['%l/%L:%v'])
catch
endtry
" disable unnecessary stuff
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tagbar#enabled = 0

" disable for tpm
" to generate tmuxline.conf run
"   `vim +'Tmuxline airline' +'TmuxlineSnapshot! ~/.tmux/tmuxline.conf' +qall`
let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
      \'a'    : '#S#{?client_prefix,^, }',
      \'win'  : '#I#F│#W',
      \'cwin' : '#I#F│#W',
      \'x'    : ' #{maildir_counter_1}/#{maildir_counter_2}/#{maildir_counter_3}',
      \'y'    : '%Y-%m-%d %H:%M',
      \'z'    : '#h',
      \'options': {
      \  'status-justify': 'left'}
      \}


""""""""""""""""""""""""""""""
" => Devicons
""""""""""""""""""""""""""""""
let g:webdevicons_conceal_nerdtree_brackets = 0
let g:WebDevIconsOS = 'Linux'
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
