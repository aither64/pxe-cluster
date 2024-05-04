{ config, pkgs, lib, ... }:
{
  imports = [
    ../../environments/base.nix
    <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix>
  ];

  system.build.dist = pkgs.symlinkJoin {
    name = "nixos-netboot";
    paths = [
      config.system.build.netbootRamdisk
      config.system.build.kernel
      config.system.build.netbootIpxeScript
    ];
  };

  boot.initrd.kernelModules = [ "virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console" "e1000e" ];

  networking.hostName = "nixos";
  networking.useDHCP = true;

  services.haveged.enable = true;

  users.users.root.initialHashedPassword = "";

  system.stateVersion = config.system.nixos.release;
}
