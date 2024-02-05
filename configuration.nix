# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  python-discord = p:
    with p;
    with pkgs.python311Packages; [
      pynacl
      setuptools
      jsonpickle
      fastapi
      python-dotenv
      uvicorn
      nextcord
      requests
      yt-dlp
      pandas
    ];

  python-default = p:
    with p;
    with pkgs.python311Packages; [
      jupyter
      jupyterlab
      pandas
      numpy
      scikit-learn
      matplotlib
      Keras
      seaborn
    ];

  python-with-packages = pkgs.python311.withPackages python-discord;
in {
  # Bootloader.
  # gym
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    hostName = "bismarck";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings = {
      LC_ADDRESS = "tr_TR.utf8";
      LC_IDENTIFICATION = "tr_TR.utf8";
      LC_MEASUREMENT = "tr_TR.utf8";
      LC_MONETARY = "tr_TR.utf8";
      LC_NAME = "tr_TR.utf8";
      LC_NUMERIC = "tr_TR.utf8";
      LC_PAPER = "tr_TR.utf8";
      LC_TELEPHONE = "tr_TR.utf8";
      LC_TIME = "tr_TR.utf8";
    };
  };

  # Configure console keymap
  console.keyMap = "trq";

  # Enable sound with pipewire.
  sound.enable = true;

  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kirell = {
    isNormalUser = true;
    description = "arda";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      discord
      (discord.override {nss = nss_latest;})
      firefox
      pipenv
      acpi
      gcc
      alejandra
      git
      cmake
      temurin-jre-bin-8
      jflap
      gparted
      gnumake
      vscode
      solaar
      spotify
      # python-with-packages
      #  thunderbird
    ];
  };

  fonts.packages = with pkgs; [
    liberation_ttf
    (nerdfonts.override {
      fonts = ["Hack" "FiraCode"];
    })
  ];

  system.stateVersion = "23.11"; # Did you read the comment?

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = false;

    nvidia.prime = {
      sync.enable = true;
      #offload.enable = true;
      modesetting.enable = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    opengl = {
      enable = true;
      # driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
        # libGL
        mesa.drivers
      ];
    };
  };

  programs.bash.shellAliases = {
    nixconf = "code /etc/nixos/";
    nixupdate = "sudo nix flake update /etc/nixos && sudo nixos-rebuild switch";
    nixrebuild = "sudo nixos-rebuild switch";
    anakin = "DISPLAY=:0 nohup kwin_x11 --replace &";
    kek = "ssh beer@5.178.111.177 -p 53775";
  };

  time.hardwareClockInLocalTime = true;

  virtualisation.docker.enable = true;

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = ["root" "@users"];
    experimental-features = ["nix-command"];
  };

  services = {
    nginx = {
      enable = true;
      user = "kirell";
      config = ''
        events {}
        http {
          server {
            listen 80;
            server_name localhost;

            location /cdn/ {
              alias /home/kirell/cdn_root/;
              expires 1h;
            }
          }
        }
      '';
    };

    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      videoDrivers = ["intel"];
      layout = "tr";
      xkbVariant = "";
    };

    printing = {
      enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
