inputs: {
  audio = import ./audio;
  battery = import ./battery;
  bluetooth = import ./bluetooth;
  boot = import ./boot;
  borg = import ./borg;
  docker = import ./docker;
  git-user = import ./git-user;
  i18n = import ./i18n;
  display-manager = import ./display-manager;
  locate = import ./locate;
  openvpn = import ./openvpn;
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
  hyprland = import ./hyprland;
  tabby = import ./tabby;
  default = {
    networking.firewall.allowedTCPPorts = [ 8000 ];
    imports = [
      inputs.self.nixosModules.audio
      inputs.self.nixosModules.battery
      inputs.self.nixosModules.bluetooth
      inputs.self.nixosModules.boot
      inputs.self.nixosModules.git-user
      inputs.self.nixosModules.i18n
      inputs.self.nixosModules.locate
      inputs.self.nixosModules.network
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.packages
      inputs.self.nixosModules.passwords
      inputs.self.nixosModules.powerline
      inputs.self.nixosModules.redshift
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.tex
      inputs.self.nixosModules.trackpad
      inputs.self.nixosModules.hyprland
      inputs.self.nixosModules.display-manager
    ];
  };
}
