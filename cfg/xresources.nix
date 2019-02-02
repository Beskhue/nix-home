{
  xresources.properties = {
    "URxvt.depth" = 32;
    "URxvt.background" = "[95]#272822";
    "URxvt.scrollBar" = false;
    "URxvt*urgentOnBell" = true;
    "URxvt*font" = "xft:Source Code Pro:style=Regular:size=11:antialias=true";
    "URxvt*boldFont" = "xft:Source Code Pro:style=Bold:size=11:antialias=true";
    "URxvt*italicFont" = "xft:Source Code Pro:style=Italic:size=11:antialias=true";
    "URxvt*boldItalicFont" = "xft:Source Code Pro:style=Bold Italic:size=11:antialias=true";
    "URxvt*letterSpace" = 0;
    # Better rendering.
    "Xft.antialias" = true;
    "Xft.hinting" = true;
    "Xft.rgba" = "rgb";
    "Xft.autohint" = false;
    "Xft.hintstyle" = "hintslight";
    "Xft.lcdfilter" = "lcddefault";
  };

  # Monokai Dark.
  xresources.extraConfig = ''
    ! special
    *.foreground:   #f8f8f2
    *.background:   #272822
    *.cursorColor:  #f8f8f2

    ! black
    *.color0:       #272822
    *.color8:       #75715e

    ! red
    *.color1:       #f92672
    *.color9:       #f92672

    ! green
    *.color2:       #a6e22e
    *.color10:      #a6e22e

    ! yellow
    *.color3:       #f4bf75
    *.color11:      #f4bf75

    ! blue
    *.color4:       #66d9ef
    *.color12:      #66d9ef

    ! magenta
    *.color5:       #ae81ff
    *.color13:      #ae81ff

    ! cyan
    *.color6:       #a1efe4
    *.color14:      #a1efe4

    ! white
    *.color7:       #f8f8f2
    *.color15:      #f9f8f5
  '';
}
