{ config, pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ./nixpkgs { };
in {
  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # Common packages.
  home.packages = [
    (import ./my-programs/brightness-control)
    (import ./my-programs/volume-control)
    (import ./my-programs/thingshare)
    (import ./my-programs/extract)
  ] ++ (with pkgs; [
    # Font tools.
    gnome3.gucharmap
    # Tools.
    gnome3.gnome-system-monitor
    libnotify
    filelight
    ark
    # Documents.
    nomacs
    okular
    zathura
    libreoffice
    # Databases
    dbeaver # Database GUI.
    # Cloud.
    seafile-client
    # TeX.
    (texlive.combine {
      inherit (texlive)
        amsmath # Math
        amsfonts # Math
        logreq # Automation, necessary for biblatex
        biblatex biblatex-ieee # References
        # psfonts # textcomp
        cm-super scheme-small apacite floatflt wrapfig # Figures
        enumitem courier # Font
        hyperref capt-of;
      })
    biber # For LaTeX.
  ]) ++ (with unstable.pkgs; [
    # Fuzzy finder.
    fzf
    # Dotfiles manager.
    yadm
    # Editor.
    # The basics.
    firefox
    thunderbird
    # Tools.
    direnv
    # Password manager.
    keepassxc
    # File formatting.
    nixfmt
    (python3.withPackages (python-packages: with python-packages; [ numpy ]))
  ]) ++ (with master.pkgs;
    [
      # Chat.
      discord
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
    ./cfg/gtk.nix
    ./cfg/xresources
    ./cfg/dunst.nix
    ./cfg/polybar
    ./cfg/redshift
  ];
}
