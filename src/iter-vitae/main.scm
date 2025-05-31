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
  #:use-module (iter-vitae utils)
  #:use-module (iter-vitae html)
  #:use-module (iter-vitae tailwind))

(define (display-separator)
  (display "
====================================================
"))

(define* (begin-generation #:key locale persona)
  (display-separator)
  (display "\n\tstarting iter-vitae\n")
  (display (format #f "\n\tconfigured with locale: ~a" locale))
  (display (format #f "\n\tconfigured with persona: ~a" persona))
  (newline)
  (display-separator)
  (newline)

  ;; load base iter-vitae configuration
  (load "../../iter-vitae-defaults.scm")

  ;; choose person to generate curriculum vitae for
  (load (format #f "../../populus/~a.scm" persona))

  (define p
    `((display-name unquote iter-vitae-display-name)
      (job-title unquote iter-vitae-job-title)
      (personal-contact unquote iter-vitae-personal-contact)
      (personal-links unquote iter-vitae-personal-links)
      (address-lines unquote iter-vitae-address-lines)
      (driver-licenses unquote iter-vitae-driver-licenses)
      (interests-hobbies unquote iter-vitae-interests-hobbies)
      (languages unquote iter-vitae-languages)
      (education unquote iter-vitae-education)
      (titles unquote iter-vitae-titles)
      (short-intro unquote iter-vitae-short-intro)
      (jobs unquote iter-vitae-jobs)
      (font unquote iter-vitae-font)
      (palette unquote iter-vitae-palette)))

  (write (assq-ref (assq-ref p
                             'personal-links)
                   'blog))

  (display-separator)
  (display "about to process persona:")
  (newline)
  (write p)
  (newline)

  (with-output-to-file "dist/index.html"
    (lambda ()
      (display (iter-vitae-curriculum-page #:locale locale
                                           #:persona p)))))

(define (main args)
  (display args)
  (newline)
  (let* ((option-spec '((locale (single-char #\l)
                                (value #t))
                        (version (single-char #\v)
                                 (value #f))
                        (help (single-char #\h)
                              (value #f))
                        (persona (single-char #\p)
                                 (value #t)
                                 (required? #t))))
         
         (options (getopt-long args option-spec))

         (help-wanted (option-ref options
                                  'help #f))
         (version-wanted (option-ref options
                                     'version #f))
         (persona-wanted (option-ref options
                                     'persona ""))
         (locale-wanted (option-ref options
                                    'locale "en")))
    
    (if (or version-wanted help-wanted)
        (begin
          (if version-wanted
              (display "iter-vitae dev version\n"))
          (if help-wanted
              (display "iter-vitae [options]
  -l, --locale    Locale
  -p, --persona   Persona
  -v, --version   Version
  -h, --help      Help
")))
        (begin
          (begin-generation #:locale (string->symbol locale-wanted)
                            #:persona (string->symbol persona-wanted))))))

;; call main with command line arguments
;;
(main (command-line))

