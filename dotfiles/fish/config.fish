# Only execute this file once per shell.
set -q __fish_config_sourced; and exit
set -g __fish_config_sourced 1

set --export EDITOR "nvim -f"
set -U fish_greeting
set FZF_DEFAULT_COMMAND "rg --files"
set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
    --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
    --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
    --color=selected-bg:#BCC0CC \
    --color=border:#CCD0DA,label:#4C4F69"

set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

oh-my-posh init fish --config $HOME/.config/ohmyposh.toml | source
direnv hook fish | source

begin
    set -l joined (string join " " $fish_complete_path)
    set -l prev_joined (string replace --regex "[^\s]*generated_completions.*" "" $joined)
    set -l post_joined (string replace $prev_joined "" $joined)
    set -l prev (string split " " (string trim $prev_joined))
    set -l post (string split " " (string trim $post_joined))
    set fish_complete_path $prev "~/.local/share/fish/home-manager_generated_completions" $post
end

if test -f "$XDG_CONFIG_HOME/extra.fish"
    source "$XDG_CONFIG_HOME/extra.fish"
end
