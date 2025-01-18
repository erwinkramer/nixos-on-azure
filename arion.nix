{ pkgs, arion, ... }: 

{
  virtualisation.arion = {
    backend = "docker";
    projects.dns = {
      serviceName = "dns"; 
      settings = {
             imports = [ ./arion-compose.nix ];
      };
    };
  };
}