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

  # Helper script for manual kexec from netboot server
  boot.initrd.extraUtilsCommands =
    let
      kexecNetboot = ''
        #!/bin/sh
        # Usage: $0 [generation]

        generation=current
        kexec_files="bzImage initrd kernel-params"
        wdir=/tmp/kexec

        [ -n "$1" ] && generation="$1"

        # Find httproot in /proc/cmdline
        http_root="$(sed -n 's/.*httproot=\([^[:space:]]*\).*/\1/p' /proc/cmdline)"

        if [ -z "$http_root" ]; then
          echo "ERROR: Unable to find httproot= parameter in /proc/cmdline"
          exit 1
        fi

        # Strip the last two path components (like "../../")
        http_base="$(echo "$http_root" | sed 's!/[^/]*$!!; s!/[^/]*$!!')"

        # Build URL for the selected generation
        http_newurl="$http_base/$generation"
        echo "Base URL for kexec files: $http_newurl"

        # Download the necessary kernel/initrd/kernel-params
        mkdir -p "$wdir"

        for file in $kexec_files ; do
          wget "$http_newurl/$file" -O "$wdir/$file" || {
            echo "ERROR: Failed to download $file"
            exit 1
          }
        done

        # Load the new kernel
        kexec -l "$wdir/bzImage" --initrd="$wdir/initrd" --command-line="$(cat "$wdir/kernel-params")" || {
          echo "ERROR: kexec load failed"
          exit 1
        }

        echo "Kexec loaded, run kexec -e"
        exit 0
      '';
    in ''
      copy_bin_and_libs ${pkgs.kexec-tools}/bin/kexec

      cat <<'EOF' > $out/bin/kexec-netboot
      ${kexecNetboot}
      EOF

      chmod +x $out/bin/kexec-netboot
    '';

  users.users.root.initialHashedPassword = "";
}
