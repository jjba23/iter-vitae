(define-module (iter-vitae package)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system guile)
  #:use-module (gnu packages guile))

(package
  (name "iter-vitae")
  (version "0.2.16")
  (source
   (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://codeberg.org/jjba23/iter-vitae.git")
           (commit (string-append "v" version))))
     (sha256
      (base32 "0bhnly78kx08gdlrjqj0aczkp1l8ia3nwm9yap7vdzyxvkga52sp"))
     (file-name (git-file-name name version))))
  (build-system guile-build-system)
  (arguments
   '(#:source-directory "src"
     #:phases (modify-phases %standard-phases
                (add-after 'unpack 'install-entrypoint
                  (lambda* (#:key inputs #:allow-other-keys)
                    (let* ((bin (assoc-ref outputs "out") "/bin"))
                      (install-file "resources/iter-vitae-entry.sh" bin)))))))
  (native-inputs (list guile-3.0))
  (home-page "https://codeberg.org/jjba23/iter-vitae")
  (synopsis "Resume / Curriculum Vitae (CV) generator written in Guile Scheme")
  (description
   "Generate an attractive, modern and customizable Curriculum Vitae or resume for yourself and
 to allow you to define the course of your life and career directly in Guile Scheme code.")
  (license license:gpl3+))
