{machine, ...}: {
  # Networking
  networking = {
    # Network name is the machine's name
    hostName = machine; # "Spark"

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    interfaces = {
      wlan0 = {
        useDHCP = true;
      };
    };

    # Automatically connect to known networks
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          # Allow IWD to configure network interfaces
          EnableNetworkConfiguration = true;
          # Randomize MAC Address per-network
          AddressRandomization = "network";
        };
        Network = {
          EnableIPv6 = true;
          # DNS resolution happens in systemd-resolved (see below)
          NameResolvingService = "systemd";
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  #######
  # DNS #
  #######

  # CyberGhost DNS: Ostensibly don't keep logs, and are free
  networking.nameservers = ["38.132.106.139" "194.187.251.67"];
  services.resolved = {
    enable = true;
    domains = ["~."];

    # Secure DNS
    dnssec = "true";
    dnsovertls = "true";

    # Cloudflare DNS Fallback
    fallbackDns = ["1.1.1.1"];
  };
}
