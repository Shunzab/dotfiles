{
  description = "Iteration one of my custom flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    hardware.url = "github:nixos/nixos-hardware";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = 
    {
      self, 
      nixpkgs, 
      nixpkgs-stable, 
      nur, 
      home-manager, 
      disko, 
      sops-nix,
      ...
    }@inputs:

  let
    overlays = import ./overlays {inherit inputs;};
  in
  {
    overlays = overlays;
    nixosConfigurations = {
      
      vm = nixpkgs.lib.nixosSystem{
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          {
	    nixpkgs.overlays = [
              overlays.stable
              overlays.nur
	    ];
	  }

          sops-nix.nixosModules.sops
	  disko.nixosModules.disko
          home-manager.nixosModules.home-manager {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "backup";
	  }

	  ./hosts/vm/configuration.nix
          ./hosts/vm/hardware-configuration.nix
	  ./hosts/vm/disko.nix

	 ];
       };
     };
   };
}
