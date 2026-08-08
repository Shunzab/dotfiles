{ inputs }:

{
  stable = import ./stable.nix { inherit inputs; };
  nur = import ./nur.nix { inherit inputs; };
}
