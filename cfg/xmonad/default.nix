monitors: { lib, ... }:

let
  monitorsStr = lib.concatMapStringsSep ", " (m: ''"${m}"'') monitors;
in
  {
    home.file.".xmonad/lib/MyMonitors.hs".text = ''
      module MyMonitors where

      monitors = [${monitorsStr}]
    '';
    home.file.".xmonad/xmonad.hs".text = lib.readFile ./xmonad.hs;
  }