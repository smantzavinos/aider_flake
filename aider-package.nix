# { pkgs, lib, buildPythonPackage, fetchPypi, python3Packages }:
{ lib, pkgs }:

let
  python3Packages = pkgs.python312Packages;
  py_tree_sitter_version = "0.22.3";
  py_tree_sitter_languages_version = "1.10.2";

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

  # tree_sitter = python3Packages.buildPythonPackage rec {
  #   pname = "tree-sitter";
  #   version = "0.22.6";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "tree-sitter";
  #     repo = "tree-sitter";
  #     rev = "v${version}";
  #     sha256 = "jBCKgDlvXwA7Z4GDBJ+aZc52zC+om30DtsZJuHado1s=";
  #   };
  #   nativeBuildInputs = with python3Packages; [ setuptools wheel pip ];
  #   propagatedBuildInputs = with python3Packages; [];
  #   meta = with lib; {
  #     description = "Tree-sitter";
  #     license = licenses.mit;
  #   };
  # };

  # tree_sitter = pkgs.rustPlatform.buildRustPackage rec {
  #   pname = "tree-sitter";
  #   version = "0.22.6";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "tree-sitter";
  #     repo = "tree-sitter";
  #     rev = "v${version}";
  #     sha256 = "jBCKgDlvXwA7Z4GDBJ+aZc52zC+om30DtsZJuHado1s=";
  #   };

  #   cargoSha256 = "44FIO0kPso6NxjLwmggsheILba3r9GEhDld2ddt601g=";

  #   meta = with lib; {
  #     description = "Tree-sitter core library";
  #     license = licenses.mit;
  #   };
  # };

  py_tree_sitter = python3Packages.buildPythonPackage rec {
    pname = "py-tree-sitter";
    version = py_tree_sitter_version;
    src = pkgs.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "py-tree-sitter";
      rev = "v${version}";
      sha256 = "VrFRQFO1K8v46Lowy2+kDseXzInJsmgl9yEECu9uMqQ=";
    };
    nativeBuildInputs = with python3Packages; [ setuptools wheel pip ];
    propagatedBuildInputs = [ pkgs.tree-sitter ];
    # propagatedBuildInputs = [ tree_sitter ];
    # buildInputs = [ tree_sitter_lib ];

    # tree_sitter_lib = final.fetchFromGitHub {
    #   owner = "tree-sitter";
    #   repo = "tree-sitter";
    #   rev = "0.20.6";
    #   sha256 = "jBCKgDlvXwA7Z4GDBJ+aZc52zC+om30DtsZJuHado1s=";
    # };

    # preBuild = ''
    #   export CFLAGS="-I${tree_sitter_lib}/include"
    #   export LDFLAGS="-L${tree_sitter_lib}/lib"
    # '';

    preBuild = ''
      export CFLAGS="-I${pkgs.tree-sitter}/include"
      export LDFLAGS="-L${pkgs.tree-sitter}/lib"

      # Create expected directory structure
      mkdir -p tree_sitter/core/lib/src

      # Link or copy tree-sitter source files into the expected directory
      cp -r ${pkgs.tree-sitter}/lib/* tree_sitter/core/lib/src/
    '';

    meta = with lib; {
      description = "Tree-sitter";
      license = licenses.mit;
    };
  };

  py_tree_sitter_languages = python3Packages.buildPythonPackage rec {
    pname = "tree-sitter-languages";
    version = py_tree_sitter_languages_version;
    src = pkgs.fetchFromGitHub {
      owner = "grantjenks";
      repo = "py-tree-sitter-languages";
      rev = "v${version}";
      sha256 = "AuPK15xtLiQx6N2OATVJFecsL8k3pOagrWu1GascbwM=";
    };
    nativeBuildInputs = with python3Packages; [ setuptools wheel pip ];
    propagatedBuildInputs = [ py_tree_sitter ];
    meta = with lib; {
      description = "Tree-sitter languages";
      license = licenses.mit;
    };
  };

  # python3PackagesOverrides = python3Packages.override {
  #   overrides = python-self: python-super: {
  #     tree-sitter = tree_sitter;
  #   };
  # };
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

  propagatedBuildInputs = [
    python3Packages.aiohttp
    python3Packages.aiohappyeyeballs
    python3Packages.aiosignal
    python3Packages.annotated-types
    python3Packages.anyio
    python3Packages.attrs
    python3Packages.backoff
    python3Packages.beautifulsoup4
    python3Packages.certifi
    python3Packages.cffi
    python3Packages.charset-normalizer
    python3Packages.click
    python3Packages.configargparse
    python3Packages.diff-match-patch
    python3Packages.diskcache
    python3Packages.distro
    python3Packages.filelock
    python3Packages.flake8
    python3Packages.frozenlist
    python3Packages.fsspec
    python3Packages.gitdb
    python3Packages.gitpython
    # grep-ast
    python3Packages.h11
    python3Packages.httpcore
    python3Packages.httpx
    python3Packages.huggingface-hub
    python3Packages.idna
    python3Packages.importlib-metadata
    python3Packages.importlib-resources
    python3Packages.jinja2
    python3Packages.jsonschema
    python3Packages.jsonschema-specifications
    python3Packages.litellm
    python3Packages.markdown-it-py
    python3Packages.markupsafe
    python3Packages.mccabe
    python3Packages.mdurl
    python3Packages.multidict
    python3Packages.networkx
    python3Packages.numpy
    python3Packages.openai
    python3Packages.packaging
    python3Packages.pathspec
    python3Packages.pillow
    python3Packages.prompt-toolkit
    python3Packages.pycodestyle
    python3Packages.pycparser
    python3Packages.pydantic
    python3Packages.pydantic-core
    python3Packages.pyflakes
    python3Packages.pygments
    python3Packages.pypandoc
    python3Packages.python-dotenv
    python3Packages.pyyaml
    python3Packages.referencing
    python3Packages.regex
    python3Packages.requests
    python3Packages.rich
    python3Packages.rpds-py
    python3Packages.scipy
    python3Packages.smmap
    python3Packages.sniffio
    python3Packages.sounddevice
    python3Packages.soundfile
    python3Packages.soupsieve
    python3Packages.tiktoken
    python3Packages.tokenizers
    python3Packages.tqdm
    # tree-sitter.override { version = tree_sitter_version; }
    # tree-sitter-languages.override { version = tree_sitter_languages_version; }
    python3Packages.typing-extensions
    python3Packages.urllib3
    python3Packages.wcwidth
    python3Packages.yarl
    python3Packages.zipp
    py_tree_sitter
    py_tree_sitter_languages
    configparser
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
