{ pkgs, ... }:

{
  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # Common packages.
  home.packages = with pkgs; [
    (import ./my-programs/brightness-control)
    (import ./my-programs/volume-control)
    (import ./my-programs/thingshare)
    (import ./my-programs/extract)
    # Dotfiles manager.
    yadm
    # Editor.
    ((emacsPackagesNgGen (emacs.override {
      withGTK3 = true;
      withGTK2 = false;
    })).emacsWithPackages (epkgs:
        (with epkgs.melpaPackages; [
          use-package
          evil
          general
          which-key
          projectile
          flycheck
          flycheck-inline
          flycheck-rust
          zenburn-theme
          rust-mode
          cargo
          racer
          magma-mode
          column-enforce-mode
        ]) ++ (with epkgs.melpaStablePackages; [
          fill-column-indicator
          magit
          smart-mode-line
          monokai-theme
          neotree
          markdown-mode
          nix-mode
          haskell-mode
          ess # R
          ess-R-data-view
          ivy
          swiper
          counsel
          avy
        ]) ++ (with epkgs.elpaPackages; [
          org
          beacon
          auctex
          company
        ])
      )
    )
    # The basics.
    firefox
    thunderbird
    # Chat.
    mydiscord
    # Cloud.
    seafile-client
    # Tools.
    direnv
    libnotify
    gnome3.gnome-system-monitor
    filelight
    ark
    # Font tools.
    gnome3.gucharmap
    # Documents.
    nomacs
    okular
    zathura
    libreoffice
    # Databases
    dbeaver # Database GUI.
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
          amsmath # Math
          amsfonts # Math
          # psfonts # textcomp
          cm-super
          scheme-small
          apacite
          floatflt wrapfig # Figures
          enumitem
          courier # Font
          hyperref
          capt-of
        ;
      }
    )
  ];

  imports = [
    ./cfg/gtk.nix
    ./cfg/xresources.nix
    ./cfg/dunst.nix
    ./cfg/polybar
    ./cfg/redshift
  ];
}
