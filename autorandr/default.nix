{ pkgs, lib, ... }:
{
  systemd.user.services.autorandr = {
    Unit.After = [ "sleep.target" ];
    Unit.StartLimitInterval = 5;
    Unit.StartLimitBurst = 1;
    Service = {
      ExecStart = "${pkgs.autorandr}/bin/autorandr --change --default laptop";
      Type = "oneshot";
      RemainAfterExit = false;
      KillMode = "process";
    };
    Install.WantedBy = [ "sleep.target" ];
  };
  programs.autorandr = {
    enable = true;
    profiles = {
      laptop = {
        fingerprint = {
          eDP-1 = lib.concatStrings [
            "00ffffffffffff0006af2b2800000000"
            "001c0104a51d117802ee95a3544c9926"
            "0f505400000001010101010101010101"
            "01010101010152d000a0f0703e803020"
            "350025a51000001a0000000000000000"
            "00000000000000000000000000fe0039"
            "304e544880423133335a414e00000000"
            "00024103a8011100000b010a20200006"
          ];
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "60.00";
          };
        };
        hooks.postswitch = ''
          ${pkgs.haskellPackages.xmonad}/bin/xmonad --restart
        '';
      };
      work = {
        fingerprint = {
          eDP-1 = lib.concatStrings [
            "00ffffffffffff0006af2b2800000000"
            "001c0104a51d117802ee95a3544c9926"
            "0f505400000001010101010101010101"
            "01010101010152d000a0f0703e803020"
            "350025a51000001a0000000000000000"
            "00000000000000000000000000fe0039"
            "304e544880423133335a414e00000000"
            "00024103a8011100000b010a20200006"
          ];
          DP-2 = lib.concatStrings [
            "00ffffffffffff00410c270974020000"
            "101d0104a54627783a5905af4f42af27"
            "0e5054bfef00d1c0b300950081808140"
            "81c001010101a36600a0f0701f803020"
            "3500ba892100001a000000ff00415535"
            "31393136303030363238000000fc0050"
            "484c20333238503656550a20000000fd"
            "0017501ea01e000a20202020202001f0"
            "020329f14e0103051404131f12021190"
            "5d5e5f23090707830100006d030c0020"
            "001878200060010203023a801871382d"
            "40582c4500ba892100001e4d6c80a070"
            "703e8030203a00ba892100001a000000"
            "00000000000000000000000000000000"
            "00000000000000000000000000000000"
            "0000000000000000000000000000004d"
          ];
        };
        config = {
          eDP-1 = {
            enable = true;
            #crtc = 0;
            primary = false;
            position = "0x0";
            mode = "3840x2160";
            #gamma = "1.0:0.909:0.833";
            rate = "60.00";
            #rotate = "left";
          };
          DP-2 = {
            enable = true;
            #crtc = 0;
            primary = true;
            position = "3840x0";
            mode = "3840x2160";
            #gamma = "1.0:0.909:0.833";
            rate = "30.00";
            #rotate = "left";
          };
        };
        hooks.postswitch = ''
          ${pkgs.haskellPackages.xmonad}/bin/xmonad --restart
        '';
      };
    };
  };
}
