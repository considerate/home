{ pkgs, ... }:
let
  firefox = pkgs.firefox.override {
    cfg = {
      enableBrowserpass = true;
    };
    extraNativeMessagingHosts = [ pkgs.passff-host ];
  };

  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/default.nix
  buildFirefoxXpiAddon = { pname, version, addonId, url, sha256, meta, ... }:
    pkgs.stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = pkgs.fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = false;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };
in
{
  programs.firefox = {
    enable = true;
    package = firefox;
    extensions = [
      (buildFirefoxXpiAddon {
        pname = "passff";
        version = "1.10.5";
        addonId = "passff@invicem.pro";
        url = "https://addons.mozilla.org/firefox/downloads/file/3697309/passff-1.10.5-fx.xpi";
        sha256 = "0vbbzv7i9039qpiwp4kis90m3r6ws96sbaqnkw0qaq8d0jlbjxl0";
        meta = { };
      })
    ];
    profiles = {
      considerate = {
        id = 0;
        settings = {
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;
          "media.av1.enabled" = false;
          "gfx.webrender.all" = true;
        };
      };
    };
  };
}
