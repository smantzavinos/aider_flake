{ pkgs }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "hello-world";
  version = "1.0.0";

  src = ./.;

  meta = with pkgs.lib; {
    description = "A simple Hello World application";
    license = licenses.mit;
    maintainers = with maintainers; [ "smantzavinos" ];
    platforms = platforms.all;
  };
}
