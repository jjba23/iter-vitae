;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; Test support: fixtures, temporary directories and a subprocess runner.  This
;; module lives beside the unit tests rather than inside them, so the Veritas
;; runner does not try to execute it as a test file.

(define-module (veritas support)
  #:declarative? #t
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 format)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae prelude)
  #:export (project-root
            make-temp-dir
            call-with-temp-dir
            write-file
            run-guile
            make-resources
            sample-persona
            rich-persona
            bilingual-persona
            with-theme
            persona-file
            expect-true
            expect-equal
            expect-contains
            expect-not-contains))

;; The Veritas runner is documented to be started from the repository root, and
;; the subprocess tests rely on the same convention.
(define (project-root)
  (getcwd))

(define (make-temp-dir)
  (mkdtemp "/tmp/iter-vitae-test-XXXXXX"))

(define (call-with-temp-dir proc)
  "Call @var{proc} with a fresh temporary directory and remove it afterwards."
  (let ((dir (make-temp-dir)))
    (dynamic-wind
      (lambda () #t)
      (lambda () (proc dir))
      (lambda ()
        (catch #t
               (lambda () (delete-file-tree dir))
               (lambda args #t))))))

(define (write-file path contents)
  "Write @var{contents} to @var{path}, creating parent directories first."
  (make-directories (dirname path))
  (call-with-output-file path
    (lambda (port) (display contents port)))
  path)

;; ---------------------------------------------------------------------------
;; Expectations for dynamic tests
;;
;; Veritas records one result per procedure-valued test case, so a case lambda
;; that calls several assertions only keeps the last one.  Tests that have to
;; set state up at run time use `assert-no-error' around a thunk built from these
;; expectations instead: the first unmet expectation raises and fails the test.
;; ---------------------------------------------------------------------------

(define (expect-true condition message)
  (unless condition
    (error (format #f "~a: expected a true value" message))))

(define (expect-equal expected actual message)
  (unless (equal? expected actual)
    (error (format #f "~a: expected ~s, got ~s" message expected actual))))

(define* (expect-contains haystack needle #:optional (message "substring"))
  (unless (and (string? haystack) (string-contains haystack needle))
    (error (format #f "~a: expected ~s in the rendered output"
                   message needle))))

(define* (expect-not-contains haystack needle #:optional (message "substring"))
  (when (and (string? haystack) (string-contains haystack needle))
    (error (format #f "~a: did not expect ~s in the rendered output"
                   message needle))))

(define* (run-guile #:rest args)
  "Run Guile with @var{args} and return (values exit-status stdout)."
  (let* ((port (apply open-pipe* OPEN_READ
                      "guile"
                      "-L" (in-vicinity (project-root) "src")
                      args))
         (output (get-string-all port))
         (status (close-pipe port)))
    (values (status:exit-val status) output)))

;; ---------------------------------------------------------------------------
;; Resource fixtures
;; ---------------------------------------------------------------------------

(define* (make-resources dir
                         #:key (ef-marker ".ef-test-marker > span { color: red; }")
                         (fatum-marker ".fatum-test-marker > span { color: green; }"))
  "Create a tiny resource tree at @var{dir} and return it."
  (write-file (in-vicinity (in-vicinity dir "css")
                           "iter-vitae.olive.min.css")
              (format #f "/* ef */\n~a\n" ef-marker))
  (write-file (in-vicinity (in-vicinity dir "css")
                           "fatum.olive.min.css")
              (format #f "/* fatum */\n~a\n" fatum-marker))
  dir)

;; ---------------------------------------------------------------------------
;; Persona fixtures
;; ---------------------------------------------------------------------------

(define sample-persona
  `((display-name . ((all . "Ada Lovelace")))
    (job-title . ((en . "Engineer") (nl . "Ingenieur")))
    ;; A bare host: themes must normalize it to an absolute URL.
    (job-title-link . ((all . "example.org/job")))
    (personal-contact . ((emails . "ada@example.org")
                         (phone-numbers . "+31 6 1234 5678")))
    (personal-links . ((blog . "blog.example.org")
                       (code . "https://codeberg.org/ada")))
    (address-lines . (((all . "Main Street 1"))))
    (driver-licenses . ())
    (interests-hobbies . ())
    (languages . ())
    (language-proficiency . ())
    (education . ())
    (titles . ,titles)
    (short-intro . (((all . "I write software."))))
    (skills . ())
    (jobs . ())
    (document-theme . ef-cyprus)))

(define bilingual-persona
  `((display-name . ((en . "Ada Example") (nl . "Ada Voorbeeld")))
    (job-title . ((en . "Engineer") (nl . "Ingenieur")))
    (personal-contact . ((emails . "ada@example.org")))
    (address-lines . (((en . "Main Street 1") (nl . "Hoofdstraat 1"))))
    (short-intro . (((en . "I write software.")
                     (nl . "Ik schrijf software."))))
    (jobs . (((name . ((en . "Acme") (nl . "Acme")))
              (location . ((en . "Amsterdam") (nl . "Amsterdam")))
              (position . ((en . "Engineer") (nl . "Ingenieur")))
              (time . ((en . "2020 - now") (nl . "2020 - nu")))
              (experience . (((en . "Built things") (nl . "Bouwde dingen")))))))
    (document-theme . ef-cyprus)))

(define rich-persona
  `((display-name . ((all . "Ada &amp; Bob &lt;CEO&gt;")))
    (profile-picture . "https://example.org/ada.png")
    (job-title . ((all . "Engineer")))
    ;; A bare host: themes must normalize it to an absolute URL.
    (job-title-link . ((all . "example.org/job")))
    (personal-contact . ((emails . "ada@example.org")
                         (phone-numbers . "+31 6 1234 5678")))
    (personal-links . ((blog . "blog.example.org")
                       (code . "https://codeberg.org/ada")
                       (linked-in . "linkedin.com/in/ada")))
    (address-lines . (((all . "Main Street 1"))
                      ((all . "Testville"))))
    (driver-licenses . (((all . "B"))
                        ((all . "A"))))
    (interests-hobbies . (((all . "Testing"))
                          ((all . "Lisp"))))
    (languages . ((en (name (en . "English")
                            (nl . "Engels"))
                      (proficiency (reading . 5)
                                   (speaking . 3)
                                   (writing . 5)))
                  (nl (name (en . "Dutch")
                            (nl . "Nederlands"))
                      (proficiency (reading . 3)
                                   (speaking . 3)
                                   (writing . 2)))))
    (language-proficiency . ((en (1 . "Elementary")
                                 (2 . "Basic")
                                 (3 . "Professional")
                                 (4 . "Full professional")
                                 (5 . "Native"))
                             (nl (1 . "Elementair")
                                 (2 . "Beperkt")
                                 (3 . "Professioneel")
                                 (4 . "Volledig professioneel")
                                 (5 . "Moedertaal"))))
    (education . (((name . ((all . "Test University")))
                   (location . ((all . "Testville")))
                   (position . ((all . "BSc")))
                   (time . ((all . "2010 - 2014")))
                   (experience . (((all . "Graduated with honors")))))))
    (titles . ,titles)
    (short-intro . (((all . "Hello &amp; welcome"))))
    (skills . (((all . "Scala"))
               ((all . "Kubernetes"))
               ((all . "PostgreSQL"))))
    (jobs . (((name . ((all . "Acme")))
              (location . ((all . "Remote")))
              (position . ((all . "Engineer")))
              (time . ((all . "2020 - now")))
              (experience . (((all . "Built things"))
                             ((all . "Wrote tests")))))))
    (document-theme . fatum)))

(define* (with-theme persona theme)
  "Return @var{persona} with its document theme replaced by @var{theme}."
  (cons (cons 'document-theme theme)
        (filter (lambda (pair)
                  (not (eq? (car pair) 'document-theme)))
                persona)))

(define (persona-file path persona)
  "Write @var{persona} as a loadable @code{(iter-vitae persona)} module."
  (write-file
   path
   (with-output-to-string
     (lambda ()
       (display "(define-module (iter-vitae persona)\n  #:declarative? #t)\n")
       (for-each (lambda (pair)
                   (format #t "(define ~a '~s)~%"
                           (car pair)
                           (cdr pair)))
                 persona)))))
