{ config, ... }:
{
  cluster."node1" = {
    spin = "vpsadminos";
    
    swpins.channels = [ "nodes" ];

    node = {
      id = 101;
      role = "hypervisor";
    };

    host = {
      name = "node1";
      location = "home";
      domain = "vpsfree.cz";
    };

    netboot = {
      enable = true;
      macs = [
        "52:54:00:30:9e:b9"
      ];
    };

    osNode = {
      networking.bird.enable = false;
    };
  };
}
