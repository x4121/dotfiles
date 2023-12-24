call plug#begin('~/.vim/plugged')

"" required
Plug 'dag/vim-fish'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }

"" Git stuff
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive' " git wrapper
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }

"" Languages
" Scala
Plug 'derekwyatt/vim-sbt'
Plug 'derekwyatt/vim-scala'
" Protobuf
Plug 'uarun/vim-protobuf'
" Elixir
Plug 'elixir-lang/vim-elixir'
" Web-Stuff
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-jdaddy' " json
Plug 'tpope/vim-ragtag' " html/erb
" Markdown
Plug 'tpope/vim-markdown'
Plug 'masukomi/vim-markdown-folding'
" Puppet
Plug 'rodjek/vim-puppet'
" Rust
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml', { 'branch': 'main' }
" C#
Plug 'Omnisharp/omnisharp-vim'
" Hashicorp
Plug 'HashiVim/vim-terraform'
" Kotlin
Plug 'udalov/kotlin-vim'
" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" linting
let g:ale_disable_lsp = 1
Plug 'dense-analysis/ale'
" etc
Plug 'majutsushi/tagbar' " show tags like nerdtree
Plug 'vim-scripts/matchit.zip' " extended matching for '%'
Plug 'Raimondi/delimitMate' " auto close quotes/parens/..
Plug 'tpope/vim-commentary' " add/remove comments
Plug 'tpope/vim-dadbod'

"" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'phaazon/hop.nvim'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim' " required for ranger
Plug 'svermeulen/vim-NotableFt'

"" Completion
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"" UI
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'
Plug 'edkolev/tmuxline.vim'

"" Misc
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/listmaps.vim' " :Listmaps
Plug 'tpope/vim-speeddating' " increment/decrement on dates
Plug 'tpope/vim-sleuth' " auto adjust indentation
Plug 'tpope/vim-repeat' " extend repeat command
Plug 'tpope/vim-surround' " add/change/delete quotes/parens/..
Plug 'tpope/vim-dispatch' " asynchronous test/build
Plug 'takac/vim-hardtime'
Plug 'tmux-plugins/vim-tmux-focus-events' " enable 'FocusGained' in tmux
Plug 'junegunn/vim-peekaboo'

"" load last in this order!
Plug 'ryanoasis/vim-devicons'

filetype plugin indent on
call plug#end()
