;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(use-modules (guix gexp)
             (guix packages)
             (guix git-download)
             ((guix licenses)
              #:prefix license:)
             (guix build-system guile)
             ((guix build utils)
              #:select (with-directory-excursion ))
             (gnu packages)
             (gnu packages base)
             (gnu packages bash)
             (gnu packages guile)
             (gnu packages guile-xyz)
             (gnu packages linux))

(define %source-dir
  (dirname (current-filename)))

(define-public iter-vitae
  (package
    (name "iter-vitae")
    (version "dev")
    (source
     (local-file %source-dir
                 #:recursive? #t
                 #:select? (git-predicate %source-dir)))
    (build-system guile-build-system)
    (arguments
     (list
      #:source-directory "src"
      #:modules '((guix build guile-build-system)
                  (guix build utils)
                  (ice-9 match))
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'install-program-files
            (lambda _
              (let ((bin (string-append #$output "/bin"))
                    (share (string-append #$output "/share")))
                (install-file "resources/help.txt"
                              (string-append share "/resources/"))
                (install-file "resources/css/iter-vitae.olive.min.css"
                              (string-append share "/resources/css"))
                (install-file "resources/css/fatum.olive.min.css"
                              (string-append share "/resources/css"))
                (install-file "scripts/iter-vitae" bin)
                (chmod (string-append bin "/iter-vitae") #o755))))
          (add-after 'unpack 'fix-paths
            (lambda* (#:key inputs #:allow-other-keys)
              (for-each (match-lambda
                          ((pattern program format-string)
                           (substitute* "scripts/iter-vitae"
                             ((pattern)
                              (format #f format-string
                                      (search-input-file inputs
                                                         (string-append "bin/"
                                                          program)))))))
                        '(("readlink -f " "readlink" "~s -f ")
                          ("realpath " "realpath" "~s ")
                          ("dirname " "dirname" "~s ")
                          ("getopt " "getopt" "~s ")
                          ("exec guile " "guile" "exec ~s "))))))))
    (inputs (list guile-3.0 bash-minimal coreutils util-linux))
    (synopsis
     "Resume / @acronym{CV, Curriculum Vitae} generator written in Guile Scheme")
    (description
     "Iter Vitae is a command-line utility that allows you to generate a
Resume / @acronym{CV, Curriculum Vitae}, by reading a S-expression version
of your CV details (in Scheme code).

With a @acronym{MVC, model-view-controller} approach,
it lets you separate the data from the presentation (how the document looks).

This tool creates a web-site version of your CV (using SXML and Olive CSS),
and is designed for long-term use, so you can update and evolve your CV over the years.
The program supports multilingual content and is fully extensible.")
    (home-page "https://codeberg.org/jjba23/iter-vitae")
    (license license:expat)))

iter-vitae
