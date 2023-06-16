{ config, pkgs, ... }: {

  services.tailscale.enable = true;

  services.tailscale.port = 41641;

  networking.firewall.allowedUDPPorts = [ 41641 ];

  environment.systemPackages = [ pkgs.tailscale ];

  systemd.services.add_tailscale_routes = {
    description = "Tailscale routes script";
    wantedBy = [ "multi-user.target" ];
    script = ''
      # Contents of your startup script
      # Replace this with your actual script
      echo 'net.ipv4.ip_forward = 1' | /run/wrappers/bin/sudo tee -a /etc/sysctl.conf
      echo 'net.ipv6.conf.all.forwarding = 1' | /run/wrappers/bin/sudo tee -a /etc/sysctl.conf
      /run/wrappers/bin/sudo sysctl -p /etc/sysctl.conf
    '';
    path = [pkgs.procps];
  };

}
