import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D
import qualified Data.Map as M
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import Data.Maybe (fromJust)

myTerminal = "${alacritty}/bin/alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 0

myModMask = mod1Mask

myWorkspaces = ["1", "2", "3", "4", "5"]

actionPrefix, actionButton, actionSuffix :: [Char]
actionPrefix = "<action=`xdotool key super+"
actionButton = "` button="
actionSuffix = "</action>"

addActions :: [(String, Int)] -> String -> String
addActions [] ws = ws
addActions (x:xs) ws = addActions xs (actionPrefix ++ k ++ actionButton ++ show b ++ ">" ++ ws ++ actionSuffix)
    where k = fst x
          b = snd x

myNormalBorderColor = "#dddddd"

myFocusedBorderColor = "#ff0000"

myKeys conf@XConfig {XMonad.modMask = modm} =
  M.fromList $
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf),
      ((modm, xK_d), spawn "${menu}/bin/menu"),
      ((modm .|. shiftMask, xK_e), spawn "${sysmenu}/bin/sysmenu"),
      ((modm .|. shiftMask, xK_q), kill),
      ((modm, xK_f), sendMessage NextLayout),
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      ((modm, xK_n), refresh),
      ((modm, xK_Tab), windows W.focusDown),
      ((modm .|. shiftMask, xK_Tab), windows W.focusUp),
      ((modm, xK_j), windows W.focusDown),
      ((modm, xK_k), windows W.focusUp),
      ((modm, xK_m), windows W.focusMaster),
      ((modm .|. shiftMask, xK_Return), windows W.swapMaster),
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      ((modm, xK_h), sendMessage Shrink),
      ((modm, xK_l), sendMessage Expand),
      ((modm, xK_t), withFocused $ windows . W.sink),
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      ((modm, xK_b), sendMessage ToggleStruts),
      ((modm .|. shiftMask, xK_c), io (exitWith ExitSuccess)),
      ((modm, xK_r), spawn "pkill xmobar; ${xmonad}/bin/xmonad --restart"),
      ((modm .|. shiftMask, xK_h), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
      ++ [ ((m .|. modm, k), windows $ f i)
           | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
             (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
         ]
      ++ [ ((modm .|. shiftMask .|. controlMask, xK_a), windows copyToAll),
           ((modm .|. shiftMask .|. controlMask, xK_z), killAllOtherCopies)
           --, ((modm,                               xK_f), sendMessage $ Toggle Full)
         ]
      ++ [ ((modm .|. shiftMask, xK_b), spawn "${vivaldi}/bin/vivaldi"),
           ((modm .|. shiftMask, xK_f), spawn "${firefox}/bin/firefox"),
           ((modm .|. shiftMask, xK_o), spawn "${tor}/bin/tor-browser"),
           ((modm .|. shiftMask, xK_s), spawn "${steam}/bin/steam")
         ]
      ++ [ ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
           ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
           ((0, xF86XK_AudioMute), spawn "pactl set-sink-volume @DEFAULT_SINK@ toggle"),
           ((0, xF86XK_AudioPlay), spawn "${playerctl}/bin/playerctl play"),
           ((0, xF86XK_AudioPause), spawn "${playerctl}/bin/playerctl pause"),
           ((0, xF86XK_AudioNext), spawn "${playerctl}/bin/playerctl next"),
           ((0, xF86XK_AudioPrev), spawn "${playerctl}/bin/playerctl previous")
         ]

myMouseBindings XConfig {XMonad.modMask = modm} =
  M.fromList
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
    ]

myLayout = avoidStruts (spacing 10 tiled) ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

myManageHook =
  composeAll
    [ manageDocks,
      manageHook defaultConfig,
      isFullscreen --> (doF W.focusDown <+> doFullFloat),
      isDialog --> doFloat,
      className =? "Vivaldi-stable" --> doF (W.shift "2"),
      className =? "firefox" --> doF (W.shift "3"),
      className =? "Tor Browser" --> doF (W.shift "4"),
      className =? "Steam" --> doF (W.shift "5"),
      className =? "firefox" <&&> resource =? "Toolkit" --> doFloat
    ]

myEventHook = fullscreenEventHook

myLogHook = return ()

myStartupHook = do
  spawnOnce "${pywal}/bin/wal -R"
  spawnOnce "${solaar}/bin/solaar"
  spawnOnce "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"
  spawnOnce "systemctl --user start dunst.service"
  spawnOnce "systemctl --user start redshift.service"
  spawnOnce "systemctl --user start polybar.service"
  spawnOnce "systemctl --user start xidlehook.service"
  spawn "${xrandr}/bin/xrandr -s 1920x1080"
  spawn "${restart-dunst}/bin/restart-dunst"
  spawn "${betterlockscreen}/bin/betterlockscreen -u ~/Pictures/Wallpapers/"
  spawn "systemctl --user restart picom.service"
  spawn "killall trayer; ${trayer}/bin/trayer --monitor 2 --edge top --align right --widthtype request --padding 7 --iconspacing 10 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 55 --tint 0x2B2E37  --height 29 --distance 5 &"

defaults =
  defaultConfig
    { -- simple stuff
      terminal = myTerminal,
      focusFollowsMouse = myFocusFollowsMouse,
      clickJustFocuses = myClickJustFocuses,
      borderWidth = myBorderWidth,
      modMask = myModMask,
      workspaces = myWorkspaces,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      -- key bindings
      keys = myKeys,
      mouseBindings = myMouseBindings,
      -- hooks, layouts
      layoutHook = myLayout,
      manageHook = myManageHook,
      handleEventHook = myEventHook,
      logHook = myLogHook,
      startupHook = myStartupHook
    }

help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
      "",
      "-- launching and killing programs",
      "mod-Enter        Launch xterminal",
      "mod-d            Launch menu",
      "mod-Shift-e      Launch sydmenu",
      "mod-Shift-q      Close/kill the focused window",
      "mod-Space        Rotate through the available layout algorithms",
      "mod-Shift-Space  Reset the layouts on the current workSpace to default",
      "mod-n            Resize/refresh viewed windows to the correct size",
      "",
      "-- move focus up or down the window stack",
      "mod-Tab        Move focus to the next window",
      "mod-Shift-Tab  Move focus to the previous window",
      "mod-j          Move focus to the next window",
      "mod-k          Move focus to the previous window",
      "mod-m          Move focus to the master window",
      "",
      "-- modifying the window order",
      "mod-Shift-Return   Swap the focused window and the master window",
      "mod-Shift-j        Swap the focused window with the next window",
      "mod-Shift-k        Swap the focused window with the previous window",
      "",
      "-- resizing the master/slave ratio",
      "mod-h  Shrink the master area",
      "mod-l  Expand the master area",
      "",
      "-- floating layer support",
      "mod-t  Push window back into tiling; unfloat and re-tile it",
      "",
      "-- increase or decrease number of windows in the master area",
      "mod-comma  (mod-,)   Increment the number of windows in the master area",
      "mod-period (mod-.)   Deincrement the number of windows in the master area",
      "",
      "-- quit, or restart",
      "mod-Shift-c  Quit xmonad",
      "mod-r        Restart xmonad",
      "",
      "-- Workspaces & screens",
      "mod-[1..9]   Switch to workSpace N",
      "mod-Shift-[1..9]   Move client to workspace N",
      "",
      "-- Mouse bindings: default actions bound to mouse events",
      "mod-button1  Set the window to floating mode and move by dragging",
      "mod-button2  Raise the window to the top of the stack",
      "mod-button3  Set the window to floating mode and resize by dragging",
      "",
      "-- Programs",
      "mod-Shift-b Vivaldi",
      "mod-Shift-f Firefox",
      "mod-Shift-o Tor",
      "mod-Shift-s Steam"
    ]

main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults

-- Command to launch the bar.
myBar = "xmobar"


grey1, grey2, grey3, grey4, cyan, orange :: String
grey1  = "#2B2E37"
grey2  = "#555E70"
grey3  = "#697180"
grey4  = "#8691A8"
cyan   = "#8BABF0"
orange = "#C45500"

myWorkspaceIndices :: M.Map [Char] Integer
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..]

clickable :: [Char] -> [Char] -> [Char]
clickable icon ws = addActions [ (show i, 1), ("q", 2), ("Left", 4), ("Right", 5) ] icon
                    where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP
  { ppSep =""
  , ppWsSep = ""
  , ppCurrent = xmobarColor cyan "" . clickable wsIconFull
  , ppVisible = xmobarColor grey4 "" . clickable wsIconFull
  , ppVisibleNoWindows = Just (xmobarColor grey4 "" . clickable wsIconFull)
  , ppHidden = xmobarColor grey2 "" . clickable wsIconHidden
  , ppHiddenNoWindows = xmobarColor grey2 "" . clickable wsIconEmpty
  , ppUrgent = xmobarColor orange "" . clickable wsIconFull
  , ppTitle = xmobarColor "#B4BCCD" "" . shorten 20
  , ppOrder = \(ws:_:_:_) -> [ws]
  }
  where
    wsIconFull   = "  <fn=1>\xf111</fn>   "
    wsIconHidden = "  <fn=1>\xf111</fn>   "
    wsIconEmpty  = "  <fn=1>\xf10c</fn>   "

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
