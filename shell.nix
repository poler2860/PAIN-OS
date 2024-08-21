{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {

    # Ensure we have a clean enviroment
	pure = true;

	buildInputs = [
	   # Get the necessary utilities
		pkgs.coreutils
		pkgs.findutils
       	pkgs.gnused
       	pkgs.gnugrep
       	pkgs.gawk
       	pkgs.bash
	pkgs.unixtools.whereis
       	pkgs.gzip
	pkgs.bison
	pkgs.flex
	pkgs.gmp
	pkgs.libmpc
	pkgs.mpfr
	pkgs.texinfo
	pkgs.isl
	pkgs.perl

       # Additional packages to be installed
	   pkgs.git
	   pkgs.gnumake
	   pkgs.nasm
	   pkgs.qemu
	];

	# Add the gcc-cross-compiler and bin utils to the PATH (location of the binaries)
	shellHook = ''
	    export PATH="$PATH:$HOME/opt/cross/bin"
	 '';

}
