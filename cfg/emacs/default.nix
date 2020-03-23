{ ... }:
let
  emacs-overlay = import ./emacs-overlay;
  unstable = import <unstable> { overlays = [ emacs-overlay ]; };
  emacs-overrides = self: super: rec { seq = null; };
in {
  home.packages = (with unstable.pkgs;
    [
      (((emacsPackagesGen emacsGit).overrideScope'
        emacs-overrides).emacsWithPackages (epkgs:
          (with epkgs.melpaPackages; [
            # Vi layer.
            evil
            evil-collection
            # Keybindings.
            general
            which-key
            projectile
            # Debugging.
            dap-mode
            # Modes.
            ## Rust.
            rust-mode
            ## Magma.
            magma-mode
            ## Javascript.
            prettier-js
            ## Python.
            blacken
            # Highlight long columns.
            column-enforce-mode
            # Files.
            dired-rainbow
            dired-subtree
          ]) ++ (with epkgs.melpaStablePackages; [
            # Vcs.
            magit
            # Package loading.
            use-package
            # Modeline.
            moody
            minions
            # Themes.
            zenburn-theme
            solarized-theme
            monokai-theme
            all-the-icons
            # Files.
            neotree
            # Modes.
            markdown-mode
            nix-mode
            haskell-mode
            yaml-mode
            ## R.
            ess
            ess-R-data-view
            # Movement.
            drag-stuff
            # Search and completion.
            ivy
            swiper
            counsel
            avy
            yasnippet
            # Scheduling.
            org-super-agenda
          ]) ++ (with epkgs.elpaPackages; [ org eglot company auctex ])))
    ]);
}
