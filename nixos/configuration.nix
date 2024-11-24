# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
  
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  };

  # use x keymap in console
  console.useXkbConfig = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  # Enable sound with pipewire.
  hardware = {
    pulseaudio.enable = false;
    # for steam. Fixed launch issue.
    graphics.enable32Bit = true;
    graphics.enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
    firewall.trustedInterfaces = [ "docker0" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    rocmSupport = true;
  };
  
  # hyprland
  programs = {
    hyprland.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  security = {
    pam.services.swaylock = {
      text = "auth include login";
    };
    rtkit.enable = true;
    polkit.enable = true;
  };
  
  services = {
    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # openssh.enable = true;

    # sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };

    xserver = {
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
        options = "ctrl:nocaps";
      };
      # for steam. maybe not needed.
      videoDrivers = [ "amdgpu" ];
    };

  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jjorgens = {
    isNormalUser = true;
    description = "John Jorgensen";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "docker" ];
    packages = with pkgs; [
    #  firefox
    #  thunderbird
    ];
  };

  # docker support
  virtualisation = {
    docker.enable = true;
    docker.storageDriver = "btrfs";
  };
  




  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
