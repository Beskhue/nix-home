{ ... }:
let
  unstable = import <unstable> { };
in
{
  home.packages = [
    unstable.rofi
  ];
  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;
}
