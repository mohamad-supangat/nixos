# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "id_ID.UTF-8";

  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "id_ID.UTF-8/UTF-8"];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "id_ID.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "id_ID.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "id_ID.UTF-8";
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  #services.xserver = {
  #  layout = "us";
  #  xkbVariant = "";
  #};

  programs.regreet.enable = true;
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
  #       user = "greeter";
  #     };
  #   };
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
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.deve = {
    isNormalUser = true;
    description = "Deve";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  users.users.meli = {
    isNormalUser = true;
    description = "Meliana";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  users.extraGroups.docker.members = [ "deve" ];
security.sudo.extraRules= [
  {  users = [ "deve" ];
    commands = [
       { command = "ALL" ;
         options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }
    ];
  }
];


  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "meli";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    jq
    neovim
    gnumeric
    thinkfan
    pkgs.gnome3.gnome-tweaks
    gjs
    floorp
    nodejs_22
    git
    lazygit
    tmux
    php83
    php83Packages.composer
    python3
    fzf
    ripgrep
    alacritty
    chromium
    docker-compose
    lazydocker
    appimage-run
    otpclient
    nchat
    sublime-merge
    sublime4
    stow
    gnumake
    flameshot
    autoconf
    automake
    p7zip
    busybox

    android-tools
    scrcpy
    wpsoffice
    cloudflare-warp
    cloudflared
    hugo
    # whitesur-gtk-theme
    # kora-icon-theme
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.fish.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  
  services.dbus.enable = true;
  xdg.portal.wlr.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaybg
      xwayland
      nwg-look
      nwg-displays
      wl-clipboard
      dunst
      cliphist
      # rofi
      dconf
      i3status-rust
      # i3status
      # wofi
      fuzzel
      brightnessctl
      lxqt.pcmanfm-qt
      lxqt.qps
      lxqt.pavucontrol-qt
      # lxqt.lxqt-policykit

      #adwaita-qt
      qt6Packages.qt6ct
      libsForQt5.qt5ct

      slurp
      wf-recorder
      grim
      swappy
      bun
    ];
    extraSessionCommands = ''  
	if [ -e ~/.private-env ]
	then
	    source ~/.private-env
	fi


      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      #export QT_STYLE_OVERRIDE="adwaita-dark"
      export QT_QPA_PLATFORMTHEME=qt5ct
      export TERMINAL=alacritty
    '';
  };

  services.openssh.enable = true;
  services.thinkfan = {
    enable = true;
    levels =  [
          [6  0  63]
          [7  56  65]
          # [7  60  85]
    ];
  };


#   services.mysql = {
#   enable = true;
#   package = pkgs.mariadb;
# };



  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.docker.daemon.settings = {
    data-root = "/home/docker";
  };

  nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1w"
  ];




  services.xserver.desktopManager.gnome.extraGSettingsOverridePackages = with pkgs; [
    gnome.nautilus
    #gnome.mutter # should not be needed
    #gtk4 # should not be needed
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?
}
