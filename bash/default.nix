{
  programs = {
    powerline-go = {
      enable = true;
      settings = {
        cwd-max-depth = 4;
        max-width = 90;
      };
      modules = [
        "venv"
        "ssh"
        "cwd"
        "perms"
        "git"
        "exit"
        "nix-shell"
        "jobs"
        "root"
      ];
    };
    bash = {
      enable = true;
      initExtra = ''
        alias nix-stray-roots='nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc|\{temp)"'
        alias nix-pin-shell='nix-instantiate shell.nix --indirect --add-root .nix-gc-roots/shell.drv'
        if [ "$IN_NIX_SHELL" == "pure" ]; then
          if [ -x "$HOME/.nix-profile/bin/powerline-go" ]; then
            alias powerline-go="$HOME/.nix-profile/bin/powerline-go"
          elif [ -x "/run/current-system/sw/bin/powerline-go" ]; then
            alias powerline-go="/run/current-system/sw/bin/powerline-go"
          fi
        fi
      '';
    };
  };
}
