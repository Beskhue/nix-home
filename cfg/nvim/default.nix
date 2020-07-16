{ ... }:
let
  unstable = import <unstable> { };
  master = import ../../nixpkgs { };
in {
  home.packages =
    # Default language servers and formatters
    with unstable;
    [
      rustfmt
      rls
      nixfmt
      rnix-lsp
      python37Packages.black
      python37Packages.python-language-server
      nodePackages.javascript-typescript-langserver
      nodePackages.prettier
    ] ++ [
      (master.neovim.override {
        configure = {
          packages.myPackages = with master.pkgs.vimPlugins; {
            start = [
              # Impure manager.
              # vim-plug
              # Fuzzy finding.
              fzf-vim
              # Movement.
              vim-easymotion
              # Languages.
              vim-nix
              vim-javascript
              # Aid completion
              supertab
              # LSP.
              nvim-lsp
              ### Currently not in repo:
              # vim-jsx-typescript
              vim-tsx
              typescript-vim
              # Buffer formatting.
              neoformat
              NeoSolarized
              awesome-vim-colorschemes
            ];

          };
          customRC = ''
            filetype plugin on
            set mouse=a
            syntax on
            set number
            set signcolumn=yes
            set cmdheight=2
            highlight LineNr ctermfg=white
            set hidden
            set statusline=%f%=%r%m%y\ %P\ %l,%c

            if !has('gui_running')
              if $TERM == 'alacritty' || $TERM == 'tmux-256color'
                set guicursor=n-v-c:block-Cursor
                set guicursor+=i:ver25-Cursor
                set guicursor+=r-cr-o:hor20-Cursor
                " let g:neosolarized_vertSplitBgTrans = 1
                set termguicolors
                " set background=light
                colorscheme sierra
                hi Type gui=bold
                hi Statement gui=bold
              endif
            endif

            " Input tab as space
            set shiftwidth=4
            set expandtab smarttab

            let mapleader="\<Space>"

            nmap <leader>b :Buffers<cr>
            nmap <leader>fo :Files<cr>
            nmap <leader>fd :Explore<cr>

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

            " Supertab
            let g:SuperTabDefaultCompletionType = "context"

            " Close omnifunc buffers on complete
            set omnifunc=syntaxcomplete#Complete
            autocmd CompleteDone * pclose

            " LSP
            " Setting `root_dir` required until
            " https://github.com/neovim/nvim-lsp/commit/1e20c0b29e67e6cd87252cf8fd697906622bfdd3#diff-1cc82f5816863b83f053f5daf2341daf
            " is in nixpkgs repo.
            lua << EOF
            vim.cmd('packadd nvim-lsp')
            require'nvim_lsp'.pyls.setup{
              root_dir = function(fname)
                return vim.fn.getcwd()
              end;
            }
            require'nvim_lsp'.rls.setup{}
            require'nvim_lsp'.rnix.setup{}
            require'nvim_lsp'.tsserver.setup{}
            EOF

            nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
            nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
            nnoremap <silent> gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
            nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

            "" Some LSP servers have issues with backup files, see #649
            set nobackup
            set nowritebackup
          '';
        };
      })
    ];

  home.file = let
    jsCommon = ''
      nmap <leader>mf :Neoformat<cr>
      set shiftwidth=2
    '';
  in {
    ".config/nvim/ftplugin/nix.vim".text = ''
      nmap <leader>mf :Neoformat<cr>
    '';
    ".config/nvim/ftplugin/rust.vim".text = ''
      nmap <leader>mf :Neoformat<cr>
      setlocal omnifunc=v:lua.vim.lsp.omnifunc
    '';
    ".config/nvim/ftplugin/python.vim".text = ''
      nmap <leader>mf :Neoformat! python black<cr>
      setlocal omnifunc=v:lua.vim.lsp.omnifunc
    '';
    ".config/nvim/ftplugin/javascript.vim".text = ''
      ${jsCommon}
    '';
    ".config/nvim/ftplugin/typescript.vim".text = ''
      ${jsCommon}
      setlocal omnifunc=v:lua.vim.lsp.omnifunc
    '';
    ".config/nvim/ftplugin/css.vim".text = ''
      nmap <leader>mf :Neoformat<cr>
    '';
    ".config/nvim/ftplugin/html.vim".text = ''
      nmap <leader>mf :Neoformat<cr>
    '';
    ".config/nvim/ftplugin/htmldjango.vim".text = ''
      let g:neoformat_htmldjango_htmlbeautify = {
        \ 'exe': 'html-beautify',
        \ 'args': ['--indent-size ' .shiftwidth()],
        \ 'stdin': 1,
        \ }
      let g:neoformat_enabled_htmldjango = ['htmlbeautify']
      nmap <leader>mf :Neoformat<cr>
    '';
  };

}
