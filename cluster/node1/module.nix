{ config, ... }:
{
  cluster."node1" = {
    spin = "vpsadminos";

    swpins.channels = [ "nodes" ];

    node = {
      id = 101;
      role = "hypervisor";
      storageType = "ssd";
    };

    host = {
      name = "node1";
      location = "dev";
      domain = "vpsfree.cz";
    };

    netboot = {
      enable = true;
      macs = [
        "52:54:00:84:11:45"
      ];
    };

    osNode = {
      networking.bird.enable = false;
    };
  };
}
