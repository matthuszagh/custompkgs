{ stdenv, fetchFromGitHub, fetchurl
, autoconf, bison, glm, yacc, flex
, freeglut, ghostscriptX, imagemagick, fftw
, boehmgc, libGLU, libGL, mesa, ncurses, readline, gsl, libsigsegv
, python3Packages
, zlib, perl
, texLive, texinfo
, darwin
}:

stdenv.mkDerivation rec {
  version = "git";
  name = "asymptote-${version}";

  src = fetchFromGitHub {
    owner = "vectorgraphics";
    repo = "asymptote";
    rev = "24c7bcbc8b6e2e08938ab1fd088e922a0806251f";
    sha256 = "0bagixd9ksyz4553lwgjpjvpn2r21f0pkdaiazjkkbimlysh90sn";
  };

  buildInputs = [
    ghostscriptX imagemagick fftw
    boehmgc ncurses readline gsl libsigsegv
    zlib perl
    texLive
    texinfo
    autoconf
    bison
    flex
    yacc
  ] ++ (with python3Packages; [
    python
    pyqt5
  ]);

  propagatedBuildInputs = [
    glm
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    freeglut libGLU libGL mesa.osmesa
  ] ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    OpenGL GLUT Cocoa
  ]);

  preConfigure = ''
    HOME=$TMP
    ./autogen.sh
    configureFlags="$configureFlags \
      --with-latex=$out/share/texmf/tex/latex \
      --with-context=$out/share/texmf/tex/context/third"
  '';

  NIX_CFLAGS_COMPILE = [ "-I${boehmgc.dev}/include/gc" ];

  postInstall = ''
    # mv $out/share/info/asymptote/*.info $out/share/info/
    # sed -i -e 's|(asymptote/asymptote)|(asymptote)|' $out/share/info/asymptote.info
    # rmdir $out/share/info/asymptote
    # rm -f $out/share/info/dir

    rm -rf $out/share/texmf
    mkdir -p $out/share/emacs/site-lisp/${name}
    mv $out/share/asymptote/*.el $out/share/emacs/site-lisp/${name}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    version = "${version}";
    description =  "A tool for programming graphics intended to replace Metapost";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin maintainers.peti ];
    broken = stdenv.isDarwin;  # https://github.com/vectorgraphics/asymptote/issues/69
    platforms = platforms.linux ++ platforms.darwin;
  };
}
