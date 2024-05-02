rec {
  shared = [
    # Modules not dependent on spin
    ./cluster
  ];

  nixos = shared ++ [
    # Modules only for NixOS
    ../../vpsfree.cz/vpsfree-cz-configuration/modules/services/netboot.nix
  ];

  vpsadminos = shared ++ [
    # Modules only for vpsAdminOS
  ];
}
