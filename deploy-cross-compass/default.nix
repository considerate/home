{ pkgs, config, lib, ... }:
let
  cfg = config.deploy-cross-compass;
  deploy-cross-compass = pkgs.writeShellScriptBin "deploy-cross-compass" ''
    function finish {
      ssh-agent -k
    }
    trap finish EXIT
    eval $(ssh-agent)
    ssh-add ${toString cfg.keyPath}
    command=''${1:-switch}
    branch=''${2:-master}
    shift 2
    machines=(${lib.concatStringsSep " " cfg.machines})
    if [ "$#" -gt 0 ]; then
      machines=()
      machines=$@
    fi
    echo "deploying branch $branch with nixos-rebuild $command on ''${machines[@]}"
    pids=()
    for machine in ''${machines[@]}; do
      ssh -A "$machine" "cd /etc/nixos/cross-compass-nixos && git fetch origin $branch && git checkout -f $branch && git reset --hard origin/$branch && sudo nixos-rebuild $command --flake ." | sed "s/^/$machine> /" &
      pids+=($!)
    done
    for pid in ''${pids[@]}; do
      wait $pid
    done
  '';
in
{
  options.deploy-cross-compass.keyPath = lib.mkOption {
    type = lib.types.str;
    default = "~/.ssh/github";
  };
  options.deploy-cross-compass.machines = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "jarjar.xc"
      "maker.xc"
      "chewbacca.xc"
      "anakin.xc"
      "pichanaki.xc"
      "bobafett.xc"
    ];
  };
  config = {
    home.packages = [ deploy-cross-compass ];
  };
}
