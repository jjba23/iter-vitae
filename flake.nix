#; Iter Vitae

# Copyright © Josep Jesus Bigorra Algaba

# iter-vitae is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# iter-vitae is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

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
