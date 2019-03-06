{ pkgs, ... }:

{
  imports = [
    ../common.nix
    ../cfg/xmonad
  ];

  services.polybar = {
    script = ''
      MONITOR=eDP1 polybar top &
    '';
    config."module/wlan".interface = "wlp58s0";
    config."bar/top".modules-right = "volume redshift wlan cpu memory battery date";
  };

  # Set some dpi scaling.
  xresources.properties = {
    "Xft.dpi" = 120;
  };
}
