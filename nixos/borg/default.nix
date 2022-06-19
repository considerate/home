{
  services.borgbackup.jobs.home-considerate = {
    paths = "/home/considerate";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/considerate/.ssh/nas";
    repo = "ssh://considerate@192.168.11.5/mnt/storage/backup/considerate";
    compression = "auto,zstd";
    startAt = "daily";
  };
}
