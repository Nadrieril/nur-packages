{ buildPythonPackage
, stdenv
, fetchPypi
, nltk
, numpy
, pytorch
, scikitlearn
, scipy
, tqdm
, transformers
}:

buildPythonPackage rec {
  pname = "sentence-transformers";
  version = "0.2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a6ixs9lp448bq4q0h7ciixszfqhlzn3sqwshwy03mra4wg0w9b8";
  };

  propagatedBuildInputs = [
    transformers tqdm pytorch numpy scikitlearn scipy nltk
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/UKPLab/sentence-transformers";
    description = "Sentence Transformers: Multilingual Sentence Embeddings using BERT / RoBERTa / XLM-RoBERTa & Co. with PyTorch";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
