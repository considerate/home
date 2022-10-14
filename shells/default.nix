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
        set -g -x COLORTERM truecolor
      '';
    };
    fish = {
      enable = true;
    };
  };
}
