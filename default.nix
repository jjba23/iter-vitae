{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, guile ? pkgs.guile
, coreutils ? pkgs.coreutils
, util-linux ? pkgs.util-linux
, makeWrapper ? pkgs.makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "iter-vitae";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [
    guile
    makeWrapper
  ];

  buildInputs = [
    guile
    coreutils
    util-linux
  ];

  buildPhase = ''
    runHook preBuild

    # Determine scheme source directory (supports root or src/ directory layout)
    if [ -d "src/iter-vitae" ]; then
      SCHEME_SRC="src/iter-vitae"
    elif [ -d "src" ]; then
      SCHEME_SRC="src"
    else
      SCHEME_SRC="."
    fi

    # Create target module directories in store
    mkdir -p $out/share/guile/site/3.0/iter-vitae/theme
    mkdir -p $out/lib/guile/3.0/site-ccache/iter-vitae/theme

    # Copy root Scheme source files
    for file in defaults html main prelude renderer; do
      if [ -f "$SCHEME_SRC/$file.scm" ]; then
        cp "$SCHEME_SRC/$file.scm" "$out/share/guile/site/3.0/iter-vitae/$file.scm"
      elif [ -f "$SCHEME_SRC/iter-vitae/$file.scm" ]; then
        cp "$SCHEME_SRC/iter-vitae/$file.scm" "$out/share/guile/site/3.0/iter-vitae/$file.scm"
      fi
    done

    # Copy theme Scheme files
    for theme_file in ef-cyprus ef-cyprus-faces fatum fatum-faces fundamental; do
      if [ -f "$SCHEME_SRC/$theme_file.scm" ]; then
        cp "$SCHEME_SRC/$theme_file.scm" "$out/share/guile/site/3.0/iter-vitae/theme/$theme_file.scm"
      elif [ -f "$SCHEME_SRC/iter-vitae/theme/$theme_file.scm" ]; then
        cp "$SCHEME_SRC/iter-vitae/theme/$theme_file.scm" "$out/share/guile/site/3.0/iter-vitae/theme/$theme_file.scm"
      fi
    done

    # Byte-compile Guile Scheme modules (.scm -> .go)
    GUILE_TARGET="$out/share/guile/site/3.0"
    CCACHE_TARGET="$out/lib/guile/3.0/site-ccache"

    for file in defaults html main prelude renderer; do
      if [ -f "$GUILE_TARGET/iter-vitae/$file.scm" ]; then
        guild compile -L "$GUILE_TARGET" -o "$CCACHE_TARGET/iter-vitae/$file.go" "$GUILE_TARGET/iter-vitae/$file.scm"
      fi
    done

    for theme_file in ef-cyprus ef-cyprus-faces fatum fatum-faces fundamental; do
      if [ -f "$GUILE_TARGET/iter-vitae/theme/$theme_file.scm" ]; then
        guild compile -L "$GUILE_TARGET" -o "$CCACHE_TARGET/iter-vitae/theme/$theme_file.go" "$GUILE_TARGET/iter-vitae/theme/$theme_file.scm"
      fi
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install executable script
    mkdir -p $out/bin
    if [ -f "scripts/iter-vitae" ]; then
      cp scripts/iter-vitae $out/bin/iter-vitae
    elif [ -f "iter-vitae" ]; then
      cp iter-vitae $out/bin/iter-vitae
    fi
    chmod +x $out/bin/iter-vitae

    # Install resources (help text & CSS styles)
    mkdir -p $out/share/resources/css
    if [ -f "resources/help.txt" ]; then
      cp resources/help.txt $out/share/resources/
    fi
    if [ -d "resources/css" ]; then
      cp -r resources/css/* $out/share/resources/css/
    fi

    # Wrap executable with required runtime PATH and Guile module search paths
    wrapProgram $out/bin/iter-vitae \
      --prefix PATH : ${lib.makeBinPath [ guile coreutils util-linux ]} \
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
