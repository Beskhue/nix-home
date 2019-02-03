{ lib, pkgs, ... }:

{
  imports = [
    ../common.nix
    ../cfg/xmonad
  ];

  services.polybar = {
    script = ''
      MONITOR=DP-4 polybar top &
      MONITOR=DVI-D-0 polybar top &
    '';
    config."module/wlan".interface = "wlp3s0";
    config."bar/top".modules-right = "volume wlan cpu memory date";
  };

  home.packages = with pkgs; [
    # Games.
    steam
  ];
}
