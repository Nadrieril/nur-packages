{ buildPythonPackage
, stdenv
, fetchFromGitHub
, rustc
, semantic-version
, toml
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = pname;
    rev = "v${version}";
    sha256 = "19q0b17n604ngcv8lq5imb91i37frr1gppi8rrg6s4f5aajsm5fm";
  };

  nativeBuildInputs = [
    rustc
  ];

  propagatedBuildInputs = [
    semantic-version toml
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/PyO3/setuptools-rust";
    description = "Setuptools plugin for Rust extensions";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
