set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let vundle manage itself
Plugin 'VundleVim/Vundle.vim'

" plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'dag/vim-fish'
Plugin 'blindFS/vim-taskwarrior'
Plugin 'derekwyatt/vim-sbt'
Plugin 'derekwyatt/vim-scala'
Plugin 'ensime/ensime-sbt'
Plugin 'ensime/ensime-server'
Plugin 'ensime/ensime-vim'
Plugin 'ervandew/supertab'
Plugin 'fatih/vim-go'
Plugin 'jceb/vim-orgmode'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'junegunn/goyo.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'severin-lemaignan/vim-minimap'
"Plugin 'Shougo/neocomplete.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'yegappan/mru'
Plugin 'Yggdroot/indentLine'
Plugin 'Xuyuanp/nerdtree-git-plugin'
" non github
Plugin 'taglist.vim'
Plugin 'listmaps.vim'

Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

" load devicons last
Plugin 'ryanoasis/vim-devicons'

call vundle#end()
filetype plugin indent on
