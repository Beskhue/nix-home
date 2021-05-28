{ lib, pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ./../../nixpkgs { };
in
{
  imports = [
    ../../common.nix
    ../../cfg/awesome/castor.nix
    ../../cfg/daw
    ../../cfg/email
    ./music.nix
  ];

  home.packages = (with pkgs; [
    deluge
    # Games.
    lutris
    # Disassembly.
    ghidra-bin
    radare2-cutter
    # E-book management.
    # calibre
  ]) ++ (with unstable.pkgs; [
    # E-book management.
    calibre

    wineWowPackages.staging
    winetricks

    # Repositories are often offline. Install through nix-env as to not
    # break this entire configuration's build.
    # steam
    # steam-run
  ]) ++ (with master.pkgs;
    [
      # Games.
      lutris
    ]);
}
