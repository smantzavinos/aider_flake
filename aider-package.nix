{
  lib,
  stdenv,
  python311,
  fetchFromGitHub,
  git,
  portaudio,
  playwright-driver,
}:

let
  python3 = python311.override {
    self = python3;
    packageOverrides = _: super: { tree-sitter = super.tree-sitter_0_21; };
  };

  pypager = python3.pkgs.buildPythonPackage rec {
    pname = "pypager";
    version = "3.0.0";
    src = fetchFromGitHub {
      owner = "prompt-toolkit";
      repo = "pypager";
      rev = "10c8ece990dfe397b80b0cd039e8ec34fd89e62f";
      hash = "sha256-ny8ECWpI6ZoHLuSaNpS+wNPrG+OYDy42bAQgk40YAqw=";
    };

    nativeBuildInputs = with python3.pkgs; [ setuptools wheel pip ];

    propagatedBuildInputs = with python3.pkgs; [
      prompt-toolkit
      pygments
    ];
  };
in
let
  version = "0.75.2";
  
  aider-chat = python3.pkgs.buildPythonPackage {
    pname = "aider-chat";
    inherit version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      rev = "v${version}";
      hash = "sha256-wGm6JV9ISRi/p1lA3JyzOdHQKFHFxEhfr+NdShUxm0M=";
    };

    build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      aiohappyeyeballs
      backoff
      beautifulsoup4
      configargparse
      diff-match-patch
      diskcache
      flake8
      gitpython
      grep-ast
      importlib-resources
      jiter
      json5
      jsonschema
      litellm
      mixpanel
      monotonic
      networkx
      numpy
      packaging
      pathspec
      pillow
      # TODO: pip probably shouldn't be here but build fails without it. (added with v0.70.0)
      pip
      playwright
      posthog
      prompt-toolkit
      propcache
      pydub
      pypandoc
      pypager
      pyperclip
      pyyaml
      rich
      setuptools-scm
      scipy
      sounddevice
      soundfile
      streamlit
      watchdog
      watchfiles
    ]
    ++ lib.optionals (!tensorflow.meta.broken) [
      llama-index-core
      llama-index-embeddings-huggingface
    ];

  buildInputs = [ portaudio ];

  pythonRelaxDeps = true;

  nativeCheckInputs = (with python3.pkgs; [ pytestCheckHook ]) ++ [ git ];

  disabledTestPaths = [
    # requires network
    "tests/scrape/test_scrape.py"

    # Expected 'mock' to have been called once
    "tests/help/test_help.py"
  ];

  disabledTests =
    [
      # Tests require network
      "test_urls"
      "test_get_commit_message_with_custom_prompt"

      # FileNotFoundError
      "test_get_commit_message"

      # Expected 'launch_gui' to have been called once
      "test_browser_flag_imports_streamlit"

      # AttributeError
      "test_simple_send_with_retries"
      # Expected 'check_version' to have been called once
      "test_main_exit_calls_version_check"
      # AssertionError: assert 2 == 1
      "test_simple_send_non_retryable_error"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # fails on darwin
      "test_dark_mode_sets_code_theme"
      "test_default_env_file_sets_automatic_variable"
      # FileNotFoundError: [Errno 2] No such file or directory: 'vim'
      "test_pipe_editor"
    ];

  makeWrapperArgs = [
    "--set AIDER_CHECK_UPDATE false"
    "--set AIDER_ANALYTICS false"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export AIDER_ANALYTICS="false"
  '';

  optional-dependencies = with python3.pkgs; {
    playwright = [
      greenlet
      playwright
      pyee
      typing-extensions
    ];
  };

    passthru = {
      withPlaywright = aider-chat.overridePythonAttrs (
        { dependencies
        , makeWrapperArgs
        , propagatedBuildInputs ? []
        , ...
        }: {
          dependencies = dependencies ++ aider-chat.optional-dependencies.playwright;
          propagatedBuildInputs = propagatedBuildInputs ++ [ playwright-driver.browsers ];
          makeWrapperArgs = makeWrapperArgs ++ [
            "--set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}"
            "--set PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true"
          ];
        }
      );
    };

    meta = {
    description = "AI pair programming in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    changelog = "https://github.com/paul-gauthier/aider/blob/v${version}/HISTORY.md";
    license = lib.licenses.asl20;
    mainProgram = "aider";
      maintainers = with lib.maintainers; [ taha-yassine ];
    };
  };
in
aider-chat
