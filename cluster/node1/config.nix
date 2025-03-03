{ config, pkgs, lib, ... }:
{
  imports = [
    ../../environments/base.nix
    ../../configs/crashdump.nix
  ];

  boot.initrd.kernelModules = [ "virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console" "e1000e" ];

  boot.initrd.network = {
    enable = true;
    useDHCP = true;
    preferredDHCPInterfaceMacAddresses = [
      "52:54:00:84:11:45"
    ];
  };

  networking.hostName = "node1";
  networking.useDHCP = true;

  os.channel-registration.enable = false;

  services.haveged.enable = true;

  users.users.root.initialHashedPassword = "";
}
