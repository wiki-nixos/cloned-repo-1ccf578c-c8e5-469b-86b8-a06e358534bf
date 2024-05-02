# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
  nixosModules = "${inputs.self}/modules/nixos";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${inputs.self}/base_configuration.nix"
      inputs.home-manager.nixosModules.default
      inputs.musnix.nixosModules.musnix
      "${nixosModules}/gnome.nix"
      "${nixosModules}/obs.nix"
      "${nixosModules}/amdgpu.nix"
      "${nixosModules}/podman.nix"
      "${nixosModules}/steam.nix"
    ];

  miniluz.gnome.enable = true;
  miniluz.amdgpu.enable = true;
  miniluz.obs-studio.enable = true;

  miniluz.podman.enable = true;
  miniluz.steam.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "sunlight"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # <https://wiki.nixos.org/wiki/PipeWire#Low-latency_setup>
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 32;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 32;
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  musnix.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "miniluz" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.pathsToLink = [ "/share/zsh" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
