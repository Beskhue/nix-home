{ config, pkgs, ... }:

let
  emacs-overlay = import ./emacs-overlay;
  unstable = import <unstable> { overlays = [ emacs-overlay ]; };
  master = import ./nixpkgs { };
  emacs-overrides = self: super: rec { seq = null; };
in {
  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # Common packages.
  home.packages = (with unstable.pkgs; [
    (import ./my-programs/brightness-control)
    (import ./my-programs/volume-control)
    (import ./my-programs/thingshare)
    (import ./my-programs/extract)
    # Fuzzy finder.
    fzf
    # Dotfiles manager.
    yadm
    # Editor.
    (((emacsPackagesGen emacsGit).overrideScope'
      emacs-overrides).emacsWithPackages (epkgs:
        (with epkgs.melpaPackages; [
          # Vi layer.
          evil
          evil-collection
          # Keybindings.
          general
          which-key
          projectile
          # Debugging.
          dap-mode
          # Modes.
          ## Rust.
          rust-mode
          ## Magma.
          magma-mode
          ## Javascript.
          prettier-js
          ## Python.
          blacken
          # Highlight long columns.
          column-enforce-mode
          # Files.
          dired-rainbow
          dired-subtree
        ]) ++ (with epkgs.melpaStablePackages; [
          # Vcs.
          magit
          # Package loading.
          use-package
          # Modeline.
          moody
          minions
          # Themes.
          zenburn-theme
          solarized-theme
          monokai-theme
          all-the-icons
          # Files.
          neotree
          # Modes.
          markdown-mode
          nix-mode
          haskell-mode
          yaml-mode
          ## R.
          ess
          ess-R-data-view
          # Movement.
          drag-stuff
          # Search and completion.
          ivy
          swiper
          counsel
          avy
          yasnippet
          # Scheduling.
          org-super-agenda
        ]) ++ (with epkgs.elpaPackages; [ org eglot company auctex ])))
    # The basics.
    firefox
    thunderbird
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
    # Password manager.
    keepassxc
    # Databases
    dbeaver # Database GUI.
    # File formatting.
    nixfmt
    (python3.withPackages (python-packages: with python-packages; [ numpy ]))
    (texlive.combine {
      inherit (pkgs.texlive)
        amsmath # Math
        amsfonts # Math
        # psfonts # textcomp
        cm-super scheme-small apacite floatflt wrapfig # Figures
        enumitem courier # Font
        hyperref capt-of;
    })
  ]) ++ (with master.pkgs;
    [
      # Chat.
      discord
    ]) ++ (with pkgs;
      [
        # Cloud.
        seafile-client
      ]);

  services.syncthing = { enable = true; };

  # Nix direnv handler.
  services.lorri = { enable = true; };

  programs.mpv = {
    enable = true;
    config = {
      # OSD.
      "--osd-on-seek" = "msg-bar";
      # Fuzzy sub name matching for autoload.
      sub-auto = "fuzzy";
    };

    bindings = {
      MBTN_LEFT = "cycle pause";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
    };
  };

  # A systemd target to hook other units onto.
  # This is supposed to run when the window manager has started.
  systemd.user.targets.window-manager = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      Description = "window manager";
    };
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

  imports = [
    ./cfg/alacritty
    ./cfg/nvim
    ./cfg/email
    ./cfg/gtk.nix
    ./cfg/xresources
    ./cfg/dunst.nix
    ./cfg/polybar
    ./cfg/redshift
  ];
}
