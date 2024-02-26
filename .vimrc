set smartindent
set number
set relativenumber
set showcmd
set tabstop=4
set shiftwidth=4
set cursorline

set ignorecase
set smartcase


set t_Co=256

call plug#begin()
" vim-lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" auto complete for vim-lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'rust-lang/rust.vim'

" language syntax color
Plug 'NLKNguyen/papercolor-theme'

" neerd tree
Plug 'preservim/nerdtree'

" wilder -- a better vim command tab compliation plugin
if has('nvim')
	function! UpdateRemotePlugins(...)
		"Needed to refresh runtime files
		let &rtp=&rtp
		UpdateRemotePlugins
	endfunction
			  
	Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
	Plug 'gelguy/wilder.nvim'
	
	" To use Python remote plugin features in Vim, can be skipped
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()



" theme settings
set background=dark
colorscheme codedark


" overwrite theme
hi Pmenu        ctermfg=white ctermbg=black gui=NONE guifg=white guibg=black
hi PmenuSel     ctermfg=white ctermbg=blue gui=bold guifg=white guibg=purple


" map jl key to Esc 
inoremap jl <Esc>

" disable diagnostics support
let g:lsp_diagnostics_enabled = 0

" asyncomplete.vim tab key maps
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" map nerdtree to f5
nnoremap <F5> :exec 'NERDTreeToggle' <CR>

" origin vim command tab complete settings


" wilder plug settings
set wildmenu
set wildmode=longest:list,full

" python-language-server for asyncomplete
"if executable('pyls')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'pyls',
"        \ 'cmd': {server_info->['pyls']},
"        \ 'whitelist': ['python'],
"        \ })
"endif

if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

" rust-language-server for asyncomplete
if executable('rust-analyzer')
	    au User lsp_setup call lsp#register_server({
		        \ 'name': 'rust-analyzer',
		        \ 'cmd': {server_info->['rust-analyzer']},
		        \ 'whitelist': ['rust'],
				\ 'initialization_options': {
				\   'cargo': {
				\     'buildScripts': {
				\       'enable': v:true,
				\     },
				\   },
				\   'procMacro': {
				\     'enable': v:true,
				\   },
				\   'completion': {
				\     'autoimport': {
				\       'enable': v:false,
				\     },
				\   },
				\ },
				\ })
endif


" format code after save
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
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
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

