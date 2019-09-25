{ stdenv, requireFile, ncurses5, zlib, libuuid, xorg }:

stdenv.mkDerivation rec {
  name="xilinx-ise-${version}";
  version="14.7";

  src = requireFile rec {
    name = "Xilinx_ISE_DS_Lin_14.7_1015_1.tar";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Login to Xilinx, download from
      https://www.xilinx.com/support/download.html,
      rename the file to ${name}, and add it to the nix store with
      "nix-prefetch-url file:///path/to/${name}".
    '';
    sha256 = "1amd6f6wp4l9zzpsz6y351v4giamdicwg5lswp5azkxvq53b1q6f";
  };

  configurePhase = ''
    # Generate a sample batch install file
    yes | sh bin/lin64/batchxsetup -samplebatchscript install.txt

    # Change the installation dir
	  sed -i "s!^destination_dir=/opt/Xilinx!destination_dir=$out/opt/Xilinx!" install.txt
  '';

  installPhase = ''
    # Run the installer, agreeing to all the licenses
	  yes | ./bin/lin64/batchxsetup -batch install.txt

    # Trim the pkgdir path from the installation directory
	  for _file in $out/opt/Xilinx/14.7/ISE_DS/settings*; do
		  sed -i "s!$out!!g" $_file
	  done
  '';

    # # Replace ISE's outdated libstdc++.so with symlinks to the system version
	  # for _dir in $out/opt/Xilinx/14.7/ISE_DS/{ISE,common}/lib/lin64; do
		#   rm ${_dir}/libstdc++.so{,.6,.6.0.8}
    #   ln -s /usr/lib/libstdc++.so ${_dir}/libstdc++.so
    #   ln -s libstdc++.so ${_dir}/libstdc++.so.6
    #   ln -s libstdc++.so ${_dir}/libstdc++.so.6.0.8
    #   ln -s /usr/lib/libstdc++.so.5 ${_dir}/libstdc++.so.5
    #   ln -s /usr/lib/libXm.so.4 ${_dir}/libXm.so.3
	  # done
  libPath = stdenv.lib.makeLibraryPath [
    ncurses5
    zlib
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    xorg.libX11
    xorg.libXext
    xorg.libXtst
    xorg.libXi
  ];
}
