{ pkgs, ... }:
{
  home.packages = [
    pkgs.tmate
  ];
  programs = {
    tmux = {
      enable = true;
      keyMode = "vi";
      extraConfig = ''
        # Enable mouse support
        set -g mouse on
        # Sane scrolling
        set -g terminal-overrides 'xterm*:smcup@:rmcup@'

        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi V send -X select-line
        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      '';
    };
  };
}
