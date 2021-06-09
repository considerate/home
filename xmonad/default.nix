{ config, lib, pkgs, ... }: {
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
      size = 64;
    };
  };
  home.file.${config.xsession.scriptPath}.text = lib.mkAfter ''
    autorandr -c
  '';
  home.file = {
    xmobar-icons = {
      source = ./xmobar-icons;
      target = ".xmonad/icons";
    };
    xmobarrc = {
      source = ./xmobarrc;
      target = ".xmobarrc";
    };
  };
}
