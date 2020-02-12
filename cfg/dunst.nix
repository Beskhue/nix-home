{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
    };
    settings = {
      global = {
        markup = true;
        sort = false;
        alignment = "left";
        word_wrap = true;
        ignore_newline = false;
        geometry = "350x5-15+49";
        shrink = false;
        transparency = 5;
        show_indicators = true;
        line_height = 1;
        separator_height = 2;
        separator_color = "frame";
        dmenu = "rofi -dmenu -p dunst";
        browser = "firefox -new-tab";
        icon_position = "left";
        max_icon_size = 80;
        frame_width = 2;
        frame_color = "#585858";
        font = "Noto Sans 11";
        allow_markup = true;
        format = "<b>%a</b>\\n%s\\n%b";
        padding = 8;
        horizontal_padding = 8;
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        background = "#383838";
        foreground = "#BCE5AA";
        timeout = 5;
      };
      urgency_normal = {
        background = "#383838";
        foreground = "#AADDE5";
        timeout = 15;
      };
      urgency_critical = {
        background = "#383838";
        foreground = "#ED945C";
        timeout = 0;
      };
    };
  };
}
