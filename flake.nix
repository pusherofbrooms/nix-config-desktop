{
  description = "Home Manager configuration of jjorgens";

  inputs = {
    # emacs-overlay is in the nix registry list and so is implicit
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "x86_64-linux";
      # allow unfree software (mostly for steam)
      # apply emacs overlay so I can have my bleeding edge emacsGit
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ emacs-overlay.overlay ];
      };
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/configuration.nix ];
        };
      };
      homeConfigurations.jjorgens = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home-manager/home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
