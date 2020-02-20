{ ... }:
let unstable = import <unstable> { };
in {
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    plugins = with unstable.pkgs.vimPlugins; [
      # Fuzzy finding.
      fzf-vim
      # Movement.
      vim-easymotion
      # LSP.
      coc-nvim
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
    ];
    extraConfig = ''
      set mouse=a
      syntax on
      set number
      highlight LineNr ctermfg=white
      set statusline=%f%=%l,%c

      if !has('gui_running')
        if $TERM == 'alacritty'
          set guicursor=n-v-c:block-Cursor
          set guicursor+=i:ver25-Cursor
          set guicursor+=r-cr-o:hor20-Cursor
          let g:neosolarized_vertSplitBgTrans = 1
          set termguicolors
          set background=light
          colorscheme NeoSolarized
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

      " Coc:
      " if hidden is not set, TextEdit might fail.
      set hidden

      " Some servers have issues with backup files, see #649
      set nobackup
      set nowritebackup

      " Better display for messages
      set cmdheight=2

      " You will have bad experience for diagnostic messages when it's default 4000.
      set updatetime=300

      " don't give |ins-completion-menu| messages.
      set shortmess+=c

      " always show signcolumns
      set signcolumn=yes

      " Use tab for trigger completion with characters ahead and navigate.
      " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
      inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion.
      inoremap <silent><expr> <c-space> coc#refresh()

      " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
      " Coc only does snippet and additional edit on confirm.
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
      " Or use `complete_info` if your vim support it, like:
      " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

      " Use `[g` and `]g` to navigate diagnostics
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " Remap keys for gotos
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window
      nnoremap <silent> K :call <SID>show_documentation()<CR>

      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction

      " Highlight symbol under cursor on CursorHold
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Remap for rename current word
      nmap <leader>mr <Plug>(coc-rename)

      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Remap for do codeAction of current line
      nmap <leader>ma  <Plug>(coc-codeaction)
      " Fix autofix problem of current line
      nmap <leader>mqf  <Plug>(coc-fix-current)

      " Create mappings for function text object, requires document symbols feature of languageserver.
      xmap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap if <Plug>(coc-funcobj-i)
      omap af <Plug>(coc-funcobj-a)

      " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
      nmap <silent> <C-d> <Plug>(coc-range-select)
      xmap <silent> <C-d> <Plug>(coc-range-select)

      " Add status line support, for integration with other plugin, checkout `:h coc-status`
      set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''')}\ 

      " Using CocList
      " Show all diagnostics
      nmap <leader>me :<C-u>CocList diagnostics<cr>
      " Find symbol of current document
      nmap <leader>ms :<C-u>CocList outline<cr>
      " Resume latest coc list
      nmap <leader>mp  :<C-u>CocListResume<CR>
    '';
  };

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
    '';
    ".config/nvim/ftplugin/python.vim".text = ''
      nmap <leader>mf :Neoformat<cr>
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
