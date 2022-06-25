let common-excludes = [
  # Largest cache dirs
  ".cache"
  "*/cache2" # firefox
  "*/Cache"
  "VirtualBox VMs"
  ".config/Slack/logs"
  ".config/Code/CachedData"
  ".container-diff"
  ".npm/_cacache"
  "*/node_modules"
  "*/bower_components"
  "*/_build"
  "*/venv"
  "*/.venv"
];
in
{
  services.borgbackup.jobs.home-considerate = {
    paths = "/home/considerate";
    exclude = common-excludes ++ [ "Downloads" ];
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/considerate/.ssh/nas";
    repo = "ssh://considerate@192.168.11.5/mnt/storage/backup/considerate";
    compression = "auto,zstd";
    startAt = "daily";
  };
}
