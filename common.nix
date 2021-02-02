{ config, pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ./nixpkgs { };
in
{
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
    calc
    leafpad
    transmission-gtk
    # Documents.
    nomacs
    okular
    zathura
    libreoffice
    # Cloud.
    seafile-client
    # Compiling.
    gcc
    gnumake
    # Debugging.
    ltrace
    gdb
    lldb
    gdbgui
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
    chromium
    thunderbird
    # Tools.
    direnv
    nox
    ripgrep
    # Password manager.
    keepassxc
    # File formatting.
    nixpkgs-fmt
    (python3.withPackages (python-packages: with python-packages; [ numpy ]))
    # Chat.
    discord
    # Music.
    spotify
  ]) ++ (with master.pkgs; [
    # Databases.
    dbeaver
  ]);

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "text/plain" = [ "nvim-qt.desktop" ];
      "application/octet-stream" = [ "firefox.desktop" ];
      "image/svg+xml" = [ "nvim-qt.desktop" ];
    };
    associations.added = { };
  };

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
    ./cfg/picom
    ./cfg/alacritty
    ./cfg/nvim
    ./cfg/gtk.nix
    ./cfg/xresources
    ./cfg/dunst.nix
    ./cfg/redshift
    ./cfg/rofi
  ];
}
