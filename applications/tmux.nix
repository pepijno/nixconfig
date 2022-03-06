{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;
    shortcut = "a";
    terminal = "screen-256color";

    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display 'Reloaded tmux config.'

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      set -g mouse on

      # Keep your finger on ctrl, or don't, same result
      bind-key C-d detach-client
      bind-key C-p paste-buffer

      # Redraw the client (if interrupted by wall, etc)
      bind R refresh-client

      unbind v
      unbind C-v
      bind-key v split-window -h
      bind-key C-v split-window -h

      unbind h
      unbind C-h
      bind-key h split-window
      bind-key C-h split-window

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

      set-option -g status on
      set-option -g status-interval 1
      set-option -g status-justify centre
      set-option -g status-keys vi
      set-option -g status-position bottom
      set-option -g status-left-length 20
      set-option -g status-left-style default
      set-option -g status-left "#H • #(uname -r)"
      set-option -g status-right-length 140
      set-option -g status-right-style default
      set-option -g status-right "#(tmux-mem-cpu-load) "
      set-option -ag status-right "#(uptime | cut -f 7-7 -d ' ' | cut -f 1-1 -d ',') "
      set-option -ag status-right " %H:%M:%S %Y-%m-%d"
      set -sa terminal-overrides ",xterm-256color:RGB"
      set -ga terminal-overrides ",xterm-256color:Tc"

      set-option -sg escape-time 10
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
    '';
  };
}
