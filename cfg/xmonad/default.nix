monitors: { lib, ... }:

let
  monitorsStr = lib.concatMapStringsSep ", " (m: ''"${m}"'') monitors;
in
  {
    home.file.".xmonad/lib/MyMonitors.hs".text = ''
      module MyMonitors where

      monitors = [${monitorsStr}]
    '';
    xsession.windowManager.xmonad.config = lib.readFile ./xmonad.hs;
  }