{ keyPath ? null, machines, writeShellScriptBin, lib }:
writeShellScriptBin "deploy-cross-compass" ''
  function finish {
    ssh-agent -k
  }
  trap finish EXIT
  eval $(ssh-agent)
  key="${if keyPath != null then toString keyPath else "$DEPLOY_SSH_KEY"}"
  if [ -f "$key" ]; then
    ssh-add "$key"
  fi
  user=""
  if [ -z $DEPLOY_USER ]; then
    user="$DEPLOY_USER@"
  fi
  command=''${1:-switch}
  branch=''${2:-master}
  shift 2
  machines=(${lib.concatStringsSep " " machines})
  if [ "$#" -gt 0 ]; then
    machines=()
    machines=$@
  fi
  echo "deploying branch $branch with nixos-rebuild $command on ''${machines[@]}"
  pids=()
  for machine in ''${machines[@]}; do
    ssh -A "$user$machine" "cd /etc/nixos/cross-compass-nixos && git fetch origin $branch && git checkout -f $branch && git reset --hard origin/$branch && sudo nixos-rebuild $command --flake ." | sed "s/^/$machine> /" &
    pids+=($!)
  done
  for pid in ''${pids[@]}; do
    wait $pid
  done
''
