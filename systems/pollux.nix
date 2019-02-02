{ pkgs, ... }:

{
  imports = [
    ../common.nix
    ((import ../cfg/xmonad) ["eDP1"])
  ];

  # Set some dpi scaling.
  xresources.properties = {
    "Xft.dpi" = 120;
  };
}
