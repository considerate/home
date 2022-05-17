{
  imports = [ ./batteryNotifier.nix ];
  services.tlp = {
    enable = false;
    extraConfig = ''
      USB_BLACKLIST_PHONE=1
    '';
  };
  services.batteryNotifier = {
    enable = true;
  };
  services.upower = {
    enable = true;
  };
}
