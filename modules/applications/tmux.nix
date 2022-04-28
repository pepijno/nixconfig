{ config, pkgs, ... }:

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
    terminal = "screen-256color-bce";

    extraConfig = ''
      # reload source file with '<C-a>r'
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display 'Reloaded tmux config.'

      # enable mouse support
      set -g mouse on

      set-option -g default-terminal "screen-256color-bce"

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
      set -g status-utf8 on

      # status line
      set -g status-style bg='#2b2e37',fg='#ecbe7b'
      set -g status-interval 1
      set-option -g status-position bottom

      # status left
      # are we controlling tmux or the content of the panes?
      set -g status-left "#[bg=#b4bccd]#[fg=#2b2e37]#{?client_prefix,#[bg=#c678dd],} ☺ #[bg=#2b2e37]#[fg=#b4bccd]#{?client_prefix,#[fg=#c678dd],}"

      set -g status-left-length 4
      set -g status-right-length 250

      # window status
      set -g status-justify left
      set-window-option -g window-status-style fg='#ecbe7b',bg=default
      set-window-option -g window-status-current-style fg='#ff79c6',bg='#2b2e36'
      set -g window-status-current-format "#[fg=#2b2e37]#[bg=#ecbe7b]#[fg=#2b2e37]#[bg=#ecbe7b] #I #W #[fg=#ecbe7b]#[bg=#2b2e37]"
      set -g window-status-format "#[fg=#f8f8f2]#[bg=#2b2e37] #I #W#[fg=#2b2e37]"
      set-window-option -g window-status-activity-style fg='#2b2e37',bg='#51afef'

      # status right
      set -g status-right '#[fg=#ff6c6b,bg=#2b2e37]#[fg=#2b2e37,bg=#ff6c6b] #(tmux-mem-cpu-load -g 5 --interval 1) '
      set -ga status-right '#[fg=#2b2e37,bg=#ff6c6b]'
      set -ga status-right '#[fg=#98be65,bg=#2b2e37]#[fg=#2b2e37,bg=#98be65] #(uptime | cut -f 4-5 -d " " | cut -f 1 -d ",") '
      set -ga status-right '#[fg=#2b2e37,bg=#98be65]'
      set -ga status-right '#[fg=#51afef,bg=#2b2e37]#[fg=#2b2e37,bg=#51afef] %a %H:%M:%S %d-%m-%Y '

      set-option -sg escape-time 10
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
    '';
  };
}
