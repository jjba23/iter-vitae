;;; Iter Vitae 

;; Copyright © Josep Jesus Bigorra Algaba

;; iter-vitae is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; iter-vitae is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

(define-module (iter-vitae main)
  #:declarative? #t
  #:use-module (ice-9 getopt-long)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae renderer)
  #:use-module (iter-vitae tailwind))

(define (main args)
  (display args)
  (newline)
  (let* ((option-spec '((locale (single-char #\l)
                                (value #t))
                        (version (single-char #\v)
                                 (value #f))
                        (help (single-char #\h)
                              (value #f))
                        (persona-file (single-char #\p)
                                      (value #t)
                                      (required? #t))))
         
         (options (getopt-long args option-spec))

         (help-wanted (option-ref options
                                  'help #f))
         (version-wanted (option-ref options
                                     'version #f))
         (persona-file (option-ref options
                                   'persona-file ""))
         (locale-wanted (option-ref options
                                    'locale "en")))
    
    (if (or version-wanted help-wanted)
        (begin
          (if version-wanted
              (display "iter-vitae dev version\n"))
          (if help-wanted
              (display "iter-vitae [options]
  -l, --locale         Locale
  -p, --persona-file   Persona file
  -v, --version        Version
  -h, --help           Help
")))
        (begin
          (render-curriculum #:locale (string->symbol locale-wanted)
                             #:persona-file persona-file)))))

;; call main with command line arguments
;;
(main (command-line))

