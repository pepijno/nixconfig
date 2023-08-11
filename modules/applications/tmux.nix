{ config, pkgs, ... }:

let
  colors = import ../colors.nix {};
in
{
  home.packages = with pkgs; [
    tmux-mem-cpu-load
  ];
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;
    shortcut = "a";
    terminal = "xterm-256color";

    extraConfig = ''
      # reload source file with '<C-a>r'
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display 'Reloaded tmux config.'

      # enable mouse support
      set -g mouse on

      set-option -g default-terminal "xterm-256color"

      # Keep your finger on ctrl, or don't, same result
      bind-key C-d detach-client
      bind-key C-p paste-buffer

      # Redraw the client (if interrupted by wall, etc)
      bind R refresh-client

      # Ctrl - w or w to kill panes
      unbind w
      unbind C-w
      bind-key w kill-pane
      bind-key C-w kill-pane

      # C + control q to kill session
      unbind q
      unbind C-q
      bind-key q kill-session
      bind-key C-q kill-session

      # enable utf8 status line
      # set -g status-utf8 on

      # status line
      set -g status-style bg='${colors.background}',fg='${colors.foreground}'
      set -g status-interval 1
      set-option -g status-position bottom

      # status left
      # are we controlling tmux or the content of the panes?
      set -g status-left "#[bg=${colors.aqua}]#[fg=${colors.background}]#{?client_prefix,#[bg=${colors.bright_purple}],} ☺ #[bg=${colors.background}]#[fg=${colors.aqua}]#{?client_prefix,#[fg=${colors.bright_purple}],}"

      set -g status-left-length 4
      set -g status-right-length 250

      set-window-option -g visual-bell on
      set-window-option -g bell-action other

      # window status
      set -g status-justify left
      set-window-option -g window-status-style fg='#ecbe7b',bg=default
      set-window-option -g window-status-current-style fg='#ff79c6',bg='#2b2e36'
      set -g window-status-current-format "#[fg=${colors.background}]#[bg=${colors.purple}]#[fg=${colors.background}]#[bg=${colors.purple}] #I #W #[fg=${colors.purple}]#[bg=${colors.background}]"
      set -g window-status-format "#[fg=${colors.foreground}]#[bg=${colors.background}] #I #W#[fg=${colors.background}]"
      set-window-option -g window-status-activity-style fg='#2b2e37',bg='#51afef'

      # status right
      set -g status-right '#[fg='${colors.red}',bg='${colors.background}']#[fg='${colors.background}',bg='${colors.red}'] #(tmux-mem-cpu-load -g 5 --interval 1) '
      set -ga status-right '#[fg='${colors.background}',bg='${colors.red}']'
      set -ga status-right '#[fg='${colors.green}',bg='${colors.background}']#[fg='${colors.background}',bg='${colors.green}'] #(uptime | cut -f 4-5 -d " " | cut -f 1 -d ",") '
      set -ga status-right '#[fg='${colors.background}',bg='${colors.green}']'
      set -ga status-right '#[fg='${colors.blue}',bg='${colors.background}']#[fg='${colors.background}',bg='${colors.blue}'] %a %H:%M:%S %d-%m-%Y '

      set-option -sg escape-time 10
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
    '';
  };
}
