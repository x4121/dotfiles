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
" Elixir
Plug 'elixir-lang/vim-elixir'
" Web-Stuff
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-jdaddy' " json
Plug 'tpope/vim-ragtag' " html/erb
Plug 'tpope/vim-markdown'
Plug 'masukomi/vim-markdown-folding'
" Puppet
Plug 'rodjek/vim-puppet'
" Rust
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
" C#
Plug 'Omnisharp/omnisharp-vim'
" Hashicorp
Plug 'HashiVim/vim-terraform'
Plug 'udalov/kotlin-vim'
" async language server protocol
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'dense-analysis/ale'
" etc
Plug 'Chiel92/vim-autoformat', { 'on': ['Autoformat'] }
Plug 'majutsushi/tagbar' " show tags like nerdtree
" Plug 'scrooloose/syntastic'
Plug 'vim-scripts/matchit.zip' " extended matching for '%'
Plug 'tpope/vim-endwise' " auto close block-statements
Plug 'Raimondi/delimitMate' " auto close quotes/parens/..
Plug 'tpope/vim-commentary' " add/remove comments
Plug 'tpope/vim-dadbod'

"" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'francoiscabrol/ranger.vim'
Plug 'svermeulen/vim-NotableFt'

"" Completion
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'

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
Plug 'vim-scripts/YankRing.vim'
Plug 'tmux-plugins/vim-tmux-focus-events' " enable 'FocusGained' in tmux

"" load last in this order!
Plug 'ryanoasis/vim-devicons'

filetype plugin indent on
call plug#end()
