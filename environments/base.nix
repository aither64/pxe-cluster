{ config, pkgs, confData, ... }:
{
  time.timeZone = "Europe/Amsterdam";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    screen
    tree
  ];

  users.users.root.openssh.authorizedKeys.keys = with confData.sshKeys; admins;
}
