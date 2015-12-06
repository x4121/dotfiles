set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle/
call vundle#begin()

" let vundle manage itself
Plugin 'VundleVim/Vundle.vim'

" plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'dag/vim-fish'
Plugin 'blindFS/vim-taskwarrior'
Plugin 'bling/vim-airline'
Plugin 'ervandew/supertab'
Plugin 'x4121/vim-orgmode'
" Plugin 'jceb/vim-orgmode'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'junegunn/goyo.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
" Plugin 'Shougo/neocomplcache.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'yegappan/mru'
Plugin 'Yggdroot/indentLine'
Plugin 'Xuyuanp/nerdtree-git-plugin'
" non github
Plugin 'taglist.vim'

" languages
Plugin 'derekwyatt/vim-sbt'
Plugin 'derekwyatt/vim-scala'
Plugin 'fatih/vim-go'
Plugin 'tpope/vim-markdown'

call vundle#end()
filetype plugin indent on
