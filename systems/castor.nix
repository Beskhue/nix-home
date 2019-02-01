{ lib, pkgs, ... }:

{
  imports = [
    ../common.nix
    ((import ../cfg/xmonad) ["DP-4" "DVI-D-0"])
  ];

  home.packages = with pkgs; [
    # Games.
    steam
  ];
}
