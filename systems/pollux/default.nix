{ pkgs, ... }:

{
  imports = [ ../../common.nix ../../cfg/bspwm/pollux.nix ../../cfg/email ];

  services.polybar = {
    script = ''
      MONITOR=eDP1 polybar top &
      MONITOR=DP1 polybar top &
    '';
    config."module/wlan".interface = "wlp58s0";
    config."bar/top".modules-right =
      "wlan cpu memory battery date";
  };

  # Set some dpi scaling.
  xresources.properties = { "Xft.dpi" = 120; };
}
