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
Plug 'ensime/ensime-sbt', { 'branch': '2.0', 'for': 'scala' }
Plug 'ensime/ensime-server', { 'branch': '2.0', 'for': 'scala' }
Plug 'ensime/ensime-vim', { 'for': 'scala' }
" Elixir
Plug 'elixir-lang/vim-elixir'
" Orgmode
Plug 'jceb/vim-orgmode'
" Ruby/Rails/Jekyll/Web-Stuff
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-jdaddy' " json
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-liquid' " liquid/jekyll
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-ragtag' " html/erb
Plug 'tpope/vim-markdown'
" Puppet
Plug 'rodjek/vim-puppet'
" etc
Plug 'majutsushi/tagbar' " show tags like nerdtree
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }
Plug 'matchit.zip' " extended matching for '%'
Plug 'tpope/vim-endwise' " auto close block-statements
Plug 'Raimondi/delimitMate' " auto close quotes/parens/..
Plug 'tpope/vim-commentary' " add/remove comments
Plug 'tpope/vim-dispatch' " asynchronous test/build

"" Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'

"" Completion
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"" UI
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/goyo.vim' " distraction free typing
Plug 'Yggdroot/indentLine'

"" Misc
Plug 'taglist.vim'
Plug 'listmaps.vim' " :Listmaps
Plug 'tpope/vim-speeddating' " increment/decrement on dates
Plug 'tpope/vim-capslock' " software capslock
Plug 'tpope/vim-sleuth' " auto adjust indentation
Plug 'tpope/vim-repeat' " extend repeat command
Plug 'tpope/vim-surround' " add/change/delete quotes/parens/..

"" Testing

"" load last in this order!
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'ryanoasis/vim-devicons'

filetype plugin indent on
call plug#end()
