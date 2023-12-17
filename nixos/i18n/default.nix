{ pkgs, ... }:

{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_CTYPE = "en_US.UTF-8"; };
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = [ pkgs.fcitx5-mozc pkgs.fcitx5-gtk ];
    };
  };
}
