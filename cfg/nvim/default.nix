{ pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ../../nixpkgs { };
  plugins = pkgs.callPackage ./plugins.nix {
    buildVimPluginFrom2Nix = (master.vimUtils.override {
      inherit (master.neovim)
        ;
    }).buildVimPluginFrom2Nix;
  };
  runtime = pkgs.buildEnv {
    name = "neovim-env";
    paths = with unstable; [
      rustfmt
      rls
      nixpkgs-fmt
      # rnix-lsp
      python37Packages.black
      python37Packages.python-language-server
      nodePackages.javascript-typescript-langserver
      nodePackages.prettier
      nodePackages.bash-language-server
      shfmt
      # Preview for nvim telescope
      bat
    ];
  };
  neovim = (master.neovim.override {
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
          ### Currently not in repo:
          # vim-jsx-typescript
          vim-tsx
          typescript-vim
          # Buffer formatting.
          neoformat
          NeoSolarized
          # Themes.
          awesome-vim-colorschemes
          plugins.vim-monochrome
          # Popup finder.
          plugins.popup
          plugins.plenary
          plugins.telescope
        ];
        opt = [
          # LSP.
          nvim-lspconfig
          # Aid completion
          plugins.completion-nvim
          # Treesitter.
          plugins.nvim-treesitter
          plugins.nvim-treesitter-textobjects
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
            " colorscheme sierra
            colorscheme anderson
            "" Monochrome:
            " let g:monochrome_italic_comments = 1
            " colorscheme monochrome
            " hi Normal guibg=#141414
            hi Type gui=bold
            hi Statement gui=bold
          endif
        endif

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
          ensure_installed = { "python", "rust" },
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
      '';
    };
  });
  wrappedNeovim = pkgs.symlinkJoin {
    name = "neovim";
    paths = [ neovim ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --prefix PATH : "${runtime}/bin"
    '';
  };
in
{
  home.packages = [ wrappedNeovim ];

  home.file =
    let
      jsCommon = ''
        nmap <buffer><leader>mf :Neoformat<cr>
        set shiftwidth=2
      '';
    in
    {
      ".config/nvim/ftplugin/nix.vim".text = ''
        nmap <buffer><leader>mf :Neoformat nixpkgs-fmt<cr>
      '';
      ".config/nvim/ftplugin/rust.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/sh.vim".text = ''
        let g:shfmt_opt="-ci"
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/python.vim".text = ''
        nmap <buffer><leader>mf :Neoformat black<cr>
      '';
      ".config/nvim/ftplugin/javascript.vim".text = ''
        ${jsCommon}
      '';
      ".config/nvim/ftplugin/typescript.vim".text = ''
        ${jsCommon}
      '';
      ".config/nvim/ftplugin/css.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/html.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/htmldjango.vim".text = ''
        let g:neoformat_htmldjango_htmlbeautify = {
          \ 'exe': 'html-beautify',
          \ 'args': ['--indent-size ' .shiftwidth()],
          \ 'stdin': 1,
          \ }
        let g:neoformat_enabled_htmldjango = ['htmlbeautify']
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      # This currently does not work due to ABI incompatibilities:
      # ".config/nvim/parser/rust.so".source = "${master.tree-sitter.builtGrammars.rust}/parser";
      # ".config/nvim/parser/python.so".source = "${master.tree-sitter.builtGrammars.python}/parser";
    };

}
