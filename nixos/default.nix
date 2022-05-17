inputs: {
  audio = import ./audio;
  battery = import ./battery;
  bluetooth = import ./bluetooth;
  boot = import ./boot;
  docker = import ./docker;
  git-user = import ./git-user;
  i18n = import ./i18n;
  lightdm = import ./lightdm;
  locate = import ./locate;
  lsix = import ./lsix;
  mullvad-openvpn = import ./mullvad-openvpn;
  network = import ./network;
  nix = import ./nix;
  packages = import ./packages;
  passwords = import ./passwords;
  powerline = import ./powerline;
  redshift = import ./redshift;
  ssh = import ./ssh;
  tex = import ./tex;
  trackpad = import ./trackpad;
  virtualbox = import ./virtualbox;
  xserver = import ./xserver;
  default = {
    imports = [
      inputs.self.nixosModules.audio
      inputs.self.nixosModules.battery
      inputs.self.nixosModules.bluetooth
      inputs.self.nixosModules.boot
      inputs.self.nixosModules.docker
      inputs.self.nixosModules.git-user
      inputs.self.nixosModules.i18n
      inputs.self.nixosModules.locate
      inputs.self.nixosModules.lsix
      inputs.self.nixosModules.mullvad-openvpn
      inputs.self.nixosModules.network
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.packages
      inputs.self.nixosModules.passwords
      inputs.self.nixosModules.powerline
      inputs.self.nixosModules.redshift
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.tex
      inputs.self.nixosModules.trackpad
      inputs.self.nixosModules.virtualbox
      inputs.self.nixosModules.xserver
    ];
  };
}
