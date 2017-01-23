call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'dag/vim-fish'
Plug 'blindFS/vim-taskwarrior'
Plug 'derekwyatt/vim-sbt'
Plug 'derekwyatt/vim-scala'
Plug 'ensime/ensime-sbt', { 'for': 'scala' }
Plug 'ensime/ensime-server', { 'for': 'scala' }
Plug 'ensime/ensime-vim', { 'for': 'scala' }
Plug 'ervandew/supertab'
Plug 'fatih/vim-go'
Plug 'jceb/vim-orgmode'
Plug 'jlanzarotta/bufexplorer'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install -all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
" Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'Raimondi/delimitMate'
Plug 'rodjek/vim-puppet'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }
"Plug 'Shougo/neocomplete.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'yegappan/mru'
Plug 'Yggdroot/indentLine'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
" non github
Plug 'taglist.vim'
Plug 'listmaps.vim'

Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

" load devicons last
Plug 'ryanoasis/vim-devicons'

filetype plugin indent on
call plug#end()
