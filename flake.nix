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
      url = "github:nvim-lua/telescope.nvim";
      flake = false;
    };
    nvimTreesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvimMonochrome = {
      url = "github:fxn/vim-monochrome";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nvimPlenary, nvimPopup, nvimTelescope
    , nvimTreesitter, nvimMonochrome }: {
      sources = {
        inherit nvimPlenary nvimPopup nvimTelescope nvimTreesitter
          nvimMonochrome;
      };
    };
}
