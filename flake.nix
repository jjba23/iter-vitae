{
  description = "Iter Vitae - Resume / Curriculum Vitae generator written in Guile Scheme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          iter-vitae = pkgs.callPackage ./default.nix {};
          default = self.packages.${system}.iter-vitae;
        });

      apps = forAllSystems (system: {
        iter-vitae = {
          type = "app";
          program = "${self.packages.${system}.iter-vitae}/bin/iter-vitae";
        };
        default = self.apps.${system}.iter-vitae;
      });

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.iter-vitae ];
            packages = with pkgs; [
              guile
              coreutils
              util-linux
            ];
          };
        });
    };
}
