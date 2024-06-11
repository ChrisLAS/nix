# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./earlyoom.nix
    #./oom.nix
    # /home/chrisf/build/musnix  # Now imported via flake.
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # OOM configuration:
  systemd = {
    # Create a separate slice for nix-daemon that is
    # memory-managed by the userspace systemd-oomd killer
    slices."nix-daemon".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "95%";
    };
    services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
  };

  networking.hostName = "rvbee"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Blueteeth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.dconf.enable = true;

  # Enable PolKit
  security.polkit.enable = true;

  # Configure keymap in X11

  services.xserver.xkb.layout = "us";

  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

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
    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chrisf = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Chris Fisher";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "libvirtd"
      "video"
      "render"
      "audio"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Enable virtualisation

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable VirtualBox 10-27-23

  # virtualisation.virtualbox.host.enable = true;
  # boot.kernelParams = [ "vboxdrv.load_state=1" ];
  # users.extraGroups.vboxusers.members = [ "chrisf" ];

  # Lets get Fish Shell - CF 6-1-22

  programs.fish.enable = true;

  # Trying to get ADB for Android 11-23.22

  programs.adb.enable = true;

  # Flatpak bitches - CF 6-1-22

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Enable Vulkan
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Nix experimental features and Flakes 4-17-24

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    libsForQt5.ktexteditor
    libsForQt5.yakuake
    kdePackages.kdenlive
    kdePackages.ark
    kdePackages.kdeconnect-kde
    kdePackages.ktorrent
    krita
    kdePackages.discover
    kdePackages.kfind
    kdePackages.kleopatra
    kdePackages.filelight
    kdePackages.isoimagewriter
    kate
    htop
    nixFlakes
    pkgs.tailscale
    btop
    btrfs-progs
    btrfs-snap
    pciutils
    magic-wormhole
    yt-dlp
    pkgs.cifs-utils
    pkgs.samba
    neofetch
    nmap
    mosh
    ark
    fuse
    fuse3
    steam-run
    rustdesk-flutter
    steam
    appimage-run
    android-udev-rules
    adb-sync
    git
    jmtpfs
    angryipscanner
    gnumake
    unzip
    zip
    gnupg
    pkgs.restic
    pkgs.autorestic
    pkgs.restique
    pkgs.nextcloud-client
    google-chrome
    quickemu
    quickgui
    x32edit
    junction
    distrobox
    tor-browser
    v4l-utils
    v4l2-relayd
    libv4l
    sunshine
    logitech-udev-rules
    ltunify
    solaar
    gtop
    ventoy
    wine-wayland
    winetricks
    wineasio
    bottles-unwrapped
    yarn
    cool-retro-term
    wayland-protocols
    wayland-scanner
    wayland
    avahi
    mesa
    libffi
    libevdev
    libcap
    libdrm
    xorg.libXrandr
    xorg.libxcb
    ffmpeg-full
    libevdev
    libpulseaudio
    xorg.libX11
    pkgs.xorg.libxcb
    xorg.libXfixes
    libva
    libvdpau
    pkgs.moonlight-qt
    pkgs.sunshine
    firefox
    slack
    telegram-desktop
    nheko
    libsForQt5.neochat
    element-desktop-wayland
    mpv
    haruna
    trayscale
    reaper
    lame
    xdotool
    pwvucontrol
    easyeffects
    pipecontrol
    wireplumber
    pavucontrol
    ncpamixer
    carla
    qjackctl
    qpwgraph
    libsForQt5.plasma-browser-integration
    sonobus
    vlc
    typora
    neovim
    vimPlugins.LazyVim
    maestral-gui
    pkgs.amdvlk
    pkgs.driversi686Linux.amdvlk
    element-desktop
    gh
    gitui
    cmake
    ispell
    gcc
    go
    aspell
    gnumake
    patchelf
    alacritty
    glxinfo
    libnotify
    yt-dlp
    binutils
    dstat
    file
    iotop
    pciutils
    zellij
    tree
    lsof
    lshw
    python3
    qemu
    virt-manager
  ];

  # Wayland support for Slack
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable Auto Optimising the store CF 5-18-23
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  # Passwords are for Losers
  security = {
    sudo.wheelNeedsPassword = false;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Tailscale Service - CF 6-3-22
  services.tailscale.enable = true;

  # Enable musnix
  musnix.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
