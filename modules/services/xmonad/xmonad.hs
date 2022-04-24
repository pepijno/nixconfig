import qualified Data.Map as M
import System.Exit (exitSuccess)
import XMonad
import XMonad.Actions.CopyWindow (copy, killAllOtherCopies, copyToAll)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isDialog, doFullFloat, isFullscreen)
import XMonad.Layout.Spacing (spacing)
import qualified XMonad.StackSet as W
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Actions.MouseResize (mouseResize)
import XMonad.Layout.WindowArranger (windowArrange)
import XMonad.Layout.Fullscreen (fullscreenFull, fullscreenFloat)
import qualified XMonad.Util.Hacks as Hacks

import Data.Maybe (fromJust)

myTerminal :: String
myTerminal = "${alacritty}/bin/alacritty"

myWorkspaces :: [String]
myWorkspaces = [" term ", " vivaldi ", " firefox ", " tor ", " steam "]

myWorkspaceIndices :: M.Map String Int
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..]


actionPrefix, actionButton, actionSuffix :: [Char]
actionPrefix = "<action=`${xdotool}/bin/xdotool key alt+"
actionButton = "` button="
actionSuffix = "</action>"

addActions :: [(String, Int)] -> String -> String
addActions [] ws = ws
addActions (x:xs) ws = addActions xs (actionPrefix ++ k ++ actionButton ++ show b ++ ">" ++ ws ++ actionSuffix)
    where k = fst x
          b = snd x

myKeys :: [(String, X())]
myKeys = [ ("M-<Return>",   spawn myTerminal)
         , ("M-d",          spawn "${menu}/bin/menu")
         , ("M-S-e",        spawn "${sysmenu}/bin/sysmenu")
         , ("M-S-q",        kill)
         , ("M-f",          sendMessage NextLayout >> sendMessage ToggleStruts)
         -- , ("M-S-<Space>", setLayout myLayout)
         , ("M-n",          refresh)
         , ("M-<Tab>",      windows W.focusDown)
         , ("M-S-<Tab>",    windows W.focusUp)
         , ("M-j",          windows W.focusDown)
         , ("M-k",          windows W.focusUp)
         , ("M-m",          windows W.focusMaster)
         , ("M-S-<Return>", windows W.swapMaster)
         , ("M-S-j",        windows W.swapDown)
         , ("M-S-k",        windows W.swapUp)
         , ("M-h",          sendMessage Shrink)
         , ("M-l",          sendMessage Expand)
         , ("M-t",          withFocused $ windows . W.sink)
         , ("M-b",          sendMessage ToggleStruts)
         , ("M-S-c",        io exitSuccess)
         , ("M-r",          spawn "${busybox}/bin/killall xmobar; ${xmonad}/bin/xmonad --restart")

         , ("M-C-a", windows copyToAll)
         , ("M-C-z", killAllOtherCopies)

         , ("M-S-b", spawn "${vivaldi}/bin/vivaldi")
         , ("M-S-f", spawn "${firefox}/bin/firefox")
         , ("M-S-o", spawn "${tor}/bin/tor-browser")
         , ("M-S-s", spawn "${steam}/bin/steam")

         , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
         , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
         , ("<XF86AudioMute>",        spawn "pactl set-sink-volume @DEFAULT_SINK@ toggle")
         , ("<XF86AudioPlay>",        spawn "${playerctl}/bin/playerctl play")
         , ("<XF86AudioPause>",       spawn "${playerctl}/bin/playerctl pause")
         , ("<XF86AudioNext>",        spawn "${playerctl}/bin/playerctl next")
         , ("<XF86AudioPrev>",        spawn "${playerctl}/bin/playerctl previous")
         ]
      ++ [ ("M-" ++ show k, windows $ W.greedyView i)| (i, k) <- zip myWorkspaces [1..9]]
      ++ [ ("M-S-" ++ show k, windows $ W.shift i)| (i, k) <- zip myWorkspaces [1..9]]
      ++ [ ("M-C-" ++ show k, windows $ copy i)| (i, k) <- zip myWorkspaces [1..9]]

myLayout = mouseResize $ windowArrange layouts
  where
    layouts = avoidStruts (spacing 10 tiled) ||| (fullscreenFloat . fullscreenFull) Full
    tiled = Tall 1 (3/100) (1/2)

myManageHook =
  composeAll
    [ isFullscreen                                      --> (doF W.focusDown <+> doFullFloat),
      isDialog                                          --> doFloat,
      className =? "Vivaldi-stable"                     --> doShift (myWorkspaces !! 1),
      className =? "firefox"                            --> doShift (myWorkspaces !! 2),
      className =? "Tor Browser"                        --> doShift (myWorkspaces !! 3),
      className =? "Steam"                              --> doShift (myWorkspaces !! 4),
      className =? "firefox" <&&> resource =? "Toolkit" --> doFloat
    ] <+> manageDocks

myStartupHook = do
  spawnOnce "${solaar}/bin/solaar"
  spawnOnce "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"
  spawnOnce "${sw}/bin/systemctl --user start dunst.service"
  spawnOnce "${sw}/bin/systemctl --user start redshift.service"
  spawnOnce "${sw}/bin/systemctl --user start xidlehook.service"
  spawn "${xrandr}/bin/xrandr -s 1920x1080"
  spawn "${betterlockscreen}/bin/betterlockscreen -u ~/Pictures/Wallpapers/"
  spawn "${busybox}/bin/killall trayer; ${start-trayer}/bin/start-trayer"

defaults =
  defaultConfig { terminal          = myTerminal
                , focusFollowsMouse = True
                , clickJustFocuses  = False
                , borderWidth       = 0
                , modMask           = mod1Mask
                , workspaces        = myWorkspaces

                , layoutHook        = myLayout
                , manageHook        = myManageHook
                , startupHook       = myStartupHook
                , handleEventHook   = Hacks.trayerAboveXmobarEventHook
    } `additionalKeysP` myKeys

main = xmonad =<< statusBar myBar myPP toggleStrutsKey (ewmhFullscreen $ ewmh defaults)

myBar = "xmobar"

grey1, grey2, gray3, green, orange :: String
grey1  = "#B4BCCD"
grey2  = "#555E70"
gray3  = "#8691A8"
green  = "#98be65"
orange = "#C45500"

clickable ws = addActions [ (show i, 1), ("Left", 4), ("Right", 5) ] ws
                    where i = fromJust $ M.lookup ws myWorkspaceIndices

myPP = xmobarPP
  { ppSep ="<fc=" ++ orange ++ "> <fn=1>|</fn> </fc>"
  , ppWsSep = "  "
  , ppCurrent = xmobarColor green "" . wrap ("<box type=Bottom width=2 mb=2 color=" ++ green ++ ">") "</box>"
  , ppVisible = xmobarColor gray3 "" . clickable
  , ppHidden = xmobarColor gray3 "" . wrap ("<box type=Top width=2 mt=2 color=" ++ gray3 ++ ">") "</box>" . clickable
  , ppHiddenNoWindows = xmobarColor grey2 "" . clickable
  , ppUrgent = xmobarColor orange "" . clickable
  , ppTitle = xmobarColor grey1 "" . shorten 50
  , ppOrder = \(ws:l:t:_) -> [ws, t]
  }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
