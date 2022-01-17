{ config, lib, pkgs, ... }:
let wrapXmonad = old: pkgs.runCommand "xmonad-wrapper"
  {
    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.gnused
    ];
  } ''
  makeWrapper ${old} $out --prefix PATH : ${lib.makeBinPath [
    pkgs.brightnessctl
    pkgs.coreutils
    pkgs.playerctl
    pkgs.kbdlight
    pkgs.alsaUtils
  ]}
  sed -i '$s/$/ >\$HOME\/.xmonad.log 2>\$HOME\/.xmonad-errors.log/' $out
'';
in
{
  options = {
    # wrap the xmonad binary with some extra PATH
    xsession.windowManager.command = lib.mkOption {
      apply = wrapXmonad;
    };
  };
  config = lib.mkIf config.considerate.desktop {
    gtk.enable = true;
    home.packages = [ pkgs.xmobar ];
    xsession = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        config = ./xmonad.hs;
        enableContribAndExtras = true;
        extraPackages = hpkgs: with hpkgs; [
          (xmobar.overrideAttrs
            (old: {
              configureFlags = (old.configureFlags or [ ]) ++ [ "-fwith_xpm" ];
            }))
        ];
      };
      pointerCursor = {
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors";
        defaultCursor = "left_ptr";
        size = 48;
      };
    };
    home.file = {
      ".xmonad/xmonad-${pkgs.stdenv.hostPlatform.system}" = {
        source = lib.mkForce config.xsession.windowManager.command;
      };
      xmobar-icons = {
        source = ./xmobar-icons;
        target = ".xmonad/icons";
      };
      xmobarrc = {
        source = ./xmobarrc;
        target = ".xmobarrc";
      };
    };
  };
}
