;;; Iter Vitae 

;; Copyright (C) 2024 Josep Jesus Bigorra Algaba

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

(use-modules (ice-9 getopt-long))


(load "./src/utils.scm")
(load "./src/tailwind.scm")
(load "./src/html.scm")
;; load base iter-vitae configuration
(load "./src/iter-vitae.scm")

(define (display-separator)
  (display "\n====================================================\n"))

(define* (begin-generation #:key locale persona)
  (display-separator)
  (display "\n\tstarting iter-vitae\n")
  (display (format #f "\n\tconfigured with locale: ~a" locale)) 
  (display (format #f "\n\tconfigured with persona: ~a" persona))
  (newline)
  (display-separator)
  (newline)
  
  ;; choose person to generate curriculum vitae for
  (load (format #f "./populus/~a.scm" persona))
  
  (with-output-to-file "dist/index.html"
    (lambda()
      (display (iter-vitae-curriculum-page))
      ))
  )

(define (main args)
  (display args)
  (newline)
  (let* ((option-spec '((locale (single-char #\l) (value #t))
                        (version (single-char #\v) (value #f))
                        (help    (single-char #\h) (value #f))
                        (persona    (single-char #\p) (value #t) (required? #t))))
         
         (options (getopt-long args option-spec))
         
         (help-wanted (option-ref options 'help #f))
         (version-wanted (option-ref options 'version #f))
         (persona-wanted (option-ref options 'persona ""))
         (locale-wanted (option-ref options 'locale "en")))
    
    (if (or version-wanted help-wanted)
        (begin
          (if version-wanted
              (display "iter-vitae dev version\n"))
          (if help-wanted
              (display "\
iter-vitae [options]
  -l, --locale    Locale
  -p, --persona   Persona
  -v, --version   Version
  -h, --help      Help
")))
        (begin          
          (begin-generation
           #:locale locale-wanted
           #:persona persona-wanted)
          ))))


;; call main with command line arguments
;;
(main (command-line))



