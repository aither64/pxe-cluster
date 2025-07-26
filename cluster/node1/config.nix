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

  boot.zfsBuiltin = false;
  services.live-patches.enable = false;

  networking.hostName = "node1";
  networking.useDHCP = true;

  os.channel-registration.enable = false;

  services.haveged.enable = true;

  confctl.programs.kexec-netboot.enable = true;

  runit.halt.hooks = {
    "kexec-netboot".source = pkgs.writeScript "kexec-netboot" ''
      #!${pkgs.bash}/bin/bash

      [ "$HALT_HOOK" != "pre-run" ] && exit 0
      [ "$HALT_ACTION" != "reboot" ] && exit 0
      [ "$HALT_FORCE" != "0" ] && exit 0
      [ "$HALT_KEXEC" == "0" ] && exit 0

      echo "Configuring kexec from netboot server"
      echo "Use --no-kexec to skip it"
      echo

      kexec-netboot
      exit $?
    '';
  };

  users.users.root.initialHashedPassword = "";
}
