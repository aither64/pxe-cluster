rec {
  shared = [
    # Modules not dependent on spin
    ./cluster
  ];

  nixos = shared ++ [
    # Modules only for NixOS
  ];

  vpsadminos = shared ++ [
    # Modules only for vpsAdminOS
  ];
}
