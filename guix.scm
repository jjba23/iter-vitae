(use-modules (guix gexp)
             (guix packages)
             (guix git-download)
             ((guix licenses)
              #:prefix license:)
             (guix build-system guile)
             ((guix build utils)
              #:select (with-directory-excursion ))
             (gnu packages)
             (gnu packages bash)
             (gnu packages guile)
             (gnu packages guile-xyz))

(define %source-dir
  (dirname (current-filename)))

(define-public iter-vitae
  (package
    (name "iter-vitae")
    (version "0.3.26")
    (source
     (local-file %source-dir
               #:recursive? #t
               #:select? (git-predicate %source-dir))
     ;; (origin
     ;;   (method git-fetch)
     ;;   (uri (git-reference
     ;;         (url "https://codeberg.org/jjba23/iter-vitae.git")
     ;;         (commit (string-append "v" version))))
     ;;   (file-name (git-file-name name version))
     ;;   (sha256
     ;;    (base32 "053i58l23dlmsn8vwsxbvmwn036jjygf878rhbshj31zdwaxka4h"))
     ;;   (modules '((guix build utils)))
     ;;   (snippet '(begin
     ;;               ;; delete irrelevant files for package installation
     ;;               (delete-file "guix.scm")
     ;;               (delete-file "manifest.scm")
     ;;               (delete-file "Makefile")
     ;;               (delete-file "README.org")
     ;;               (delete-file "COPYING")
     ;;               (delete-file ".gitignore")
     ;;               (delete-file ".guix-channel")
     ;;               (delete-file ".guix-authorizations")
     ;;               (delete-file-recursively "populus")
     ;;               (delete-file-recursively ".woodpecker"))))
     )
    (arguments
     `(#:source-directory "src"
       #:phases (modify-phases %standard-phases
                  (add-before 'build 'install-program-files
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((bin (string-append (assoc-ref outputs "out")
                                                "/bin"))
                            (share (string-append (assoc-ref outputs "out")
                                                  "/share")))
                        (mkdir-p (string-append share "/scripts"))
                        (mkdir-p (string-append share "/resources"))
                        (install-file "resources/help.txt"
                                      (string-append share
                                                     "/resources/help.txt"))
                        (copy-recursively "resources/js"
                                          (string-append share "/resources/js"))
                        (install-file "scripts/iter-vitae" bin)
                        (install-file "scripts/log.sh"
                                      (string-append share "/scripts/"))
                        (chmod (string-append bin "/iter-vitae") #o755)))))))
    (build-system guile-build-system)
    (native-inputs (list guile-3.0))
    (inputs (list guile-3.0 bash-minimal))
    (synopsis
     "Resume / @acronym{CV, Curriculum Vitae} generator powered by HTML, SXML and Guile Scheme")
    (description
     "Iter Vitae is a command-line utility that allows you togenerate an attractive,
modern and customizable Resume / @acronym{CV, Curriculum Vitae},
where you define all your details in S-expressions (in Scheme code).
With a @acronym{MVC, model-view-controller} approach,
it lets you separate the data from the presentation (how the document looks).

This tool creates a web-site version of your CV (using SXML and TailwindCSS),
and is designed for long-term use, so you can update and evolve your CV over the years.

The software supports multilingual content and is fully extensible, allowing you to
add new data entries, customize the design, and easily support additional languages.

Everyone has the right to create a professional-looking Resume/CV,
using free software and with total freedom.")
    (home-page "https://codeberg.org/jjba23/iter-vitae")
    (license license:agpl3+)))

iter-vitae

