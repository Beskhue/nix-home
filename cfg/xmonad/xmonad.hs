import XMonad
import XMonad.Layout.Spacing (spacingRaw, Border(..))
import XMonad.Layout.NoBorders (lessBorders, Ambiguity( Screen ))
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Operations (sendMessage)
import XMonad.Util.SessionStart (doOnce)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP(..), wrap)
import XMonad.Hooks.ManageDocks (docks, avoidStruts, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.UrgencyHook (withUrgencyHook, NoUrgencyHook(..))

import qualified DBus as D
import qualified DBus.Client as D

import Control.Monad (when, join)
import Data.Maybe (maybeToList)

myModMask = mod4Mask

barActive = "#c0333333"
barYellow = "#f9d300"
barPurple = "#9f78e1"
barRed = "#fb4934"
barRedUnderline = "#992618"


myStartupHook =
  -- Set background image.
  spawn "feh --bg-scale /home/thomas/Backgrounds/wallpaper-pixelart1.png" >>
  -- Autostart .desktop
  spawnOnce "dex -a" >>
  spawnOnce "thingshare_init" >>
  -- Patch in fullscreen support.
  doOnce addEWMHFullscreen

myKeys = [ ((myModMask, xK_f), spawn "firefox" )
         , ((myModMask, xK_p), spawn "rofi -combi-modi run,drun -show combi -modi combi" )
         , ((myModMask .|. shiftMask, xK_f), sendMessage ToggleStruts)
         , ((controlMask .|. shiftMask, xK_1), spawn "thingshare_screenshot full")
         , ((controlMask .|. shiftMask, xK_2), spawn "thingshare_screenshot display")
         , ((controlMask .|. shiftMask, xK_3), spawn "thingshare_screenshot window")
         , ((controlMask .|. shiftMask, xK_4), spawn "thingshare_screenshot region")
         , ((0, 0x1008FF02), spawn "brightness-control up")
         , ((0, 0x1008FF03), spawn "brightness-control down") 
         , ((0, 0x1008FF11), spawn "volume-control down")
         , ((0, 0x1008FF12), spawn "volume-control toggle-mute")
         , ((0, 0x1008FF13), spawn "volume-control up")
         , ((0, 0x1008FF14), spawn "playerctl play-pause")
         , ((0, 0x1008FF15), spawn "playerctl stop")
         , ((0, 0x1008FF16), spawn "playerctl previous")
         , ((0, 0x1008FF17), spawn "playerctl next")
         ]

-- Patch in fullscreen support.
addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

-- Output a string to a DBus.
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

polybarLogHook dbus = def
    {  ppOutput = dbusOutput dbus
     , ppCurrent = wrap ("%{B" ++ barActive ++ "}%{u" ++ barYellow ++  "}<") ">%{-u}%{B-}"
     , ppVisible = wrap ("%{B" ++ barActive ++ "}%{u" ++ barPurple ++ "} ") " %{-u}%{B-}"
     , ppUrgent = wrap ("%{u" ++ barRedUnderline ++ "}%{F" ++ barRed ++ "} ") "!%{F-}%{-u}"
     , ppHidden = wrap " " " "
     , ppWsSep = ""
     , ppSep = ": "
     , ppTitle = \s -> ""
    }

main = do
    num <- countScreens
    dbus <- D.connectSession
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad $ ewmh $ docks $ withUrgencyHook NoUrgencyHook $ defaults dbus

defaults dbus = defaultConfig {
      modMask = myModMask
    , terminal = "urxvt"
    , workspaces = ["1:dev", "2", "3", "4", "5", "6", "7", "8", "9"]
    , focusedBorderColor = "#FF6600"
    , layoutHook = avoidStruts
                    $ lessBorders Screen
                    $ spacingRaw True (Border 0 0 0 0) False (Border 8 8 8 8) False
                    $ onWorkspace "9" simpleTabbed
                    $ layoutHook def
    , startupHook = myStartupHook
    , logHook = dynamicLogWithPP $ polybarLogHook dbus
    , manageHook = composeOne [
        isDialog -?> doFloat
      ]
    , handleEventHook = fullscreenEventHook
} `additionalKeys` myKeys
