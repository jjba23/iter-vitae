;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (veritas unit iter-vitae wizard)
  #:declarative? #t
  #:use-module (veritas veritas)
  #:use-module (srfi srfi-11)
  #:use-module (ice-9 textual-ports)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae wizard)
  #:use-module (veritas support)
  #:export (spec))

;; Answers for a persona with a name, a job title and nothing else: the link,
;; theme, contact, links, address, summary and skills are skipped, as are the
;; three repeated sections (jobs, education, languages).
(define minimal-prefix
  (string-append
   "Ada Example\n"
   "Software Engineer\n"
   "\n\n\n\n\n\n\n\n\n\n"
   "n\nn\nn\n"
   "\n\n"
   ;; Keep the default section headings.
   "n\n"))

(define minimal-answers
  (string-append minimal-prefix
                 ;; Confirm writing the file.
                 "y\n"))

(define* (run-wizard-with-input input file #:key (locales '(en)))
  (with-input-from-string
      input
    (lambda ()
      (with-output-to-string
        (lambda ()
          (run-wizard #:file file #:locales locales))))))

(define (read-file path)
  (call-with-input-file path get-string-all))

;; Name and job title are translated, everything else is skipped.  The link
;; and theme questions are answered with the blank line after the titles.
(define multi-answers
  (string-append
   "Ada Example\n"
   "Ada Voorbeeld\n"
   "Software Engineer\n"
   "Softwareontwikkelaar\n"
   "\n\n"
   "\n"
   "\n\n"
   "\n\n\n"
   "\n"
   "\n"
   "\n"
   "n\nn\nn\n"
   "\n"
   "\n"
   "n\n"
   "y\n"))

(define wizard-suite
  (suite "persona wizard"
         #:concurrent? #f
         (test "writes a persona the renderer can load"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((file (in-vicinity root "persona.scm"))
                            (destination (in-vicinity root "dist"))
                            (output (run-wizard-with-input minimal-answers file)))
                       (expect-true (file-exists? file) "persona file")
                       (expect-not-contains output "\033["
                                              "ANSI escape in a redirected transcript")
                       (expect-contains output "👤" "emoji section marker")
                       (expect-not-contains output "--all-locales"
                                             "all-locales hint for a single-language persona")
                       (let ((source (read-file file)))
                         (expect-contains source
                                          "(define-module (iter-vitae persona)"
                                          "module")
                         (expect-contains source "Ada Example" "name")
                         (expect-contains source "Software Engineer" "title")
                         (expect-contains source "(define display-name"
                                          "name field")
                         (expect-contains source
                                          "(en . \"Ada Example\")"
                                          "translated name")
                         (expect-not-contains source "(all ."
                                              "language-independent fallback")
                         (expect-contains source
                                          "(define document-theme 'ef-cyprus)"
                                          "default theme")
                         ;; Optional sections the user skipped stay out of the
                         ;; file instead of being written empty.
                         (expect-not-contains source "personal-contact"
                                              "skipped contact"))
                       (let-values (((status output)
                                     (run-guile
                                      "-c"
                                      (format #f
                                              "((@(iter-vitae renderer) render-curriculum) #:locale 'en #:destination ~s #:resources ~s #:format \"html\" #:file ~s)"
                                              destination
                                              (in-vicinity (project-root)
                                                           "resources")
                                              file))))
                         (expect-equal 0 status "render status")
                         (expect-contains
                          (read-file (in-vicinity destination "index.html"))
                          "Ada Example"
                          "rendered name"))))))))
         (test "parses and validates locale lists"
               (assert-no-error
                (lambda ()
                  (expect-equal '("en" "nl") (parse-locales "en, nl")
                                "parsed locales")
                  (expect-equal '("en" "nl") (parse-locales "en,nl,en")
                                "deduplicated locales")
                  (expect-equal #f (parse-locales "en, all")
                                "all is not a locale")
                  (expect-equal #f (parse-locales "")
                                "empty locale list"))))
         (test "asks for the languages when --locales is absent"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((file (in-vicinity root "persona.scm"))
                            (output
                             (with-input-from-string
                                 (string-append "en\n" minimal-answers)
                               (lambda ()
                                 (with-output-to-string
                                   (lambda ()
                                     (run-wizard #:file file)))))))
                       (expect-true (file-exists? file) "persona file")
                       (expect-contains output "CV languages"
                                        "language question")
                       (expect-contains output "Selected:"
                                        "chosen languages")))))))
         (test "writes translations and renders the selected locale"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((file (in-vicinity root "persona.scm"))
                            (destination (in-vicinity root "dist"))
                            (output (run-wizard-with-input
                                     multi-answers file
                                     #:locales '(en nl))))
                       (let ((source (read-file file)))
                         (expect-contains source
                                          "(nl . \"Ada Voorbeeld\")"
                                          "translated name")
                         (expect-contains source
                                          "(nl . \"Softwareontwikkelaar\")"
                                          "translated title")
                         (expect-not-contains source "(all ."
                                              "language-independent fallback"))
                       (expect-contains output "iter-vitae --all-locales --file"
                                        "all-locales hint for a multi-language persona")
                       (expect-not-contains output "Render another translation"
                                             "single-locale follow-up hint")
                       (let-values (((status output)
                                     (run-guile
                                      "-c"
                                      (format #f
                                              "((@(iter-vitae renderer) render-curriculum) #:locale 'nl #:destination ~s #:resources ~s #:format \"html\" #:file ~s)"
                                              destination
                                              (in-vicinity (project-root)
                                                           "resources")
                                              file))))
                         (expect-equal 0 status "Dutch render status")
                         (let ((html (read-file
                                      (in-vicinity destination "index.html"))))
                           (expect-contains html "Ada Voorbeeld"
                                            "Dutch name")
                           (expect-contains html "Softwareontwikkelaar"
                                            "Dutch title")))))))))
         (test "writes translated lists, jobs and language names"
               (assert-no-error
                (lambda ()
                  (let* ((persona
                          `((display-name . ((en . "Ada") (nl . "Ada")))
                            (job-title . ((en . "Engineer")
                                          (nl . "Ingenieur")))
                            (address-lines . (((en . "Main Street")
                                               (nl . "Hoofdstraat"))))
                            (short-intro . (((en . "Hello")
                                             (nl . "Hallo"))))
                            (skills . (((en . "Python")
                                        (nl . "Python"))))
                            (jobs . (((name . ((en . "Acme")
                                               (nl . "Acme")))
                                      (location . ((en . "Amsterdam")
                                                   (nl . "Amsterdam")))
                                      (position . ((en . "Engineer")
                                                   (nl . "Ingenieur")))
                                      (time . ((en . "2020")
                                               (nl . "2020")))
                                      (experience . (((en . "Built")
                                                      (nl . "Bouwde")))))))
                            (languages . ((en . ((name . ((en . "English")
                                                          (nl . "Engels")))
                                                  (proficiency . ((reading . 4)
                                                                  (speaking . 4)
                                                                  (writing . 4)))))))
                            (document-theme . ats)))
                         (source (persona-source persona #:locales '(en nl))))
                    (expect-contains source "(nl . \"Bouwde\")"
                                     "translated bullet")
                    (expect-contains source
                                     "(name . ((en . \"English\") (nl . \"Engels\")))"
                                     "translated language name")
                    (expect-contains source
                                     "(nl (1 . \"Elementaire vaardigheid\")"
                                     "Dutch proficiency labels")
                    (expect-not-contains source "(all ."
                                        "language-independent fallback")
                    (call-with-temp-dir
                     (lambda (root)
                       (let* ((file (in-vicinity root "persona.scm"))
                              (destination (in-vicinity root "dist")))
                         (write-file file source)
                         (let-values
                             (((status output)
                               (run-guile
                                "-c"
                                (format #f
                                        "((@(iter-vitae renderer) render-curriculum) #:locale 'nl #:destination ~s #:resources ~s #:format \"html\" #:file ~s)"
                                        destination
                                        (in-vicinity (project-root)
                                                     "resources")
                                        file))))
                           (expect-equal 0 status "ATS render status")
                           (let ((html (read-file
                                        (in-vicinity destination "index.html"))))
                             (expect-contains html "Bouwde"
                                              "translated ATS bullet")
                             (expect-contains html "Engels"
                                              "translated language name")
                             (expect-contains html "Professioneel"
                                              "Dutch proficiency labels"))))))))))
         (test "does not write when the user declines at the summary"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let ((file (in-vicinity root "persona.scm"))
                           (answer #f))
                       (with-input-from-string
                           (string-append minimal-prefix "n\n")
                         (lambda ()
                           (with-output-to-string
                             (lambda ()
                               (set! answer (run-wizard #:file file))))))
                       (expect-equal #f answer "cancelled wizard")
                       (expect-true (not (file-exists? file))
                                    "no file written")))))))
         (test "does not overwrite an existing persona without consent"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let ((file (in-vicinity root "persona.scm"))
                           (answer #f))
                       (write-file file "keep me")
                       (with-input-from-string
                           (string-append minimal-answers "n\n")
                         (lambda ()
                           (with-output-to-string
                             (lambda ()
                               (set! answer (run-wizard #:file file))))))
                       (expect-equal #f answer "cancelled wizard")
                       (expect-equal "keep me" (read-file file) "existing file")))))))
         (test "renders the sections that were answered"
               (assert-no-error
                (lambda ()
                  (let* ((persona
                          `((display-name . "Ada Example")
                            (job-title . "Engineer")
                            (job-title-link . "https://example.org")
                            (personal-contact . ((emails . "ada@example.org")
                                                 (phone-numbers . "")))
                            (personal-links . ((blog . "")
                                               (code . "codeberg.org/ada")
                                               (linked-in . "")))
                            (address-lines . ("Main Street 1" "Testville"))
                            (driver-licenses . ("B"))
                            (interests-hobbies . ("Guitar" "Reading"))
                            (languages . ((en . ((name . ((all . "English")))
                                                (proficiency . ((reading . 4)
                                                                (speaking . 4)
                                                                (writing . 4)))))))
                            (education . (((name . "University of Example")
                                           (location . "Leiden")
                                           (position . "MSc Computer Science")
                                           (time . "2018 => 2020")
                                           (experience . ("Thesis")))))
                            (titles . ((short-intro (en . "Profile"))))
                            (skills . ("Scala" "PostgreSQL"))
                            (short-intro . ("I write software."))
                            (jobs . (((name . "Example B.V.")
                                      (location . "Amsterdam")
                                      (position . "Back-end Developer")
                                      (time . "2020 => present")
                                      (experience . ("Shipped things.")))))
                            (document-theme . ats)))
                         (source (persona-source persona)))
                    (expect-contains source "(define personal-contact"
                                     "contact")
                    (expect-contains source "(emails . \"ada@example.org\")"
                                     "email")
                    (expect-not-contains source "phone-numbers" "empty phone")
                    (expect-contains source "(code . \"codeberg.org/ada\")"
                                     "code link")
                    (expect-not-contains source "blog ." "empty blog")
                    (expect-contains source "(define skills" "skills")
                    (expect-contains source "(define languages" "languages")
                    (expect-contains source
                                     "(4 . \"Native / bilingual\")"
                                     "proficiency scale")
                    (expect-contains source "(define address-lines" "addresses")
                    (expect-contains source "(define driver-licenses" "driving")
                    (expect-contains source "(define interests-hobbies" "interests")
                    (expect-contains source "(define jobs" "jobs")
                    (expect-contains source "(define education" "education")
                    (expect-contains source "(define titles" "headings")
                    (expect-contains source
                                     "(short-intro (en . \"Profile\"))"
                                     "custom heading")
                    (expect-contains source
                                     "(define document-theme 'ats)"
                                     "theme")))))))

(define (spec)
  (veritas-run wizard-suite))
