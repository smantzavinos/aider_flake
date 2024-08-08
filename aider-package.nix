# { pkgs, lib, buildPythonPackage, fetchPypi, python3Packages }:
{ lib, pkgs }:

let
  python3Packages = pkgs.python312Packages;
  tree_sitter_version = "0.22.6";
  tree_sitter_languages_version = "1.10.2";

  # configparser = pkgs.fetchPypi {
  #   pname = "configparser";
  #   version = "5.0.2";
  #   sha256 = "hdXeECz+bRSlFyZ28J0ZxGXOY9YBnPCk7xM4X8U16Cg=";
  # };

  configparser = python3Packages.buildPythonPackage rec {
    pname = "configparser";
    version = "5.0.2";
    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "hdXeECz+bRSlFyZ28J0ZxGXOY9YBnPCk7xM4X8U16Cg=";
    };
    nativeBuildInputs = with python3Packages; [ setuptools wheel pip ];
    propagatedBuildInputs = with python3Packages; [ setuptools_scm ];
    meta = with lib; {
      description = "Configuration file parser for Python";
      license = licenses.asl20;
    };
  };

  tree_sitter = python3Packages.buildPythonPackage rec {
    pname = "tree-sitter";
    version = tree_sitter_version;
    src = pkgs.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "v${version}";
      sha256 = "jBCKgDlvXwA7Z4GDBJ+aZc52zC+om30DtsZJuHado1s=";
    };
    nativeBuildInputs = with python3Packages; [ setuptools wheel pip ];
    propagatedBuildInputs = with python3Packages; [];
    meta = with lib; {
      description = "Tree-sitter";
      license = licenses.mit;
    };
  };

  tree_sitter_languages = python3Packages.buildPythonPackage rec {
    pname = "tree-sitter-languages";
    version = tree_sitter_languages_version;
    src = pkgs.fetchFromGitHub {
      owner = "grantjenks";
      repo = "py-tree-sitter-languages";
      rev = "v${version}";
      sha256 = "AuPK15xtLiQx6N2OATVJFecsL8k3pOagrWu1GascbwM=";
    };
    nativeBuildInputs = with python3Packages; [ setuptools wheel pip ];
    propagatedBuildInputs = [ tree_sitter ];
    meta = with lib; {
      description = "Tree-sitter languages";
      license = licenses.mit;
    };
  };

  python3PackagesOverrides = python3Packages.override {
    overrides = python-self: python-super: {
      tree-sitter = tree_sitter;
    };
  };
in
python3Packages.buildPythonPackage rec {
  pname = "aider";
  version = "0.48.0";

  src = pkgs.fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v0.48.0";
    sha256 = "0m5ZHCfxlOOeUvfQznF5hTCJANCBtrO9rWDudQ+RUxM=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
    pip
  ];

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    aiohappyeyeballs
    aiosignal
    annotated-types
    anyio
    attrs
    backoff
    beautifulsoup4
    certifi
    cffi
    charset-normalizer
    click
    configargparse
    configparser
    # (python3Packages.buildPythonPackage rec {
    #   pname = "configparser";
    #   version = "5.0.2";
    #   src = pkgs.fetchPypi {
    #     inherit pname version;
    #     sha256 = "hdXeECz+bRSlFyZ28J0ZxGXOY9YBnPCk7xM4X8U16Cg=";
    #   };
    #   meta = with lib; {
    #     description = "Configuration file parser for Python";
    #     license = licenses.asl20;
    #   };
    # })
    diff-match-patch
    diskcache
    distro
    filelock
    flake8
    frozenlist
    fsspec
    gitdb
    gitpython
    # grep-ast
    h11
    httpcore
    httpx
    huggingface-hub
    idna
    importlib-metadata
    importlib-resources
    jinja2
    jsonschema
    jsonschema-specifications
    litellm
    markdown-it-py
    markupsafe
    mccabe
    mdurl
    multidict
    networkx
    numpy
    openai
    packaging
    pathspec
    pillow
    prompt-toolkit
    pycodestyle
    pycparser
    pydantic
    pydantic-core
    pyflakes
    pygments
    pypandoc
    python-dotenv
    pyyaml
    referencing
    regex
    requests
    rich
    rpds-py
    scipy
    smmap
    sniffio
    sounddevice
    soundfile
    soupsieve
    tiktoken
    tokenizers
    tqdm
    tree-sitter
    tree-sitter-languages
    # tree-sitter.override { version = tree_sitter_version; }
    # tree-sitter-languages.override { version = tree_sitter_languages_version; }
    typing-extensions
    urllib3
    wcwidth
    yarl
    zipp
  ];

  pythonImportsCheck = ["aider"];

  # postInstall = ''
  #   mkdir -p $out/bin
  #   ln -s $out/lib/python${python3Packages.python.version}/site-packages/aider $out/bin/aider
  # '';

  # postInstall = ''
  #   wrapProgram $out/bin/aider \
  #     --set PYTHONPATH $out/${python3Packages.python.sitePackages}
  # '';
  #
  # checkPhase = ''
  #   ${python3Packages.python.interpreter} -m aider --help
  # '';

  meta = with lib; {
    description = "Aider is AI pair programming in your terminal.";
    homepage = "https://aider.chat";
    license = licenses.asl20; # Apache 2.0 License
    maintainers = with maintainers; [ smantzavinos ];
  };
}
