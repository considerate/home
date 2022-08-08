{ pkgs, config, ... }:
let
  base-config = ''
    client
    dev tun
    resolv-retry infinite
    nobind
    persist-key
    persist-tun
    verb 3
    remote-cert-tls server
    ping 10
    ping-restart 60
    sndbuf 524288
    rcvbuf 524288
    cipher AES-256-CBC
    tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-256-CBC-SHA
    proto udp
    auth-user-pass ${config.age.secrets.mullvad-user.path}
    ca ${config.age.secrets.mullvad-ca.path}
    script-security 2
    fast-io
  '';
  makeConfig = servers: base-config + servers;
in
{
  environment.systemPackages = [
    pkgs.mullvad-vpn
  ];
  age.secrets.mullvad-ca.file = ../../secrets/mullvad-ca.age;
  age.secrets.mullvad-user.file = ../../secrets/mullvad-user.age;
  age.secrets.xc-openvpn-config.file = ../../secrets/xc-openvpn-config.age;
  age.secrets.xc-openvpn-auth.file = ../../secrets/xc-openvpn-auth.age;
  services.openvpn.servers = {
    cross-compass-vpn = {
      autoStart = false;
      config = ''
        config ${config.age.secrets.xc-openvpn-config.path}
        auth-user-pass ${config.age.secrets.xc-openvpn-auth.path}
      '';
    };
    mullvad-nl = {
      config = makeConfig ''
        remote-random
        remote nl-ams-001.mullvad.net 1196
        remote nl-ams-013.mullvad.net 1196
        remote nl-ams-006.mullvad.net 1196
        remote nl-ams-011.mullvad.net 1196
        remote nl-ams-012.mullvad.net 1196
        remote nl-ams-004.mullvad.net 1196
        remote nl-ams-002.mullvad.net 1196
        remote nl-ams-005.mullvad.net 1196
        remote nl-ams-016.mullvad.net 1196
        remote nl-ams-010.mullvad.net 1196
        remote nl-ams-017.mullvad.net 1196
        remote nl-ams-003.mullvad.net 1196
        remote nl-ams-014.mullvad.net 1196
        remote nl-ams-015.mullvad.net 1196
        remote nl-ams-018.mullvad.net 1196
        remote nl-ams-009.mullvad.net 1196
      '';
      updateResolvConf = true;
      autoStart = false;
    };
    mullvad-se-sto = {
      config = makeConfig ''
        remote-random
        remote se-sto-016.mullvad.net 1197
        remote se-sto-006.mullvad.net 1197
        remote se-sto-015.mullvad.net 1197
        remote se-sto-017.mullvad.net 1197
        remote se-sto-009.mullvad.net 1197
        remote se-sto-019.mullvad.net 1197
        remote se-sto-014.mullvad.net 1197
        remote se-sto-018.mullvad.net 1197
        remote se-sto-007.mullvad.net 1197
        remote se-sto-013.mullvad.net 1197
        remote se-sto-012.mullvad.net 1197
        remote se-sto-010.mullvad.net 1197
        remote se-sto-021.mullvad.net 1197
        remote se-sto-023.mullvad.net 1197
        remote se-sto-011.mullvad.net 1197
        remote se-sto-008.mullvad.net 1197
        remote se-sto-024.mullvad.net 1197
        remote se-sto-020.mullvad.net 1197
        remote se-sto-022.mullvad.net 1197
      '';
      updateResolvConf = true;
      autoStart = false;
    };
    mullvad-se-got = {
      config = makeConfig ''
        remote-random
        remote se-got-003.mullvad.net 1194
        remote se-got-001.mullvad.net 1194
        remote se-got-011.mullvad.net 1194
        remote se-got-002.mullvad.net 1194
        remote se-got-005.mullvad.net 1194
        remote se-got-008.mullvad.net 1194
        remote se-got-007.mullvad.net 1194
        remote se-got-004.mullvad.net 1194
        remote se-got-009.mullvad.net 1194
        remote se-got-006.mullvad.net 1194
        remote se-got-010.mullvad.net 1194
      '';
      updateResolvConf = true;
      autoStart = false;
    };
  };
}
