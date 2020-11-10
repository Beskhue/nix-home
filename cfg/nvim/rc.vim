filetype plugin on
set mouse=a
syntax on
set number
set signcolumn=yes
set cmdheight=2
highlight LineNr ctermfg=white
set hidden
set statusline=%f%=%r%m%y\ %P\ %l,%c

function! s:ui_enter()
  set guicursor=n-v-c:block-Cursor
  set guicursor+=i:ver25-Cursor
  set guicursor+=r-cr-o:hor20-Cursor
  if get(v:event, "chan") == 0
      set termguicolors
  else
      set guifont=iosevka:h10.5
  endif
  " let g:neosolarized_vertSplitBgTrans = 1
  " set background=light
  " colorscheme sierra
  colorscheme anderson
  "" Monochrome:
  " let g:monochrome_italic_comments = 1
  " colorscheme monochrome
  " hi Normal guibg=#141414
  hi Type gui=bold
  hi Statement gui=bold
endfunction

au UIEnter * call s:ui_enter()

" Input tab as space
set shiftwidth=4
set expandtab smarttab

let mapleader="\<Space>"

" File and buffer opening
nmap <leader>b :Buffers<cr>
nmap <leader>fo :Files<cr>
nmap <leader>fd :Explore<cr>
nmap <leader>fg <cmd>lua require('telescope.builtin').git_files()<cr>
nmap <leader>fr <cmd>lua require('telescope.builtin').live_grep()<cr>

set wildignore+=*/tmp/*,*/target/*,*.obj,*.class,*.o,*.so

" Moving lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
map  <leader>d <Plug>(easymotion-bd-f)
nmap <leader>d <Plug>(easymotion-overwin-f)
map  <leader>w <Plug>(easymotion-bd-w)
nmap <leader>w <Plug>(easymotion-overwin-w)
map  <leader>j <Plug>(easymotion-j)
map  <leader>k <Plug>(easymotion-k)

" Completion
packadd completion-nvim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" LSP
" Setting `root_dir` required until
" https://github.com/neovim/nvim-lsp/commit/1e20c0b29e67e6cd87252cf8fd697906622bfdd3#diff-1cc82f5816863b83f053f5daf2341daf
" is in nixpkgs repo.
packadd nvim-lspconfig
lua << EOF
require'nvim_lsp'.pyls.setup{
  root_dir = function(fname)
    return vim.fn.getcwd()
  end;
  on_attach=require'completion'.on_attach
}
require'nvim_lsp'.rls.setup{
  on_attach=require'completion'.on_attach
}
require'nvim_lsp'.tsserver.setup{
  on_attach=require'completion'.on_attach
}
require'nvim_lsp'.bashls.setup{
  on_attach=require'completion'.on_attach
}
EOF
" require'nvim_lsp'.rnix.setup{}

nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <silent> gs    <cmd>lua require'telescope.builtin'.treesitter{}<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
inoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

"" Some LSP servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Treesitter
packadd nvim-treesitter
packadd nvim-treesitter-textobjects
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "nix", "rust", "python", "bash", "toml", "lua", "julia", "typescript", "javascript", "php" },
  highlight = {
    enable = true,
    disable = { },
  },
  textobjects = {
    enable = true,
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF
