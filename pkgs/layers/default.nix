{stdenv, fetchFromGitHub, emacs}:

stdenv.mkDerivation rec {
  name = "org-recoll";

  src = /home/matt/src/layers;

  buildInputs = [ emacs ];

  # buildPhase = ''
  #   emacs -L . --batch -f batch-byte-compile *.el
  # '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Dependency management for package collections.";
    homepage = https://github.com/matthuszagh/layers;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
