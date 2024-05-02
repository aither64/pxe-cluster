{ config, pkgs, lib, confDir, confLib, confData, ... }:
let
  images = import ../../../vpsfree.cz/vpsfree-cz-configuration/lib/images.nix {
    inherit config lib pkgs confDir confLib confData;
    nixosModules = [
      ../../environments/base.nix
    ];
  };
in
{
  imports = [
    ./hardware.nix
    ../../environments/base.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "pxe-server";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
  ];

  services.openssh.enable = true;
  
  services.netboot = {
    enable = true;
    host = "192.168.2.233";
    inherit (images) nixosItems;
    vpsadminosItems = images.allNodes "vpsfree.cz";
    includeNetbootxyz = true;
    allowedIPRanges = [
      "192.168.2.0/24"
    ];
  };

  system.stateVersion = "21.05";
}
