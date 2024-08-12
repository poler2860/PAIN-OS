{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {

    # Ensure we have a clean enviroment
	pure = true;

	buildInputs = [
	# Packages to be installed
		pkgs.git
		pkgs.gnumake
		pkgs.nasm
	];

	# Add the gcc-cross-compiler and bin utils to the PATH (location of the binaries)
	shellHook = ''
		export PATH="$PATH:$PWD/cross/bin"
	'';

}
