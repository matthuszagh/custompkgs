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

  binPath = stdenv.lib.makeBinPath (with pkgs; [
    ## programming
    # C / C++
    gdb
    clang-tools
    clang-analyzer
    bear
    # Python
    python3Packages.python-language-server
    python3
    # hdl
    verilator

    # search
    ripgrep
    recoll

    # math / science
    sage

    # mail
    notmuch

    # utilities
    imagemagick
    ispell
    gnome3.gnome-terminal

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
      clang-format
      flycheck-clang-analyzer
      helm-exwm
      emms
      pulseaudio-control

      cmake-mode
      cmake-font-lock
      elpy
      py-autopep8
      blacken
      yapfify
      sage-shell-mode
      ob-sagemath
      python-info

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
      sourcerer-theme
      symon
      transient
      use-package
      which-key
      writegood-mode
      x86-lookup
      yasnippet
    ]) ++ (with epkgs.orgPackages; [
      org
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
