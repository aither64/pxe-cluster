{ config, pkgs, lib, confMachine, swpinsInfo, ... }:
let
  machineJson = pkgs.writeText "machine-${config.networking.hostName}.json" (builtins.toJSON {
    spin = "nixos";
    fqdn = confMachine.host.fqdn;
    label = confMachine.host.fqdn;
    toplevel = builtins.unsafeDiscardStringContext config.system.build.toplevel;
    macs = confMachine.netboot.macs;
    swpins-info = swpinsInfo;
  });
in {
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
    postBuild = ''
      ln -s ${machineJson} $out/machine.json
    '';
  };

  boot.initrd.kernelModules = [ "virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console" "e1000e" ];

  networking.hostName = "nixos";
  networking.useDHCP = true;

  services.haveged.enable = true;

  users.users.root.initialHashedPassword = "";

  system.stateVersion = config.system.nixos.release;
}
