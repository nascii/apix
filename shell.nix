with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "playground-shell";
  buildInputs = [
    elixir
  ];
  shellHook = ''
  '';
}
