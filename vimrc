
set nocompatible              " required (設定vim運行在增強模式下，不與VI相容)
filetype off                  " required 


" ------------------------------------------------------------------------ "
" Vim plugin
" ------------------------------------------------------------------------ "


" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Valloric/YouCompleteMe'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-airline/vim-airline'			
Plug 'vim-airline/vim-airline-themes'
Plug 'jnurmine/Zenburn'
call plug#end()

filetype plugin indent on    			" required (使用檔案類型與插件)
syntax enable					" 依程式語法對程式碼進行彩色標示，語法高量
let mapleader = ","				" 自訂一複合鍵

" ------------------------------------------------------------------------- "
" VIEW
" ------------------------------------------------------------------------- "
set background=dark				" 背景設定為黑色
set t_Co=256				 	" 設定顏色範圍set t_Co=256 " 設定顏色範圍
"colorscheme zenburn

set so=7					" 光標上下限離邊界還有7行
set wildmenu					" 使用TAB自動補全的時候，將補全的內容使用橫向選單方式顯示
set ruler					" 總是顯示現在游標的位置
set cmdheight=2					" 命令列的高度
set hid						" 當被捨棄時將緩衝區隱藏
set foldcolumn=1				" 左邊添加一些而外的空間
set showcmd					" 在右下角顯示指令 EX:gg,3yy
set cursorline
" set number					" 顯示行號
" set relativenumber				" 顯示相對行號

" -------------------------  Status line  --------------------------------- "
" 注意 如果設置本選項 (並且 'laststatus' 爲 2 的話)，'ruler' 的唯一效果是控制 |CTRL-G| 的輸出。
set laststatus=2

" 設定狀態列的格式
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l/%L:%c

" PASTE MODE 顯示
function! HasPaste()
    if &paste
       return 'PASTE MODE  '
    endif
    return ''
endfunction
" -------------------------  Status line  --------------------------------- "


set tw=79					" 設置光標超過79列的時候折行
set linebreak					" 如果一行文字非常長，無法在一行內顯示完的話，它會在單詞與單詞間的空白處斷開，盡量不會把一個單詞分成兩截放在兩個不同的行里。
set showmatch					" 對成對括號高亮度顯示



" ------------------------------------------------------------------------- "
" General SET 
" ------------------------------------------------------------------------- "
set history=700 				" 要記錄幾行歷史資料
set autoread 					" 當檔案因外部改變時自動讀檔

set nobackup					" 關閉備份	
set nowb					" 檔案交換
set noswapfile					" 暫存檔

set lazyredraw 					" 在執行巨集的時候不進行顯示重新繪，待巨集執行完畢後再重新繪製


" 開啟檔案時回到最後的編輯位置

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

set viminfo^=%					" 緩衝區關閉時將訊息記錄下來

" 錯誤時不發聲
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" 當偵測到buffer時不關閉視窗
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

map <leader>bd :Bclose<cr>			" Close the current buffer
map <leader>ba :1,1000 bd!<cr>			" Close all the buffers

map <leader>pp :setlocal paste!<cr>		" 快速切換 Paste 模式

" 去除在windows編輯檔案產生的^M
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>


" ------------------------------------------------------------------------ "
" Fonts & Encoding & 檔案形式
" ------------------------------------------------------------------------ "

set encoding=utf-8				" UTF-8 Support 支援UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 "設置支援多語系，解決亂碼問題
language messages zh_TW.utf-8			" 解決consle輸出亂碼^
set ffs=unix,dos,mac				" 指定多個作業模式，會依載入的檔案形式來調整 ff
" set ambiwidth=double

" ------------------------------------------------------------------------- "
" SEARCH
" ------------------------------------------------------------------------- "
set ignorecase					" 在搜尋時忽視大小寫(可能對中文有影響)
set smartcase					" 聰明大小寫匹配
set hlsearch					" 高亮度標記搜尋結果
set incsearch					" 加強式尋找功能，在鍵入 patern 時會立即反應移動至目前鍵入之patern上
set magic					" 啟動正則表達示



"ACK 功能 [gv] [<leader>r]使用的 Function
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"vnoremap <silent> * :call VisualSelection('f', '')<CR>		" 將在游標位置的單詞選取出來做搜尋
"vnoremap <silent> # :call VisualSelection('b', '')<CR>		" 將在游標位置的單詞選取出來做搜尋


" ------------------------------------------------------------------------- "
" 操作
" ------------------------------------------------------------------------- "
set backspace=eol,start,indent		
" eol:可刪除前一行的行末的ENTER記號使兩條合併，預設不可換行
" start:可以繼續刪除既有字元，預設只能刪除本次造成的字元
" indent:可以直接刪除自動縮排造成的空格

set whichwrap+=<,>,h,l,[,]
"讓左移右移鍵可以跨行，預設為不可跨行
"b:在 Normal 或 Visual 模式下按删除(Backspace)键。
"s:在 Normal 或 Visual 模式下按空格键。
"h:在 Normal 或 Visual 模式下按 h 键。
"l:在 Normal 或 Visual 模式下按 l 键。
"<:在 Normal 或 Visual 模式下按左方向键。
">:在 Normal 或 Visual 模式下按右方向键。
"~:在 Normal 模式下按 ~ 键(翻转当前字母大小写)。
"[:在 Insert 或 Replace 模式下按左方向键。
"]:在 Insert 或 Replace 模式下按右方向键。


" Treat long lines as break lines (useful when moving around in them)
" 可以在同一句中上下移动(於長句換行中狀態下)
nnoremap j gj
nnoremap k gk

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac""
" 移動光標所在行的位置
nmap <leader><c-j> mz:m+<cr>`z
nmap <leader><c-k> mz:m-2<cr>`z
vmap <leader><c-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader><c-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
" 在存檔時刪除尾隨的空白，對Python 與 CoffeeScript 好用
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
" 將正向搜尋(/)改為空白鍵，反向搜尋改為 ctrl-space
" nnoremap <space> /
" nnoremap <c-space> ?


nnoremap <silent> <leader><cr> :nohl<cr>	" 取消高亮度表示


nmap <leader>w : w!<cr>				" 快速強制儲存
command W w !sudo tee % > /dev/null		" 最高權限存檔


" ------------------------------------------------------------------------- "
" split area (分割視窗)
" ------------------------------------------------------------------------- "

set splitbelow		     			" 分割視窗位於下方
set splitright					" 分割視窗位於右方

nnoremap <C-J> <C-W><C-J>			" 切到下方視窗
nnoremap <C-K> <C-W><C-K>			" 切到上方視窗
nnoremap <C-L> <C-W><C-L>			" 切到左方視窗
nnoremap <C-H> <C-W><C-H>			" 切到右方視窗


" ------------------------------------------------------------------------- "
" 分頁相關
" ------------------------------------------------------------------------- "

map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr> 
map <leader>t<leader> :tabnext<cr> 

let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>	" 上一分頁與當前分頁做快速切換
au TabLeave * let g:lasttab = tabpagenr()

" 帶出目前檔案的目錄位置來做檔案選擇，用以開啟新的分頁
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" 切換目錄到當前緩衝區檔案的目錄
map <leader>cd :cd %:p:h<cr>:pwd<cr>


" stal 永遠顯示帶有標簽頁標簽的行(有上角 1: )
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry



" ------------------------------------------------------------------------- "
" 文本，標籤與縮排相關
" ------------------------------------------------------------------------- "

" Enable Code folding
set foldmethod=indent
set foldlevel=99

nnoremap <Leader><space> za			" Enable folding with the spacebar

" SimpylFold (Plugin 'tmhedberg/SimpylFold')
let g:SimpylFold_docstring_preview=1



" ------------------------------------------------------------------------- "
" Python 代碼縮排
" ------------------------------------------------------------------------- "

" PEP8
au BufNewFile,BufRead *.py
    \ set tabstop=4	|
    \ set softtabstop=4	|
    \ set shiftwidth=4	|
    \ set textwidth=79	|
    \ set expandtab	|
    \ set autoindent	|
    \ set wrap		|
    \ set fileformat=unix	


"  \ set smartindent   |

" js html css
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2	|
    \ set softtabstop=2	|
    \ set shiftwidth=2




" ------------------------------------------------------------------------- "
" Plug 設定
" ------------------------------------------------------------------------- "

" ----------------  The_NERD_Tree config 樹狀檔案瀏覽器  ------------------ "
map <LEADER>nn :NERDTreeToggle<CR>
map <LEADER>nb :NERDTreeFromBookmark 
map <LEADER>nf :NERDTreeFind<cr>     
let g:NERDTreeWinPos = "left"
let g:NERDTreeWinSize = 35

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif


" -------------------  vim-airline config 狀態欄增強  --------------------- "

let g:airline_theme = "luna"				" 設定主題樣式
let g:airline_powerline_fonts = 1 			" 修改字形(1為啟用)
"let g:airline#extensions#syntastic#enabled = 1
"let g:airline#extensions#branch#enabled = 1
let g:airline_extensions = ['branch','tabline']
let g:airline#extensions#tabline#buffer_nr_show = 1 	" 開啟buffer(分頁顯示)

" let g:airline#extensions#tabline#enabled = 1 		" 開啟tabline(瀏覽視窗功能)
let g:airline#extensions#tabline#left_sep = ' '		" set left separator
let g:airline#extensions#tabline#left_alt_sep = '|'	" set left separator which are not editting
let g:airline#extensions#tagbar#enabled = 1
"let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'


if has("gui_running")
    if has("win32")
      set guifont=Anonymous\ Pro\ for\ Powerline
    else
      set guifont=Anonymous\ Pro\ for\ Powerline
    endif
endif

if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif

 let g:airline_left_sep = '▶'
 let g:airline_left_alt_sep = '❯'
 let g:airline_right_sep = '◀'
 let g:airline_right_alt_sep = '❮'
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
 let g:airline_symbols.crypt = '🔒'
" let g:airline_symbols.linenr = '␊'
 let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
 let g:airline_symbols.maxlinenr = '☰'
" let g:airline_symbols.maxlinenr = ''
 let g:airline_symbols.branch = '⎇'
 let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
 let g:airline_symbols.spell = 'Ꞩ'
 let g:airline_symbols.notexists = '∄'
 let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''



" mkdir .font/
" cd .font/
" git clone https://github.com/Lokaltog/powerline-fonts.git 
" cd powerline-fonts/
" ./install.sh



let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>




"Auto-Indentation 自動縮排 (Plugin 'vim-scripts/indentpython.vim')

"Flagging Unnecessary Whitespace 標示多餘的空白字符
hi BadWhitespace guifg=gray guibg=red ctermfg=gray ctermbg=red 	"設定高量群組
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


"Auto-Complete 安裝 YouCompleteMe (Bundle 'Valloric/YouCompleteMe')
"sudo yum install cmake gcc-c++ make python3-devel
