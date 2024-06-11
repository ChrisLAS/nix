{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";
    companion.url = "github:noblepayne/bitfocus-companion-flake";
    companion.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      musnix,
      companion,
      ...
    }:
    {
      nixosConfigurations.rvbee = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Add musnix.
          musnix.nixosModules.musnix
          # Load main configuration.
          ./configuration.nix
          # Inject bitfocus companion in to global packages.
          (
            { pkgs, ... }:
            {
              environment.systemPackages = [ companion.packages.${pkgs.system}.companion ];
            }
          )
        ];
      };
    };
}
