{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ zellij ];
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      pane_frames = false;
      theme = "catppuccin-latte";
      "keybinds clear-defaults=true" = {
        "shared_except \"normal\" \"locked\"" = {
          "bind \"Enter\" \"Esc\"" = {
            SwitchToMode = "Normal";
          };
        };
        "shared_except \"tab\" \"locked\"" = {
          "bind \"Ctrl a\"" = {
            SwitchToMode = "Tab";
          };
        };
        "tab" = {
          "bind \"c\"" = {
            NewTab = [];
            SwitchToMode = "Normal";
          };
          "bind \"Ctrl a\"" = {
            ToggleTab = [];
            SwitchToMode = "Normal";
          };
          "bind \"1\"" = {
            GoToTab = 1;
            SwitchToMode = "Normal";
          };
          "bind \"2\"" = {
            GoToTab = 2;
            SwitchToMode = "Normal";
          };
          "bind \"3\"" = {
            GoToTab = 3;
            SwitchToMode = "Normal";
          };
          "bind \"4\"" = {
            GoToTab = 4;
            SwitchToMode = "Normal";
          };
          "bind \"5\"" = {
            GoToTab = 5;
            SwitchToMode = "Normal";
          };
          "bind \"6\"" = {
            GoToTab = 6;
            SwitchToMode = "Normal";
          };
          "bind \"7\"" = {
            GoToTab = 7;
            SwitchToMode = "Normal";
          };
          "bind \"8\"" = {
            GoToTab = 8;
            SwitchToMode = "Normal";
          };
          "bind \"9\"" = {
            GoToTab = 9;
            SwitchToMode = "Normal";
          };
          "bind \"0\"" = {
            GoToTab = 0;
            SwitchToMode = "Normal";
          };
        };
      };
      layout = {
        "pane size=1 borderless=true" = {
          "plugin location" = "zellij:compact-bar";
        };
      };
    };
  };
}
