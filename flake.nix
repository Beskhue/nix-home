{
  inputs = {
    nvimPlenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    nvimPopup = {
      url = "github:nvim-lua/popup.nvim";
      flake = false;
    };
    nvimTelescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    nvimTreesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvimTreesitterTextobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };
    nvimMonochrome = {
      url = "github:fxn/vim-monochrome";
      flake = false;
    };
    nvimCompletionNvim = {
      url = "github:nvim-lua/completion-nvim";
      flake = false;
    };
    awesomeSharedtags = {
      url = "github:Drauthius/awesome-sharedtags";
      flake = false;
    };
    awesomeLain = {
      url = "github:lcpz/lain";
      flake = false;
    };
    awesomeFreedesktop = {
      url = "github:lcpz/awesome-freedesktop";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , nvimPlenary
    , nvimPopup
    , nvimTelescope
    , nvimTreesitter
    , nvimTreesitterTextobjects
    , nvimMonochrome
    , nvimCompletionNvim
    , awesomeSharedtags
    , awesomeLain
    , awesomeFreedesktop
    }: {
      sources = {
        inherit nvimPlenary nvimPopup nvimTelescope nvimTreesitter
          nvimTreesitterTextobjects nvimMonochrome nvimCompletionNvim awesomeSharedtags awesomeLain awesomeFreedesktop;
      };
    };
}
