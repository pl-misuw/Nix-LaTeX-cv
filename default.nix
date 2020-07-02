{ pkgs ? import <nixpkgs> {}, ... }:

let
  userSecrets = import ./userSecrets.nix;
in
  pkgs.stdenv.mkDerivation({
    name = "plmisuw-cv";
    src = ./.;

    buildInputs = with pkgs; [ 
      (texlive.combine {
        inherit (texlive)
          scheme-medium
          fontawesome
          geometry
          hyperref
          moresize
          raleway;
      })
    ];

    buildPhase = ''
      # See: https://tex.stackexchange.com/questions/496275/texlive-2019-lualatex-doesnt-compile-document
      # Without export, lualatex fails silently, with exit code '0'
      export TEXMFVAR=$(pwd)
      lualatex -interaction=nonstopmode plmisuw-cv.tex
    '';

    installPhase = ''
      mkdir -pv ./out
      cp plmisuw-cv.log ./out
      cp plmisuw-cv.pdf ./out
    '';
  } // userSecrets)
