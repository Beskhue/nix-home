with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "brightness-control-${version}";
  version = "0.1.0";

  src = ./.;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bin/brightness-control.sh $out/bin/brightness-control
    chmod +x $out/bin/*
    wrapProgram $out/bin/brightness-control --prefix PATH : ${lib.makeBinPath [ pkgs.xorg.xbacklight pkgs.glib.bin ]}
  '';
}
