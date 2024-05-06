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
    carrier = {
      enable = true;
      machines = [
        {
          machine = "nixos";
          alias = "nixos";
          buildAttribute = [ "system" "build" "dist" ];
          tags = [ "pxe" ];
        }
        {
          machine = "node1";
          alias = "node1";
          extraModules = [ ../../configs/pxe-only.nix ];
          buildAttribute = [ "system" "build" "dist" ];
          tags = [ "pxe" ];
        }
      ];
    };
  };
}
