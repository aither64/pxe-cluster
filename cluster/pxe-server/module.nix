{ config, ... }:
{
  cluster."pxe-server" = {
    spin = "nixos";
    swpins.channels = [ "nixos-stable" ];
    host = {
      name = "pxe-server";
      location = "home";
      domain = "vpsfree.cz";
      target = "192.168.2.233";
    };
  };
}
