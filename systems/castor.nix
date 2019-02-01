{ pkgs, ... }:

{
  imports = [
    ../cfg/dunst.nix
  ];

  home.packages = with pkgs; [
    # Games.
    steam
  ];
}

