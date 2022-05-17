{ pkgs, ... }:
let pass =
  pkgs.pass.withExtensions (exts: [
    exts.pass-otp
  ]);
in
{
  environment.systemPackages = [
    pass
  ];
  programs = {
    browserpass = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
    };
  };
  services = {
    gnome.gnome-keyring = {
      enable = false;
    };
  };
}
