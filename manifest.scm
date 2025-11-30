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

(use-modules (guix packages)
             (gnu)
             (guix utils)
             (guix git-download)
             (guix download)
             (gnu packages guile)
             (gnu packages nss)
             (gnu packages admin)
             (gnu packages web)
             (gnu packages gnupg)
             (gnu packages guile-xyz)
             (gnu packages pkg-config)
             (guix build-system guile)
             (gnu packages linux)
             (gnu packages compression)
             (gnu packages texinfo)
             (gnu packages autotools)
             ((guix licenses)
              #:prefix license:))

(define-public guile-kracht
  (package
    (name "guile-kracht")
    (version "0.2.20")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/kracht.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0hqaibs34dls8z6rzs3hh9blbjqllvlsp9h45g2i2n3mfvd9hp8m"))))
    (build-system guile-build-system)
    (native-inputs (list guile-3.0))
    (arguments
     (list
      #:source-directory "src"))
    (home-page "https://codeberg.org/jjba23/kracht")
    (synopsis
     "Utility methods and functionalities for Guile Scheme programming")
    (description
     "Kracht provides helpful and convenient functionalities that can help you
develop more comfortably in your Guile Scheme project. You can see it as a
batteries-included addition to the (already great) standard library
of Guile Scheme, complementing it, and helping developers write cleaner,
more efficient, and more powerful code.")
    (license license:lgpl3+)))


(packages->manifest (list (specification->package "make")
                          guile-next
                          darkhttpd
                          direvent
                          guile-kracht
                          texinfo
                          guile-documenta
                          guile-ares-rs))

