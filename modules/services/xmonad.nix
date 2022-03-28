{ config, pkgs, libs, ... }:

let
  restart-dunst = pkgs.callPackage ./scripts/restart-dunst.nix { config = config; };
  menu = pkgs.callPackage ./scripts/menu.nix { config = config; };
  sysmenu = pkgs.callPackage ./scripts/sysmenu.nix { config = config; };
in
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env sh

    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
            eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    systemctl --user import-environment DISPLAY XAUTHORITY

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
            dbus-update-activation-environment DISPLAY XAUTHORITY
    fi
    exec ${pkgs.haskellPackages.xmonad}/bin/xmonad
  '';

  home.file.".xserverrc".text = ''
    #!/usr/bin/env sh
    exec /run/current-system/sw/bin/Xorg -nolisten tcp -nolisten local "$@" "vt""$XDG_VTNR"
  '';

  programs.xmobar = {
    enable = true;
    extraConfig = ''
      Config { font = "xft:Liberation Mono:size=9:medium:antialias=true"
         , bgColor = "#002b36" --"#1d1f21" --"#1c1c1c"
         , fgColor = "#657b83"
         , position = Top
         --, position = TopSize C 100 35 -- use this if only using one monitor
         --, position = Static { xpos = 0 , ypos = 0, width = 1920, height = 24 } --manually position bar to display on left monitor 
         , lowerOnStart = False
         , allDesktops = True
         , overrideRedirect = False
         , border = BottomBM 0
         , borderColor = "#b58900"
         , commands = [ Run Cpu
                            ["-L","3","-H","50","--normal","#657b83","--high","#dc322f"] 10 
                             
                                  
          -- cpu core temperature monitor
          , Run CoreTemp       [ "--template" , "± <core0>°±<core1>°"
                               , "--Low"      , "70"        -- units: °C
                               , "--High"     , "80"        -- units: °C
                               , "--low"      , "#657b83"
                               , "--normal"   , "#859900"
                               , "--high"     , "#dc322f"
                               ] 50
            , Run Network "enp3s0" ["-S", "True", "-t", "eth: <fc=#4eb4fa><rx></fc>/<fc=#4eb4fa><tx></fc>"] 10
            , Run Memory ["-t","mem: <fc=#4eb4fa><usedbar> <usedratio>%</fc>"] 10
            , Run Date "date: <fc=#4eb4fa>%a %d %b %Y %H:%M:%S </fc>" "date" 10
            , Run StdinReader
                      ]
         , sepChar = "%"
         , alignSep = "}{"
         , template = " %StdinReader% }{ <fc=#6c71c4>%cpu%</fc> | <fc=#cb4b16>%coretemp%</fc>k | %network% | %memory% | %date%"
         }
    '';
  };

  home.packages = with pkgs; [
    xorg.xmessage
  ];

  xsession = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad-contrib
      ];
      config = pkgs.writeText "xmonad.hs" ''
        import Data.Monoid
        import Graphics.X11.ExtraTypes.XF86
        import System.Exit
        import XMonad
        import XMonad.Hooks.DynamicLog
        import XMonad.Hooks.EwmhDesktops
        import XMonad.Hooks.ManageDocks
        import XMonad.Layout.Gaps
        import XMonad.Layout.Spacing
        import XMonad.Util.Run
        import XMonad.Util.SpawnOnce

        import qualified Codec.Binary.UTF8.String              as UTF8
        import qualified DBus                                  as D
        import qualified DBus.Client                           as D
        import           XMonad.Hooks.DynamicLog

        import qualified XMonad.StackSet as W
        import qualified Data.Map        as M

        myTerminal = "${pkgs.alacritty}/bin/alacritty"

        myFocusFollowsMouse :: Bool
        myFocusFollowsMouse = True

        myClickJustFocuses :: Bool
        myClickJustFocuses = False

        myBorderWidth = 0

        myModMask = mod1Mask

        myWorkspaces    = ["1","2","3","4","5"]

        myNormalBorderColor  = "#dddddd"
        myFocusedBorderColor = "#ff0000"

        myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
            [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
            , ((modm,               xK_d     ), spawn "${menu}/bin/menu")
            , ((modm .|. shiftMask, xK_e     ), spawn "${sysmenu}/bin/sysmenu")
            , ((modm .|. shiftMask, xK_q     ), kill)
            , ((modm,               xK_space ), sendMessage NextLayout)
            , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
            , ((modm,               xK_n     ), refresh)
            , ((modm,               xK_Tab   ), windows W.focusDown)
            , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp)
            , ((modm,               xK_j     ), windows W.focusDown)
            , ((modm,               xK_k     ), windows W.focusUp  )
            , ((modm,               xK_m     ), windows W.focusMaster  )
            , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
            , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
            , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
            , ((modm,               xK_h     ), sendMessage Shrink)
            , ((modm,               xK_l     ), sendMessage Expand)
            , ((modm,               xK_t     ), withFocused $ windows . W.sink)
            , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
            , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
            -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
            , ((modm .|. shiftMask, xK_c     ), io (exitWith ExitSuccess))
            , ((modm              , xK_r     ), spawn "xmonad --restart")
            , ((modm .|. shiftMask, xK_h     ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
            ]
            ++
            [((m .|. modm, k), windows $ f i)
                | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
                , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
            ++
            [ ((modm .|. shiftMask, xK_b), spawn "${pkgs.vivaldi}/bin/vivaldi")
            , ((modm .|. shiftMask, xK_f), spawn "${pkgs.firefox}/bin/firefox")
            , ((modm .|. shiftMask, xK_o), spawn "${pkgs.tor-browser-bundle-bin}/bin/tor-browser")
            , ((modm .|. shiftMask, xK_s), spawn "${pkgs.steam}/bin/steam")
            ]
            ++
            [ ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
            , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
            , ((0, xF86XK_AudioMute), spawn "pactl set-sink-volume @DEFAULT_SINK@ toggle")
            , ((0, xF86XK_AudioPlay), spawn "${pkgs.playerctl}/bin/playerctl play")
            , ((0, xF86XK_AudioPause), spawn "${pkgs.playerctl}/bin/playerctl pause")
            , ((0, xF86XK_AudioNext), spawn "${pkgs.playerctl}/bin/playerctl next")
            , ((0, xF86XK_AudioPrev), spawn "${pkgs.playerctl}/bin/playerctl previous")
            ]

        myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
            [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                               >> windows W.shiftMaster))
            , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
            , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                               >> windows W.shiftMaster))
            ]

        --myLayout = avoidStruts (spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True $ (gaps [(U,10), (D,10), (R,10), (L,10)] $ tiled ||| Full))
        myLayout = avoidStruts (spacing 10 $ tiled ||| Full)
          where
             tiled   = Tall nmaster delta ratio
             nmaster = 1
             ratio   = 1/2
             delta   = 3/100

        myManageHook = composeAll []

        myEventHook = mempty

        myLogHook = return ()

        myStartupHook = do
          spawnOnce "${pkgs.pywal}/bin/wal -R"
          spawnOnce "${pkgs.solaar}/bin/solaar"
          spawnOnce "/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1"
          spawnOnce  "systemctl --user start dunst.service"
          spawnOnce "systemctl --user restart redshift.service"
          spawn "${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1080"
          spawn "${restart-dunst}/bin/restart-dunst"
          spawn "${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/Pictures/Wallpapers/"
          spawn "systemctl --user restart picom.service"

        defaults dbus = def {
              -- simple stuff
                terminal           = myTerminal,
                focusFollowsMouse  = myFocusFollowsMouse,
                clickJustFocuses   = myClickJustFocuses,
                borderWidth        = myBorderWidth,
                modMask            = myModMask,
                workspaces         = myWorkspaces,
                normalBorderColor  = myNormalBorderColor,
                focusedBorderColor = myFocusedBorderColor,

              -- key bindings
                keys               = myKeys,
                mouseBindings      = myMouseBindings,

              -- hooks, layouts
                layoutHook         = myLayout,
                manageHook         = myManageHook,
                handleEventHook    = myEventHook,
                logHook            = myPolybarLogHook dbus,
                startupHook        = myStartupHook
            }

        help :: String
        help = unlines ["The default modifier key is 'alt'. Default keybindings:",
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
            "mod-Shift-s Steam"]

        main' dbus = do
          xmonad $ docks $ ewmh $ defaults dbus

        main = mkDbusClient >>= main'

        myBar = "xmobar"

        myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

        toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

        ------------------------------------------------------------------------
        -- Polybar settings (needs DBus client).
        --
        mkDbusClient :: IO D.Client
        mkDbusClient = do
          dbus <- D.connectSession
          D.requestName dbus (D.busName_ "org.xmonad.log") opts
          return dbus
         where
          opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

        -- Emit a DBus signal on log updates
        dbusOutput :: D.Client -> String -> IO ()
        dbusOutput dbus str =
          let opath  = D.objectPath_ "/org/xmonad/Log"
              iname  = D.interfaceName_ "org.xmonad.Log"
              mname  = D.memberName_ "Update"
              signal = D.signal opath iname mname
              body   = [D.toVariant $ UTF8.decodeString str]
          in  D.emit dbus $ signal { D.signalBody = body }

        polybarHook :: D.Client -> PP
        polybarHook dbus =
          let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                          | otherwise  = mempty
              blue   = "#2E9AFE"
              gray   = "#7F7F7F"
              orange = "#ea4300"
              purple = "#9058c7"
              red    = "#722222"
          in  def { ppOutput          = dbusOutput dbus
                  , ppCurrent         = wrapper blue
                  , ppVisible         = wrapper gray
                  , ppUrgent          = wrapper orange
                  , ppHidden          = wrapper gray
                  , ppHiddenNoWindows = wrapper red
                  , ppTitle           = wrapper purple . shorten 90
                  }

        myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)
      '';
    };
  };
}
