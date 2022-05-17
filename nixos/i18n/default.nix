{ pkgs, ... }:

{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_CTYPE = "en_US.UTF-8"; };
    inputMethod = {
      enabled = "ibus";
      ibus = { engines = with pkgs.ibus-engines; [ anthy ]; };
    };
  };
}
