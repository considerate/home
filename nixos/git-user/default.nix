{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
  ];
  users = {
    users = {
      git = {
        group = "git";
        shell = "${pkgs.git}/bin/git-shell";
        home = "/var/git";
        isSystemUser = true;
        createHome = true;
      };
    };
    groups.git = { };
  };
}
