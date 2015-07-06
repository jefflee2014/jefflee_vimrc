
"## MINIMAL setup (3 lines)

"```vim
"set nocompatible | filetype indent plugin on | syn on
"set runtimepath+=/path/to/vam
"call vam#ActivateAddons([PLUGIN_NAME])
"```

"## Recommended setup
"This setup will checkout VAM and all plugins on its own unless they exist:

"```vim
" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'

  " Force your ~/.vim/after directory to be last in &rtp always:
  " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif

  " This provides the VAMActivate command, you could be passing plugin names, too
  call vam#ActivateAddons([], {})
endfun
call SetupVAM()

" ACTIVATING PLUGINS

" OPTION 1, use VAMActivate
"VAMActivate PLUGIN_NAME PLUGIN_NAME ..

" OPTION 2: use call vam#ActivateAddons
call vam#ActivateAddons(['The_NERD_tree','taglist','snipmate','AutoComplPop','L9','ctrlp','EasyMotion','surround','cscope','snippets'],{'auto_install' : 1})
" use <c-x><c-p> to complete plugin names

" OPTION 3: Create a file ~/.vim-srcipts putting a PLUGIN_NAME into each line
" See lazy loading plugins section in README.md for details
"call vam#Scripts('~/.vim-scripts', {'tag_regex': '.*'})

"```

" NERDTree config
map <F4> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif

"EasyMotion config
let g:EasyMotion_leader_key='<Space>'

"taglist config
map <f9> :Tlist<CR>
let Tlist_Use_Right_Window = 1

"AutoComplPop config
"let g:acp_behaviorSnipmateLength=1
