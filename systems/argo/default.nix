{ pkgs, ... }:

{
  imports = [
    ../../common.nix
    ../../cfg/bspwm/pollux.nix
    ../../cfg/daw
    ../../cfg/email
  ];

  services.polybar = {
    script = ''
      MONITOR=eDP-1-1 polybar top &
    '';
    config."module/wlan".interface = "wlp59s0";
    config."bar/top".modules-right = "wlan cpu memory battery date";
  };

  # Set some dpi scaling.
  xresources.properties = { "Xft.dpi" = 96; };
}
