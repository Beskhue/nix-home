{ buildVimPluginFrom2Nix, fetchFromGitHub, ... }: {
  popup = buildVimPluginFrom2Nix rec {
    pname = "popup";
    version = "8f128cc7b2a1d759ce343ef92ea311526c6bbe13";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "popup.nvim";
      rev = "${version}";
      sha256 = "1jxy6lp7r1wvd296x4ql6c9w43iwdwaf8jzyg5azs3x9cdyx9b73";
    };
    meta.homepage = "https://github.com/nvim-lua/popup.nvim";
  };
  plenary = buildVimPluginFrom2Nix rec {
    pname = "plenary";
    version = "7ca2d02ea5565c862066aac2efac05761a72d697";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "${version}";
      sha256 = "0iphxdjk6w59kwql3gprjig3v6gmxsfsryxay3lvybimifp7nk3q";
    };
    meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
  };
  telescope = buildVimPluginFrom2Nix rec {
    pname = "telescope";
    version = "d493a76058839d039593ad6be4df9c9c697ebf10";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "telescope.nvim";
      rev = "${version}";
      sha256 = "06z0b6n60xxdj4rm7nj89r87d4rilg90jwr3ivqz8d232bl77270";
    };
    meta.homepage = "https://github.com/nvim-lua/telescope.nvim";
  };
  nvim-treesitter = buildVimPluginFrom2Nix {
    pname = "nvim-treesitter";
    version = "2020-10-13";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "1a62b97ccd8d1c8fdd258cb7232161de042a61d3";
      sha256 = "10lhk03abl5frya8q2rcgg2qb7af73rvc0ahl7dcnng4ryxj73ah";
    };
    meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter/";
  };
  vim-monochrome = buildVimPluginFrom2Nix {
    pname = "vim-monochrome";
    version = "2019-05-08";
    src = fetchFromGitHub {
      owner = "fxn";
      repo = "vim-monochrome";
      rev = "34abe27b75e41aa9387bd4c4352340d3636248af";
      sha256 = "0dqlr2d5svki78yj2vsa5ljai1s2njsz0sfbjx0p3chqqgsxkdrw";
    };
    meta.homepage = "https://github.com/fxn/vim-monochrome";
  };
}
