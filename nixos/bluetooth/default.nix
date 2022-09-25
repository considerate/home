{ pkgs, ... }:
{
  services.blueman.enable = false;
  hardware.bluetooth = {
    enable = true;
  };
  environment.systemPackages = [
    pkgs.blueberry
    (pkgs.writeShellScriptBin "bluetooth-connected-devices"
      ''
        prefix=""
        bluetoothctl paired-devices | cut -f2 -d' '|
        while read -r uuid; do
          info=`bluetoothctl info $uuid`;
          if echo "$info" | grep -q "Connected: yes"; then
            device=$(echo "$info" | grep -oP "Alias: \K.*");
            echo -n "$prefix$device"
            prefix=" "
          fi;
        done
      '')
  ];
}
