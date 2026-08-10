{
  pkgs,
  config,
  lib,
  ...
}:

{
  networking = {

    hostName = "vm";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = true;
    };

    firewall = {
      enable = true; # default behaviour is drop.
      rejectPackets = false;
      #allowedTCPPorts = [];
      #allowedUDPPorts = [];
      allowPing = true;
      logRefusedPackets = true;
      logRefusedUnicastsOnly = true;
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "1.1.1.1#cloudflare-dns.com"
        "9.9.9.9#dns.quad9.net"
      ];
      DNSOverTLS = "opportunistic";
      DNSSEC = true;
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };

    enableRecommendedAlgorithms = true;
  };

  #users.users.root.openssh.authorizedKeys.keys = [
  #  "ssh-ed25519 AAAA... your-public-key-here"
  #];

  # services.openssh.hostKeys = [
  #   { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
  # ];
}
