(use-modules (guix gexp)
             (guix packages)
             (guix git-download)
             ((guix licenses) #:prefix license:)
             (guix build-system guile)
             ((guix build utils) #:select (with-directory-excursion))
             (gnu packages)
             (gnu packages guile)
             (gnu packages guile-xyz))


(define %source-dir (dirname (current-filename)))

(package
  (name "iter-vitae")
  (version "0.0.15")
  (source (local-file %source-dir
                      #:recursive? #t
                      #:select? (git-predicate %source-dir)))
  (arguments
    `(#:source-directory "src"
      #:phases
      (modify-phases %standard-phases
        (add-before 'build 'remove-guix.scm
                    (lambda _ (delete-file "guix.scm")))
         (add-before 'build 'install-shell-wrapper
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((bin (string-append (assoc-ref outputs "out")
                                "/bin")))
                        (install-file "iter-vitae" bin)
                        (chmod (string-append bin "/iter-vitae") #o755)))))))
  (build-system guile-build-system)
  (native-inputs (list guile-3.0))
  (inputs (list guile-3.0))
  (synopsis "Resume / Curriculum Vitae (CV) generator powered by Guile Scheme")
  (description "Generate an attractive, modern and customizable Curriculum Vitae (CV) / Resume by defining your life and career in S-expressions.")
  (home-page "https://codeberg.org/jjba23/iter-vitae")
  (license license:lgpl3+))


