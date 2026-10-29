;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae main)
  #:declarative? #t
  #:use-module (ice-9 getopt-long)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae renderer)
  #:use-module (iter-vitae wizard)
  #:export (main))

(define* (main #:key (args (command-line)))
  (let* ((option-spec '((locale (single-char #\l)
                                (value #t))
                        (destination (single-char #\o)
                                     (value #t))
                        (resources (single-char #\r)
                                   (value #t))
                        (format (single-char #\F)
                                (value #t))
                        (init (single-char #\i))
                        (all-locales)
                        (locales (value #t))
                        (file (single-char #\p)
                              (value #t))))

         (options (getopt-long args option-spec))
         (file (option-ref options
                           'file #f))
         (destination (option-ref options
                                  'destination "./dist"))
         (resources (option-ref options
                                'resources #f))
         (format (option-ref options
                             'format "html"))
         (locale (option-ref options
                             'locale "en"))
         (locales (option-ref options 'locales #f))
         (all-locales? (option-ref options 'all-locales #f))
         (init (option-ref options 'init #f)))
    (log-info
     "Iter Vitae: Generate an attractive, modern and customizable Curriculum Vitae/Resume")
    (if init
        (run-wizard #:file (or file "./my-cv.scm")
                    #:locale (string->symbol locale)
                    #:locales locales)
        (begin
          (unless file
            (error "The --file option is required (or use --init to create a persona)"))
          (render-curriculum #:locale (string->symbol locale)
                             #:destination destination
                             #:resources resources
                             #:format format
                             #:all-locales? all-locales?
                             #:file file)))))
