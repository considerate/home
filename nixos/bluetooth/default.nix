{ pkgs, ... }:
{
  services.blueman.enable = false;
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;
  };
  environment.systemPackages = [
    pkgs.blueberry
    (pkgs.writeShellScriptBin "bluetooth-connected-devices"
      ''
        bluetoothctl paired-devices | cut -f2 -d' '|
        while read -r uuid; do
          info=`bluetoothctl info $uuid`;
          if echo "$info" | grep -q "Connected: yes"; then
            echo "$info" | grep -oP "Name: \K\w+";
          fi;
        done
      '')
  ];
}
