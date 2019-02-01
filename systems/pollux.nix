{ pkgs, ... }:

{
  imports = [
    ../common.nix
    ((import ../cfg/xmonad) ["eDP1"])
  ];
}
