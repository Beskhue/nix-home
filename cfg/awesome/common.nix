{ lib, pkgs, ... }:
let
  flake = (import
    (fetchTarball {
      url =
        "https://github.com/edolstra/flake-compat/archive/c75e76f80c57784a6734356315b306140646ee84.tar.gz";
      sha256 = "071aal00zp2m9knnhddgr2wqzlx6i6qa1263lv1y7bdn2w20h10h";
    })
    { src = ../../.; }).defaultNix;
  lain = pkgs.luaPackages.toLuaModule (pkgs.stdenv.mkDerivation rec {
    pname = "lain";
    version = flake.sources.awesomeLain.lastModifiedDate;
    src = flake.sources.awesomeLain;
    buildInputs = [ pkgs.lua ];
    installPhase = ''
      mkdir -p $out/lib/lua/${pkgs.lua.luaversion}/
      cp -r . $out/lib/lua/${pkgs.lua.luaversion}/lain/
      printf "package.path = '$out/lib/lua/${pkgs.lua.luaversion}/?/init.lua;' .. package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${pkgs.lua.luaversion}/lain.lua
    '';
  });
  freedesktop = pkgs.luaPackages.toLuaModule (pkgs.stdenv.mkDerivation rec {
    pname = "freedesktop";
    version = flake.sources.awesomeFreedesktop.lastModifiedDate;
    src = flake.sources.awesomeFreedesktop;
    buildInputs = [ pkgs.lua ];
    installPhase = ''
      mkdir -p $out/lib/lua/${pkgs.lua.luaversion}/
      cp -r . $out/lib/lua/${pkgs.lua.luaversion}/freedesktop/
      printf "package.path = '$out/lib/lua/${pkgs.lua.luaversion}/?/init.lua;' .. package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${pkgs.lua.luaversion}/freedesktop.lua
    '';
  });
in
{
  xsession.enable = true;
  # xsession.windowManager.command = "";
  xsession.windowManager.awesome = {
    enable = true;
    luaModules = [ lain freedesktop ];
  };

  home.packages = [
    pkgs.sxhkd
  ];

  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
  xdg.configFile."awesome/sharedtags/init.lua".source = "${flake.sources.awesomeSharedtags.outPath}/init.lua";
  # xdg.configFile."awesome/themes".source = ./awesome-copycats/themes;
  xdg.configFile."sxhkd/sxhkdrc".text = ''
    ##########################
    # Hotkeys.
    ##########################

    super + w
        firefox

    super + f
        dolphin

    ctrl + shift + 1
        thingshare_screenshot full

    ctrl + shift + 2
        thingshare_screenshot display

    ctrl + shift + 3
        thingshare_screenshot window

    ctrl + shift + 4
        thingshare_screenshot region

    # Reload sxhkd configuration.
    super + Escape
        pkill -USR1 -x sxhkd

    ##########################
    # Media keys.
    ##########################

    XF86MonBrightnessUp
        brightness-control up

    XF86MonBrightnessDown
        brightness-control down

    XF86AudioLowerVolume
        volume-control down

    XF86AudioMute
        volume-control toggle-mute

    XF86AudioRaiseVolume
        volume-control up

    XF86AudioPlay
        playerctl play-pause

    XF86AudioStop
        playerctl stop

    XF86AudioPrev
        playerctl previous

    XF86AudioNext
        playerctl next
  '';

  # popup = buildVimPluginFrom2Nix rec {
  #   pname = "popup";
  #   version = flake.sources.nvimPopup.lastModifiedDate;
  #   src = flake.sources.nvimPopup;
  #   meta.homepage = "https://github.com/nvim-lua/popup.nvim";
  # };
}
