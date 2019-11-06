{ stdenv, pkgs }:

let
  custompkgs = import <custompkgs> {};

  # TODO how can I include man and info pages?
  # searchPath = stdenv.lib.makeSearchPath "share" (with pkgs; [
  #   # documentation
  #   clang-manpages
  #   llvm-manpages
  #   stdman # cppreference manpages
  #   stdmanpages
  #   posix_man_pages
  #   glibcInfo
  # ]);

  # perl-with-packages = pkgs.perl.withPackages(p: with p; [
  #   RPCEPCService
  #   DBI
  #   DBDPg
  # ]);

  binPath = stdenv.lib.makeBinPath (with pkgs; [
    ## programming
    # C / C++
    gdb
    clang-tools
    clang-analyzer
    bear
    # Python
    python3Packages.python-language-server
    python3Packages.black
    python3
    # hdl
    verilator
    # bash
    # TODO add bash-language-server to nixpkgs
    # tex/latex
    # TODO add digestif (LSP, github: astoff/digestif) to nixpkgs
    # fortran
    # TODO add fortran-language-server (github: hansec/fortran-language-server) to nixpkgs
    # rust
    rustc
    rls
    rustfmt
    cargo
    # tex
    # TODO data folders wrong location
    # lua53Packages.digestif

    # search
    ripgrep
    recoll

    # math / science
    # TODO emacs wrapping problem
    # sageWithDoc

    # mail
    # TODO fix
    # notmuch

    # utilities
    imagemagick
    ispell
    gnome3.gnome-terminal

    # needed for edbi
    # perl-with-packages
    # perlPackages.RPCEPCService
    # perlPackages.DBI
    # perlPackages.DBDPg

    # GUI
    #
    # Graphical applications are bundled with Emacs because I use
    # Emacs as my window manager. If a new graphical environment
    # is setup, such as a desktop manager, these programs can be
    # copied there as well.
    next
    gsettings-desktop-schemas # needed with next
    # next-gtk-webkit
    anki
    vlc
  ] ++ (with custompkgs; [
    sbcl
    brainworkshop
  ]));

  emacs-wrapped-with-packages = (pkgs.emacsPackagesGen pkgs.emacs).emacsWithPackages (epkgs: (with epkgs.elpaPackages; [
      aggressive-indent
      auctex
      exwm
      debbugs
      org-edna
      undo-tree
    ]) ++ (with epkgs.melpaPackages; [
      alert
      auctex-latexmk
      company
      # faster, more predictable completion searching
      prescient
      company-prescient
      clang-format
      flycheck-clang-analyzer
      helm-exwm
      emms
      pulseaudio-control

      # programming
      cmake-mode
      cmake-font-lock
      elpy
      py-autopep8
      blacken
      yapfify
      sage-shell-mode
      ob-sagemath
      python-info
      rust-mode
      # a compiler explorer-like implementation in Emacs.
      rmsbolt
      # automatically compile outdated elisp files
      auto-compile

      # vim-like integration
      evil
      evil-collection
      evil-surround
      evil-magit
      evil-numbers # increment and decrement numbers at point

      cask
      cask-mode
      flycheck-cask
      emr
      elsa
      flycheck
      flycheck-elsa
      wgrep
      dumb-jump
      realgud

      edbi # Database viewer

      paradox
      general
      git-gutter
      git-timemachine
      github-notifier
      helm
      helm-descbinds
      helm-eww
      helm-org-rifle
      helm-projectile
      helm-recoll
      helm-systemd
      helm-rg
      helm-org
      helpful
      ht
      sx
      elfeed

      notmuch
      helm-notmuch
      ledger-mode
      flycheck-ledger
      evil-ledger

      # shell
      bash-completion
      fish-completion

      # lsp
      lsp-mode
      lsp-ui
      company-lsp
      ccls

      # writing
      writegood-mode
      define-word

      magit
      magithub
      markdown-mode
      multiple-cursors
      nix-mode
      nix-update
      direnv
      no-littering
      nov
      org-board
      # poly-org
      # polymode
      projectile
      rainbow-delimiters
      scad-mode
      slime
      slime-company
      smart-mode-line
      spaceline
      sourcerer-theme
      symon
      transient
      use-package
      which-key
      x86-lookup
      yasnippet
    ]) ++ (with epkgs.orgPackages; [
      org
      # TODO how do I do this? Maybe make it a custom package?
      # see this link for patch https://www.mail-archive.com/emacs-orgmode@gnu.org/msg121966.html
      # (org.overrideAttrs (attrs: { patches = [ ./org.patch ]; }))
      org-plus-contrib
    ]) ++ (with epkgs; [
      pdf-tools
    ]) ++ (with custompkgs; [
      org-recoll
      layers
      justify-kp
    ]));
in
pkgs.symlinkJoin {
  name = "emacs-wrapped";
  paths = with pkgs; [
    emacs-wrapped-with-packages
  ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram "$out""/bin/emacs" \
      --suffix PATH : "${binPath}"
  '';
  inherit (pkgs.emacs) meta;
}
