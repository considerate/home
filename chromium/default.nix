{ pkgs, config, ... }:
let
  home-chromium = pkgs.writeShellScriptBin "home-chromium" ''
    chromium --profile-directory="Profile 1"
  '';
  work-chromium = pkgs.writeShellScriptBin "work-chromium" ''
    chromium --profile-directory="Default"
  '';
in
{
  home.packages = [ home-chromium work-chromium ];
}
