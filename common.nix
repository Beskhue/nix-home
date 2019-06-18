{ ... }:

let
  unstable = import <unstable> {};
  master = import ./nixpkgs {};
in
  {
    # Allow unfree software.
    nixpkgs.config.allowUnfree = true;

    # Common packages.
    home.packages = (with unstable.pkgs; [
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
            # Vi layer.
            evil
            # Package loading.
            use-package
            # Keybindings.
            general
            which-key
            projectile
            # Error checking.
            flycheck
            flycheck-inline
            lsp-mode
            lsp-ui
            company-lsp
            # Modes.
            ## Rust.
            rust-mode
            ## Magma.
            magma-mode
            # Highlight long columns.
            column-enforce-mode
            # Files.
            dired-rainbow
            dired-subtree
          ]) ++ (with epkgs.melpaStablePackages; [
            magit
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
          ]) ++ (with epkgs.elpaPackages; [
            org
            auctex
            company
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
    ]) ++ (with master.pkgs; [
      # Chat.
      discord
    ]);

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

    imports = [
      ./cfg/gtk.nix
      ./cfg/xresources
      ./cfg/dunst.nix
      ./cfg/polybar
      ./cfg/redshift
    ];
  }
