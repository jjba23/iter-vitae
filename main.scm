(use-modules (ice-9 getopt-long))

;; load base iter-vitae configuration
(load "./iter-vitae.scm")

;; choose configuration for wanted persona
;; (load "./populus/joe.scm")

(define* (begin-generation #:key locale persona)
  (display "\niter-vitae working\n") (newline)
  )

(define (main args)
  (display args)
  (newline)
  (let* ((option-spec '((locale (single-char #\l) (value "en"))
                        (version (single-char #\v) (value #f))
                        (help    (single-char #\h) (value #f))
                        (persona    (single-char #\p) (required? #t))))
         (options (getopt-long args option-spec))
         (help-wanted (option-ref options 'help #f))
         (version-wanted (option-ref options 'version #f))
         (persona-wanted (option-ref options 'persona #f))
         (locale-wanted (option-ref options 'locale #f)))
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
          (display locale-wanted) (newline)
          (display persona-wanted) (newline)
          (display options) (newline)
          
          (begin-generation
           #:locale locale-wanted
           #:persona persona-wanted)
          ))))


(main (command-line))



