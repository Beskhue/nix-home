{ config, pkgs, ... }:

let
  background = "#b0000000";
  foreground = "#dfdfdf";
  foreground-alt = "#afafaf";
  red = "#f90000";
  yellow = "#f9d300";
  purple = "#9f78e1";
  cyan = "#4bffdc";
  redshift-info = import ./scripts/redshift-info.nix;
  redshift-toggle = import ./scripts/redshift-toggle.nix;
in
  {
    config.home.packages = [ redshift-info ];
    config.services.polybar = {
    enable = true;
    config = {
      "bar/top" = {
        monitor = "\${env:MONITOR}";
        width = "100%";
        height = 30;
        background = background;
        foreground = foreground;
        underline-size = 2;
        underline-color = "#eeeeee";
        spacing = 0;
        padding-left = 0;
        padding-right = 1;
        module-margin-left = 1;
        module-marin-right = 1;
        font-0 = "Source Code Pro:pixelsize=12;0";
        font-1 = "Siji:pixelsize=10;0";
        font-2 = "Unifont:size=9:antialias=false;0";
        font-3 = "Twitter Color Emoji:size=10;0";
        modules-left = "xmonad";
        modules-center = "xwindow";
        # modules-right = "volume wlan cpu memory date";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:40:...%";
        label-padding = 2;
      };
      "module/date" = {
        type = "internal/date";
        interval = "1.0";
        date = "%a %b %d";
        time = "%H:%M";
        label = "%date% %time%";
      };
      "module/volume" = {
        type = "internal/alsa";
        format-volume = "<label-volume> <bar-volume>";
        label-volume = "";
        label-volume-foreground = foreground-alt;
        format-muted-prefix = " ";
        format-muted-foreground = foreground-alt;
        label-muted = "sound muted";

        bar-volume-width = 10;
        bar-volume-foreground-0 = "#55aa55";
        bar-volume-foreground-1 = "#55aa55";
        bar-volume-foreground-2 = "#55aa55";
        bar-volume-foreground-3 = "#55aa55";
        bar-volume-foreground-4 = "#55aa55";
        bar-volume-foreground-5 = "#f5a70a";
        bar-volume-foreground-6 = "#ff5555";
        bar-volume-gradient = false;
        bar-volume-indicator = "|";
        bar-volume-indicator-font = 2;
        bar-volume-fill = "─";
        bar-volume-fill-font = 2;
        bar-volume-empty = "─";
        bar-volume-empty-font = 2;
        bar-volume-empty-foreground = foreground-alt;
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = foreground-alt;
        format-underline = red;
        label = "%percentage:2%%";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 3;
        format-prefix = " ";
        format-prefix-foreground = foreground-alt;
        format-underline = cyan;
        label = "%percentage_used%%";
      };
      "module/wlan" = {
        type = "internal/network";
        #interface = "wlp3s0";
        interval = "3.0";

        format-connected = "<ramp-signal> <label-connected>";
        format-connected-underline = purple;
        label-connected = "%essid%";

        format-disconnected = "";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = foreground-alt;
      };
      "module/battery" = {
        type = "internal/battery";
        full-at = 99;
        battery = "BAT0";
        adapter = "ADP1";
        poll-interval = 5;
        time-format = "%H:%M";
        format-charging-underline = yellow;
        format-discharging-underline = yellow;
        format-charging = "<animation-charging> <label-charging>";
        format-discharging = "<ramp-capacity> <label-discharging>";
        label-charging = "Charging %percentage%%";
        label-discharging = "%percentage%% (%time%)";
        label-full = "Fully charged";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capcity-foreground = foreground-alt;
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-framerate = 750;
        animation-charging-foreground = foreground-alt;
      };
      "module/xmonad" = {
        type = "custom/script";
        exec = "${pkgs.xmonad-log}/bin/xmonad-log";
        tail = true;
      };
      "module/redshift" = {
        type = "custom/script";
        exec = "${redshift-info}/bin/redshift-info";
        click-left = "${redshift-toggle}/bin/redshift-toggle";
        interval = 5;
        format-prefix = " ";
        format-underline = "#f9d300";
      };
    };
  };
}
