{ buildPythonPackage
, stdenv
, fetchFromGitHub
, filelock
, numpy
, packaging
, regex
, requests
, sacremoses
, sentencepiece
, tokenizers
, tqdm
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    sha256 = "1caqz5kp8mfywhiq8018c2jf14v15blj02fywh9xgvpq2dns9sc1";
  };

  propagatedBuildInputs = [
    filelock numpy packaging regex requests sacremoses sentencepiece tokenizers tqdm
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "State-of-the-art Natural Language Processing for TensorFlow 2.0 and PyTorch";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
