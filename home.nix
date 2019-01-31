{ config, pkgs, ... }:
let
  system_name = import ./system_name.nix;
in
  {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Common packages.
    home.packages = [
      (import ./my-programs/volume-control)
      (import ./my-programs/thingshare)
    ];

    imports = [
      (./systems + "/${system_name}.nix")
    ];
  }
