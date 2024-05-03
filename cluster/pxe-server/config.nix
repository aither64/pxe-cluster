{ config, pkgs, lib, confDir, confLib, confData, ... }:
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
  networking.interfaces.enp1s0.ipv4.addresses = [
    { address = "192.168.100.5"; prefixLength = 24; }
  ];
  networking.defaultGateway = "192.168.100.1";
  networking.nameservers = [ "192.168.100.1" ];

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
  ];

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}
