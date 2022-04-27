{ keyPath ? null, machines, writeShellScriptBin, lib }:
writeShellScriptBin "deploy-cross-compass" ''
  function finish {
    ssh-agent -k
  }
  trap finish EXIT
  eval $(ssh-agent)
  key="${if keyPath != null then toString keyPath else "$DEPLOY_SSH_KEY"}"
  declare -a machines=()
  while [ -n "$1" ]; do
    case "$1" in
      --command)
        shift
        command="$1"
        shift
      ;;
      --key)
        shift
        key="$1"
        shift
      ;;
      --branch)
        shift
        branch="$1"
        shift
      ;;
      --user)
        shift
        user="$1@"
        shift
      ;;
      *)
        machines+=("$1")
        shift
      ;;
    esac
  done
  if [ -f "$key" ]; then
    ssh-add "$key"
  fi
  if [ -z "$user" ]; then
    if [ -n "$DEPLOY_USER" ]; then
      echo "setting to deploy user"
      user="''${DEPLOY_USER}@"
    fi
  fi
  echo "Deploying as user: $user"
  command=''${command:-switch}
  branch=''${branch:-master}
  shift 2
  if [ "''${#machines[@]}" -eq 0 ]; then
    machines=(${lib.concatStringsSep " " machines})
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
