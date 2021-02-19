{ buildVimPluginFrom2Nix, fetchFromGitHub }:
let
  flake = (import (fetchTarball {
    url =
      "https://github.com/edolstra/flake-compat/archive/c75e76f80c57784a6734356315b306140646ee84.tar.gz";
    sha256 = "071aal00zp2m9knnhddgr2wqzlx6i6qa1263lv1y7bdn2w20h10h";
  }) { src = ../../.; }).defaultNix;
in {
  popup = buildVimPluginFrom2Nix rec {
    pname = "popup";
    version = flake.sources.nvimPopup.lastModifiedDate;
    src = flake.sources.nvimPopup;
    meta.homepage = "https://github.com/nvim-lua/popup.nvim";
  };
  plenary = buildVimPluginFrom2Nix rec {
    pname = "plenary";
    version = flake.sources.nvimPlenary.lastModifiedDate;
    src = flake.sources.nvimPlenary;
    meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
  };
  telescope = buildVimPluginFrom2Nix rec {
    pname = "telescope";
    version = flake.sources.nvimTelescope.lastModifiedDate;
    src = flake.sources.nvimTelescope;
    meta.homepage = "https://github.com/nvim-lua/telescope.nvim";
  };
  nvim-treesitter = buildVimPluginFrom2Nix rec {
    pname = "nvim-treesitter";
    version = flake.sources.nvimTreesitter.lastModifiedDate;
    src = flake.sources.nvimTreesitter;
    meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter/";
  };
  nvim-treesitter-textobjects = buildVimPluginFrom2Nix rec {
    pname = "nvim-treesitter-textobjects";
    version = flake.sources.nvimTreesitterTextobjects.lastModifiedDate;
    src = flake.sources.nvimTreesitterTextobjects;
    meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects/";
  };
  vim-monochrome = buildVimPluginFrom2Nix rec {
    pname = "vim-monochrome";
    version = flake.sources.nvimMonochrome.lastModifiedDate;
    src = flake.sources.nvimMonochrome;
    meta.homepage = "https://github.com/fxn/vim-monochrome";
  };
  vim-colors-pencil = buildVimPluginFrom2Nix rec {
    pname = "vim-colors-pencil";
    version = flake.sources.nvimVimColorsPencil.lastModifiedDate;
    src = flake.sources.nvimVimColorsPencil;
    meta.homepage = "https://github.com/reedes/vim-colors-pencil";
  };
  vim-photon = buildVimPluginFrom2Nix rec {
    pname = "photon.vim";
    version = flake.sources.nvimPhoton.lastModifiedDate;
    src = flake.sources.nvimPhoton;
    meta.homepage = "https://github.com/axvr/photon.vim";
  };
  completion-nvim = buildVimPluginFrom2Nix rec {
    pname = "completion-nvim";
    version = flake.sources.nvimCompletionNvim.lastModifiedDate;
    src = flake.sources.nvimCompletionNvim;
    meta.homepage = "https://github.com/nvim-lua/completion-nvim";
  };
  vim-loclist-follow = buildVimPluginFrom2Nix rec {
    pname = "vim-loclist-follow";
    version = flake.sources.nvimVimLoclistFollow.lastModifiedDate;
    src = flake.sources.nvimVimLoclistFollow;
    meta.homepage = "https://github.com/elbeardmorez/vim-loclist-follow";
  };
}
