{ ... }:
let
  unstable = import <unstable> { };
  master = import ../../nixpkgs { };
in {
  home.packages = [
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
          set mouse=a
          syntax on
          set number
          set signcolumn=yes
          set cmdheight=2
          highlight LineNr ctermfg=white
          set statusline=%f%=%l,%c

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

          filetype plugin on

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

          " Default omnifunc
          set omnifunc=syntaxcomplete#Complete
          autocmd CompleteDone * pclose

          " LSP
          nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
          nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
          nnoremap <silent> gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
          nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

          "" Some LSP servers have issues with backup files, see #649
          set nobackup
          set nowritebackup

          " Faster update for diagnostic messages
          set updatetime=300

          " Use `[g` and `]g` to navigate diagnostics
          " nmap <silent> [g <Plug>(coc-diagnostic-prev)
          " nmap <silent> ]g <Plug>(coc-diagnostic-next)

          " Remap keys for gotos
          " nmap <silent> gd <Plug>(coc-definition)
          " nmap <silent> gy <Plug>(coc-type-definition)
          " nmap <silent> gi <Plug>(coc-implementation)
          " nmap <silent> gr <Plug>(coc-references)
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

      lua << EOF
      vim.cmd('packadd nvim-lsp')
      require'nvim_lsp'.rls.setup{}
      EOF
      setlocal omnifunc=v:lua.vim.lsp.omnifunc
    '';
    ".config/nvim/ftplugin/python.vim".text = ''
      nmap <leader>mf :Neoformat! python black<cr>
    '';
    ".config/nvim/ftplugin/javascript.vim".text = ''
      ${jsCommon}
    '';
    ".config/nvim/ftplugin/typescript.vim".text = ''
      ${jsCommon}
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
