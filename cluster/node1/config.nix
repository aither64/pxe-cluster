{ config, pkgs, lib, ... }:
{
  imports = [
    ../../environments/base.nix
  ];

  boot.initrd.kernelModules = [ "virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console" "e1000e" ];

  boot.initrd.network = {
    enable = true;
    useDHCP = true;
  };

  networking.hostName = "node1";
  
  os.channel-registration.enable = false;
  
  services.haveged.enable = true;
  
  users.users.root.initialHashedPassword = "";
}
