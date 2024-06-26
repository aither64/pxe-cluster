{ config, ... }:
{
  cluster."nixos" = {
    spin = "nixos";

    swpins.channels = [ "nixos-stable" ];

    host = {
      name = "nixos";
      location = "dev";
      domain = "vpsfree.cz";
      target = null;
    };

    netboot = {
      enable = true;
    };
  };
}
