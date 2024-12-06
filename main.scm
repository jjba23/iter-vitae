(use-modules (ice-9 getopt-long))

;; load base iter-vitae configuration
(load "./iter-vitae.scm")

;; choose configuration for wanted persona
;; (load "./populus/joe.scm")

(define (display-separator)
  (display "\n====================================================\n"))

(define* (begin-generation #:key locale persona)
  (display-separator)
  (display "\n\tstarting iter-vitae\n")
  (display (format #f "\n\tconfigured with locale: ~a" locale)) 
  (display (format #f "\n\tconfigured with persona: ~a" persona))
  (newline)
  (display-separator)
  (newline))

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
         (persona-wanted (option-ref options 'persona "joe"))
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



