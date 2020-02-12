{ pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ../../nixpkgs { };
in {
  home.packages = with pkgs; [
    # Generic LV2
    jalv
    lilv
    # Plugin host
    carla
    # Synths
    zynaddsubfx
    helm
    qsynth
    ### Plugins
    # LV2
    avldrums-lv2
    drumkv1
    fmsynth
    # DSSI
    xsynth_dssi
    # Collections
    zam-plugins
    ### DAW
    ardour
    # Use latest renoise, with stable libjack2 version.
    (master.renoise.override { libjack2 = libjack2; })
  ];
}
