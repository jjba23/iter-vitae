;;; Iter Vitae 

;; Copyright © Josep Jesus Bigorra Algaba

;; iter-vitae is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; iter-vitae is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public License
;; along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

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
    (version "dev")
    (source
     (local-file %source-dir
                 #:recursive? #t
                 #:select? (git-predicate %source-dir)))
    (arguments
     `(#:source-directory "src"
       #:phases (modify-phases %standard-phases
                  (add-before 'build 'install-program-files
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((bin (string-append (assoc-ref outputs "out")
                                                "/bin"))
                            (share (string-append (assoc-ref outputs "out")
                                                  "/share")))
                        (install-file "resources/help.txt"
                                      (string-append share "/resources/"))
                        (install-file "resources/css/iter-vitae.olive.min.css"
                                      (string-append share "/resources/css"))
                        (install-file "scripts/iter-vitae" bin)
                        (install-file "scripts/log.bash"
                                      (string-append share "/scripts/"))
                        (chmod (string-append bin "/iter-vitae") #o755)))))))
    (build-system guile-build-system)
    (native-inputs (list guile-3.0))
    (inputs (list guile-3.0 bash-minimal))
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
    (license license:agpl3+)))

iter-vitae

