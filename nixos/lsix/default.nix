{ pkgs, ... }:
let
  lsix-src = builtins.fetchGit {
    url = "https://github.com/hackerb9/lsix.git";
    rev = "f218619d247163f3891dca0ff3b81fa539f5d047";
    ref = "master";
  };
  lsix = pkgs.runCommand "lsix" { } ''
    cp ${lsix-src}/lsix .
    patchShebangs lsix
    mkdir -p $out/bin
    cp lsix $out/bin/lsix
    chmod +x $out/bin/lsix
  '';
in
{
  environment.systemPackages = [
    lsix
  ];
}
