{ config, ... }:
let
  nixpkgsBranch = branch: {
    type = "git-rev";

    git-rev = {
      url = "https://github.com/NixOS/nixpkgs";
      update.ref = "refs/heads/${branch}";
    };
  };

  vpsadminosBranch = branch: {
    type = "git-rev";

    git-rev = {
      url = "https://github.com/vpsfreecz/vpsadminos";
      update.ref = "refs/heads/${branch}";
    };
  };

  vpsadminBranch = branch: {
    type = "git-rev";

    git-rev = {
      url = "https://github.com/vpsfreecz/vpsadmin";
      update.ref = "refs/heads/${branch}";
    };
  };
in {
  confctl.swpins.core.pins = {
    nixpkgs = {
      type = "git-rev";
      git-rev = {
        url = "https://github.com/NixOS/nixpkgs";
        update.ref = "refs/heads/nixos-unstable";
        update.auto = false;
      };
    };
  };

  confctl.swpins.channels = {
    # nixos-unstable = { nixpkgs = nixpkgsBranch "nixos-unstable"; };

    nixos-stable = { nixpkgs = nixpkgsBranch "nixos-25.05"; };

    nodes = {
      nixpkgs = nixpkgsBranch "nixos-25.05";
      vpsadminos = vpsadminosBranch "staging";
      vpsadmin = vpsadminBranch "master";
    };
  };
}
