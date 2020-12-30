{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
    };
  };
  vimrc = import ./vimrc.nix { pkgs = pkgs; };
in {
  fonts.fontconfig.enable = true;

  systemd.user.services.backup = {
    Unit = {
      Description = "Run backup script";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "/home/pepijn/bin/create_backup /home/pepijn/ /backups";
      Environment = "PATH=/run/wrappers/bin:/home/pepijn/.nix-profile/bin:/etc/profiles/per-user/pepijn/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
    };
  };

  systemd.user.timers.backup = {
    Unit = {
      Description = "Run backup every day";
    };

    Timer = {
      OnCalendar = "*-*-* 06:00:00";
      OnBootSec = "900";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.packages = [
    pkgs.fontconfig
    pkgs.killall
    pkgs.unzip
    pkgs.dunst
    pkgs.pywal
    pkgs.solaar
    pkgs.redshift
    pkgs.fzf
    # these are manually installed because the latest versions are bugged
    # (pkgs.nerdfonts.override { fonts = [ "Iosevka" "DroidSansMono" ]; })
    pkgs.fantasque-sans-mono
    pkgs.tor-browser-bundle-bin
    pkgs.hermit
    pkgs.source-code-pro
    pkgs.material-design-icons
    pkgs.noto-fonts
    pkgs.ranger
    pkgs.rsync
    pkgs.imagemagick
    pkgs.ctags
    pkgs.libnotify
    pkgs.nix-du

    unstable.electrum

    unstable.steam
    unstable.discord

    unstable.vivaldi
    unstable.vivaldi-widevine
    unstable.vivaldi-ffmpeg-codecs
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.rofi.enable = true;
  programs.fish = {
    enable = true;

    functions = {
      fish_prompt = "test \"$USER\" = 'root'
      and echo (set_color red)\"#\"

      echo -n (set_color cyan)(prompt_pwd) (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '";
    };

    shellInit = ''
      set --export EDITOR "nvim -f"
      set -U fish_greeting
    '';
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
    };
    config = ./polybar/config.ini;
    script = "~/.config/polybar/launch.sh";
  };

  programs.urxvt = {
    enable = true;

    fonts = [ "xft:DejaVu Sans Mono:pixelsize=15" ];

    transparent = false;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      lightline-vim
      vim-abolish
      vim-commentary
      vim-easymotion
      tagbar
      fzf-vim
      vim-startify
      vim-gutentags
      gruvbox
      wal-vim
      vim-devicons
      vim-gitgutter
      haskell-vim
    ];
    extraConfig = vimrc.config;
  };

  programs.git = {
    enable = true;
    userName = "Pepijn Overbeeke";
    userEmail = "pepijn.overbeeke@gmail.com";
    aliases = {
      st = "status";
      a = "add -p";
      ci = "commit";
      co = "checkout";
      lola = "log --graph --decorate --pretty=online --abbrev-commit --all --date-order";
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";

  home.file.".config/i3/config".source = ./i3/config;
  home.file.".Xresources".source = ./Xresources;
  home.file.".config/polybar/launch.sh".source = ./polybar/launch.sh;
  home.file.".config/polybar/scripts".source = ./polybar/scripts;
  home.file.".config/polybar/fonts".source = ./polybar/fonts;
  home.file.".config/dunst".source = ./dunst;
  home.file."bin".source = ./bin;

  nixpkgs.config.allowUnfree = true;
  # home.file.".config/nixpkgs/config.nix".text = ''
  #   { allowUnfree = true; }
  # '';

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
