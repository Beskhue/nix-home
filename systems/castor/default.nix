{ lib, pkgs, ... }:
let
  unstable = import <unstable> {};
  master = import ./../../nixpkgs {};
in
  {
    imports = [
      ../../common.nix
      ../../cfg/bspwm/castor.nix
      ./music.nix
    ];

    services.polybar = {
      script = ''
        MONITOR=DP-4 polybar top &
        MONITOR=DVI-D-0 polybar top &
      '';
      config."module/wlan".interface = "wlp3s0";
      config."bar/top".modules-right = "volume redshift wlan cpu memory date";
    };

    home.packages = (with pkgs;
        [
          deluge
        ]
      ) ++ (with unstable.pkgs;
        [
          # Games.
          steam
          steam-run
          lutris
          wineWowPackages.staging
          # wineWowPackages.winetricks
        ]
      ) ++ (with master.pkgs;
        [
        ]
      );
  }
