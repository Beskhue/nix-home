{ config, pkgs, ... }:

{
  # Common packages.
  home.packages = with pkgs; [
    (import ./my-programs/brightness-control)
    (import ./my-programs/volume-control)
    (import ./my-programs/thingshare)
    # Dotfiles manager.
    yadm
    # Editor.
    ((emacsPackagesNgGen (emacs.override {
      withGTK3 = true;
      withGTK2 = false;
    })).emacsWithPackages (epkgs:
        (with epkgs.melpaStablePackages; [
          use-package
          evil
          evil-collection
          magit
          smart-mode-line
          monokai-theme
          neotree
          markdown-mode
          rust-mode
          nix-mode
          cargo
          haskell-mode
          ess # R
        ]) ++ (with epkgs.elpaPackages; [
          beacon
          auctex
          ivy
        ])
      )
    )
    # The basics.
    firefox
    thunderbird
    # Cloud.
    seafile-client
    # Tools.
    direnv
    libnotify
    # Documents.
    nomacs
    okular
    zathura
    libreoffice
    (
      python3.withPackages (
        python-packages: with python-packages; [
          numpy
        ]
      )
    )
    (
      texlive.combine {
        inherit (pkgs.texlive)
          scheme-small
          apacite
          floatflt wrapfig # Figures
          enumitem
          courier # Font
        ;
      }
    )
  ];

  imports = [
    ./cfg/gtk.nix
    ./cfg/xresources.nix
    ./cfg/dunst.nix
    ./cfg/polybar
  ];
}
