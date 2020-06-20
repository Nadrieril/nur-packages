{ buildPythonPackage
, stdenv
, runCommand
, makeSetupHook
, writeScript
, fetchFromGitHub
, importCargo
, rustChannelOf
, setuptools-rust
}:

let
  pname = "tokenizers";
  version = "0.7.0";

  root = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "python-v${version}";
    sha256 = "1f13rmqa0zy9x6hilk8j3pdly287ill6qs0xah6q7d0cj8pf5p8f";
  };

  # Make the python bindings the root and the rust lib a subdirectory
  src = runCommand "tokenizers-python-${version}" {} ''
    cp --no-preserve=mode -r "${root}/bindings/python" $out
    cp --no-preserve=mode -r "${root}/tokenizers" $out/tokenizers-rust
    sed -i 's#path = "../../tokenizers"#path = "./tokenizers-rust"#' $out/Cargo.toml
  '';

  toolchain-txt = builtins.readFile "${root}/bindings/python/rust-toolchain";
  toolchain-match = builtins.match ''nightly-([0-9-]*).*'' toolchain-txt;
  toolchain-date = if toolchain-match != null
    then builtins.elemAt toolchain-match 0
    else "2020-05-14";
  rust = (rustChannelOf { date = toolchain-date; channel = "nightly"; }).rust;

  vendorDir = (importCargo "${root}/bindings/python/Cargo.lock").vendorDir;
  cargoHome = makeSetupHook {} (writeScript "make-cargo-home" ''
    export CARGO_HOME=$TMPDIR/vendor
    cp -prd ${vendorDir}/vendor $CARGO_HOME
    chmod -R u+w $CARGO_HOME
  '');

in buildPythonPackage rec {
  inherit pname version src;

  nativeBuildInputs = [
    rust cargoHome
  ];

  buildInputs = [
    setuptools-rust
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/huggingface/tokenizers";
    description = "Fast State-of-the-Art Tokenizers optimized for Research and Production ";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
