{ lib, pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ./../../nixpkgs { };
in {
  imports = [
    ../../common.nix
    ../../cfg/bspwm/castor.nix
    ../../cfg/daw
    ../../cfg/email
    ../../cfg/emacs
    ./music.nix
  ];

  services.polybar = {
    script = ''
      MONITOR=DP-4 polybar top &
      MONITOR=DVI-D-0 polybar top &
    '';
    config."module/wlan".interface = "wlp3s0";
    config."bar/top".modules-right = "wlan cpu memory date";
  };

  home.packages = (with pkgs; [ deluge ]) ++ (with unstable.pkgs; [
    # Repositories are often offline. Install through nix-env as to not
    # break this entire configuration's build.
    # steam
    # steam-run
  ]) ++ (with master.pkgs;
    [
      wineWowPackages.staging
      # wineWowPackages.winetricks
    ]) ++ (with master.pkgs; [
      # Games.
      lutris
    ]);
}
