{ username }: { pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
  ];

  system.stateVersion = "24.05";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.growPartition = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  services.resolved = {
    # Disable local DNS stub listener on 127.0.0.53
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  virtualisation.azure.agent.enable = true;
  services.cloud-init.enable = true;
  systemd.services.cloud-config.serviceConfig = {
    Restart = "on-failure";
  };
  services.cloud-init.network.enable = true;
  networking.useDHCP = false;
  networking.useNetworkd = true;

  programs.zsh.enable = true;
  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ~/.ssh/id_rsa.pub)
    ];
    shell = pkgs.zsh;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  
  environment.systemPackages = with pkgs; [
    curl
    git
  ];

  nix.settings = {
    warn-dirty = false;
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ username ];
  };

   networking.firewall = {
    enable = false;
  };
}
