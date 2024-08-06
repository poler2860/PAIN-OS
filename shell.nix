{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
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

	# Ensure we have a clean enviroment
	pure = true;

}

