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

{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, guile ? pkgs.guile
, coreutils ? pkgs.coreutils
, util-linux ? pkgs.util-linux
, bash ? pkgs.bash
, makeWrapper ? pkgs.makeWrapper
}:

stdenv.mkDerivation {
  pname = "iter-vitae";
  version = "1.0.2";

  src = ./.;

  nativeBuildInputs = [
    guile
    makeWrapper
  ];

  buildInputs = [
    guile
    coreutils
    util-linux
    bash
  ];

  buildPhase = ''
    runHook preBuild

    SITE_DIR="$out/share/guile/site/3.0"
    CCACHE_DIR="$out/lib/guile/3.0/site-ccache"

    mkdir -p "$SITE_DIR" "$CCACHE_DIR"

    # 1. Copy Guile Scheme sources into $SITE_DIR/iter-vitae preserving module hierarchy
    if [ -d "src/iter-vitae" ]; then
      cp -r src/iter-vitae "$SITE_DIR/"
    elif [ -d "src" ]; then
      mkdir -p "$SITE_DIR/iter-vitae"
      cp -r src/* "$SITE_DIR/iter-vitae/"
    elif [ -d "iter-vitae" ]; then
      cp -r iter-vitae "$SITE_DIR/"
    else
      mkdir -p "$SITE_DIR/iter-vitae"
      # Copy top-level scheme files
      find . -maxdepth 1 -name "*.scm" -exec cp {} "$SITE_DIR/iter-vitae/" \;
      # Copy theme directory if present
      if [ -d "theme" ]; then
        cp -r theme "$SITE_DIR/iter-vitae/"
      fi
    fi

    # 2. Export load paths so guild compile can resolve (iter-vitae ...) modules
    export GUILE_LOAD_PATH="$SITE_DIR:$GUILE_LOAD_PATH"
    export GUILE_LOAD_COMPILED_PATH="$CCACHE_DIR:$GUILE_LOAD_COMPILED_PATH"

    # 3. Byte-compile all .scm files recursively
    cd "$SITE_DIR"
    find iter-vitae -name "*.scm" | while read -r scm_file; do
      go_file="$CCACHE_DIR/''${scm_file%.scm}.go"
      mkdir -p "$(dirname "$go_file")"
      guild compile -L "$SITE_DIR" -o "$go_file" "$scm_file" || true
    done
    cd -

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install main wrapper binary
    mkdir -p $out/bin
    if [ -f "scripts/iter-vitae" ]; then
      cp scripts/iter-vitae $out/bin/iter-vitae
    elif [ -f "iter-vitae" ]; then
      cp iter-vitae $out/bin/iter-vitae
    fi
    chmod +x $out/bin/iter-vitae

    # Install resources (help text and CSS themes)
    mkdir -p $out/share/resources/css
    if [ -f "resources/help.txt" ]; then
      cp resources/help.txt $out/share/resources/
    fi
    if [ -d "resources/css" ]; then
      cp -r resources/css/* $out/share/resources/css/
    fi

    # Wrap application binary with GUILE_LOAD_PATH & GUILE_LOAD_COMPILED_PATH
    wrapProgram $out/bin/iter-vitae \
      --prefix PATH : ${lib.makeBinPath [ guile coreutils util-linux bash ]} \
      --prefix GUILE_LOAD_PATH : "$out/share/guile/site/3.0" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/lib/guile/3.0/site-ccache"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Resume / Curriculum Vitae generator written in Guile Scheme";
    homepage = "https://codeberg.org/jjba23/iter-vitae";
    license = licenses.agpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "iter-vitae";
  };
}
