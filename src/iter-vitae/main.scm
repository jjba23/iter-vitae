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
  #:declarative? #f
  #:use-module (ice-9 getopt-long)
  #:use-module (iter-vitae utils)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae html)
  #:use-module (iter-vitae tailwind))

(define-syntax-rule (get-setting setting)
  "Get a setting for iter-vitae, either from persona or from default values."
  (let* ((default (module-variable (resolve-module '(iter-vitae defaults))
                                   setting))
         (user-override (module-variable (resolve-module '(iter-vitae persona))
                                         setting)))
    (catch #t
           (lambda ()
             (if (equal? #f user-override)
                 (variable-ref default)
                 (variable-ref user-override)))
           (lambda (key . args)
             (variable-ref default)))))

(define (display-separator)
  (display "
====================================================
"))

(define* (begin-generation #:key locale persona-file)
  (display-separator)
  (display "\n\tstarting iter-vitae\n")
  (display (format #f "\n\tconfigured with locale: ~a" locale))
  (display (format #f "\n\tconfigured with persona-file: ~a" persona-file))
  (newline)
  (display-separator)
  (newline)

  ;; choose person to generate curriculum vitae for
  (load persona-file)

  (define p
    `((display-name unquote
                    (get-setting 'display-name))
      (job-title unquote
                 (get-setting 'job-title))
      (personal-contact unquote
                        (get-setting 'personal-contact))
      (personal-links unquote
                      (get-setting 'personal-links))
      (address-lines unquote
                     (get-setting 'address-lines))
      (driver-licenses unquote
                       (get-setting 'driver-licenses))
      (interests-hobbies unquote
                         (get-setting 'interests-hobbies))
      (languages unquote
                 (get-setting 'languages))
      (education unquote
                 (get-setting 'education))
      (titles unquote
              (get-setting 'titles))
      (short-intro unquote
                   (get-setting 'short-intro))
      (jobs unquote
            (get-setting 'jobs))
      (font unquote
            (get-setting 'font))
      (palette unquote
               (get-setting 'palette))))

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
          (begin-generation #:locale (string->symbol locale-wanted)
                            #:persona-file persona-file)))))

;; call main with command line arguments
;;
(main (command-line))

