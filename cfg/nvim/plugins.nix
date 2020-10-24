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
    version = flake.sources.nvimPopup.rev;
    src = flake.sources.nvimPopup;
    meta.homepage = "https://github.com/nvim-lua/popup.nvim";
  };
  plenary = buildVimPluginFrom2Nix rec {
    pname = "plenary";
    version = flake.sources.nvimPlenary.rev;
    src = flake.sources.nvimPlenary;
    meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
  };
  telescope = buildVimPluginFrom2Nix rec {
    pname = "telescope";
    version = flake.sources.nvimTelescope.rev;
    src = flake.sources.nvimTelescope;
    meta.homepage = "https://github.com/nvim-lua/telescope.nvim";
  };
  nvim-treesitter = buildVimPluginFrom2Nix {
    pname = "nvim-treesitter";
    version = flake.sources.nvimTreesitter.rev;
    src = flake.sources.nvimTreesitter;
    meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter/";
  };
  vim-monochrome = buildVimPluginFrom2Nix {
    pname = "vim-monochrome";
    version = flake.sources.nvimMonochrome.rev;
    src = flake.sources.nvimMonochrome;
    meta.homepage = "https://github.com/fxn/vim-monochrome";
  };
  completion-nvim = buildVimPluginFrom2Nix {
    pname = "completion-nvim";
    version = flake.sources.nvimCompletionNvim.rev;
    src = flake.sources.nvimCompletionNvim;
    meta.homepage = "https://github.com/nvim-lua/completion-nvim";
  };
}
