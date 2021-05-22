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
" => indent highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '┆'
let g:indentLine_faster = 1


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


""""""""""""""""""""""""""""""
" => Rust
""""""""""""""""""""""""""""""
let g:rustfmt_autosave = 1

""""""""""""""""""""""""""""""
" => Markdown
""""""""""""""""""""""""""""""
" Interpret yaml front matter as comment
autocmd BufNewFile,BufRead *.md syntax match Comment /\%^---\_.\{-}---$/

" Open document 'unfolded'
autocmd BufWinEnter *.md normal zR

""""""""""""""""""""""""""""""
" => JSON
""""""""""""""""""""""""""""""
autocmd FileType json syntax match Comment +\/\/.\+$+

""""""""""""""""""""""""""""""
" => Ale (LSP)
""""""""""""""""""""""""""""""
let g:airline#extensions#ale#enabled = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'rust': ['rustfmt'],
\}
let g:ale_linters = {
\   'rust': ['analyzer']
\}
let g:ale_fix_on_save = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

 nmap <silent> <C-k> <Plug>(ale_previous_wrap)
 nmap <silent> <C-j> <Plug>(ale_next_wrap)

function! s:on_lsp_buffer_enabled() abort
    " setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>a <plug>(lsp-code-action)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    command! -nargs=0 Format <plug>(lsp-document-format)
    command! -nargs=? Fold <plug>(lsp-document-format)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    autocmd! BufWritePre *.scala call execute('LspDocumentFormatSync')

    if executable('rust-analyzer')
      au User lsp_setup call lsp#register_server({
          \   'name': 'Rust Language Server',
          \   'cmd': {server_info->['rust-analyzer']},
          \   'whitelist': ['rust'],
          \ })
    endif

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
