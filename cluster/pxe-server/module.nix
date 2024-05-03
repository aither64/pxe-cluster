{ config, ... }:
{
  cluster."pxe-server" = {
    spin = "nixos";
    swpins.channels = [ "nixos-stable" ];
    host = {
      name = "pxe-server";
      location = "dev";
      domain = "vpsfree.cz";
      target = "192.168.100.5";
    };
  };
}
