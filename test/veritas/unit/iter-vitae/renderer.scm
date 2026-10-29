;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; Rendering is exercised in a child Guile process.  That keeps the loaded
;; `(iter-vitae persona)' module out of the test process, so the unit tests for
;; defaults remain independent of the order in which Veritas runs files.

(define-module (veritas unit iter-vitae renderer)
  #:declarative? #t
  #:use-module (veritas veritas)
  #:use-module (srfi srfi-11)
  #:use-module (ice-9 textual-ports)
  #:use-module (iter-vitae prelude)
  #:use-module (veritas support)
  #:export (spec))

(define* (render-expression file destination resources
                            #:key (locale 'en) (output-format "html")
                            (all-locales? #f) (all-themes? #f))
  (format #f
          "((@(iter-vitae renderer) render-curriculum) #:locale '~a #:destination ~s #:resources ~s #:format ~s #:all-locales? ~a #:all-themes? ~a #:file ~s)"
          locale
          destination
          resources
          output-format
          (if all-locales? "#t" "#f")
          (if all-themes? "#t" "#f")
          file))

(define* (render #:key (root (make-temp-dir))
                 (theme 'ef-cyprus)
                 (persona rich-persona)
                 (destination-name "dist")
                 (resources-name "resources")
                 (locale 'en)
                 (output-format "html")
                 (all-locales? #f)
                 (all-themes? #f))
  "Prepare a persona and resource tree under @var{root}, then render it."
  (let* ((file (in-vicinity root "persona.scm"))
         (resources (make-resources (in-vicinity root resources-name)))
         (destination (in-vicinity root destination-name)))
    (persona-file file (with-theme persona theme))
    (let-values (((status output)
                  (run-guile "-c"
                             (render-expression file
                                                destination
                                                resources
                                                #:locale locale
                                                #:output-format
                                                output-format
                                                #:all-locales?
                                                all-locales?
                                                #:all-themes?
                                                all-themes?))))
      (values status output file resources destination))))

(define (index-path destination)
  (in-vicinity destination "index.html"))

(define (read-index destination)
  (call-with-input-file (index-path destination) get-string-all))

(define (text-path destination)
  (in-vicinity destination "resume.txt"))

(define (read-text destination)
  (call-with-input-file (text-path destination) get-string-all))

(define (read-file path)
  (call-with-input-file path get-string-all))

;; A browser shim lets the PDF tests run without Chromium while still checking
;; the exact executable, argv flags and output path the real renderer uses.
(define (fake-browser root)
  (let ((path (in-vicinity root "fake-browser"))
        (log (in-vicinity root "browser-args")))
    (write-file
     path
     (format #f "#!/bin/sh
printf '%s\\n' \"$@\" >> ~s
output=''
for argument in \"$@\"; do
  case \"$argument\" in
    --print-to-pdf=*) output=${argument#--print-to-pdf=} ;;
  esac
done
[ -n \"$output\" ] || exit 1
printf '%s\\n' '%PDF-1.4' '%% fake' > \"$output\"
" log))
    (chmod path #o755)
    (values path log)))

(define renderer-suite
  (suite "renderer"
         #:concurrent? #f
         (test "writes index.html and clears stale output"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((destination (in-vicinity root "dist"))
                            (stale (in-vicinity destination "stale.txt")))
                       (write-file stale "old")
                       (let-values (((status output file resources destination)
                                     (render #:root root)))
                         (expect-equal 0 status "renderer exit status")
                         (expect-true (file-exists? (index-path destination))
                                      "index.html should exist")
                         (expect-true (not (file-exists? stale))
                                      "stale output should be removed")
                         (expect-contains output
                                          "Completed rendering"
                                          "renderer output")
                         (expect-contains (read-index destination)
                                          ".ef-test-marker > span"
                                          "theme stylesheet")
                         (expect-contains (read-index destination)
                                          "mailto:ada@example.org"
                                          "contact details"))))))))
         (test "embeds a local profile picture relative to the persona"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (write-file (in-vicinity root "portrait.svg") "<svg/>")
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:persona
                                           (cons (cons 'profile-picture
                                                       "portrait.svg")
                                                 (filter
                                                  (lambda (pair)
                                                    (not (eq? (car pair)
                                                              'profile-picture)))
                                                  rich-persona)))))
                       (expect-equal 0 status "renderer exit status")
                       (expect-contains (read-index destination)
                                        "data:image/svg+xml;base64,PHN2Zy8+"
                                        "embedded profile picture")))))))
         (test "text output ignores profile pictures"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:persona
                                           (cons (cons 'profile-picture
                                                       "missing.png")
                                                 (filter
                                                  (lambda (pair)
                                                    (not (eq? (car pair)
                                                              'profile-picture)))
                                                  rich-persona))
                                           #:output-format "text")))
                       (expect-equal 0 status "renderer exit status")
                       (expect-not-contains (read-text destination)
                                            "missing.png"
                                            "text profile picture")))))))
         (test "renders one directory per persona locale"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:persona bilingual-persona
                                           #:all-locales? #t)))
                       (expect-equal 0 status "renderer exit status")
                       (expect-true
                        (file-exists? (index-path
                                       (in-vicinity destination "en")))
                        "English index.html")
                       (expect-true
                        (file-exists? (index-path
                                       (in-vicinity destination "nl")))
                        "Dutch index.html")
                       (expect-true (not (file-exists? (index-path destination)))
                                    "no root index.html")
                       (let ((english (read-index (in-vicinity destination "en")))
                             (dutch (read-index (in-vicinity destination "nl"))))
                         (expect-contains english "Ada Example" "English name")
                         (expect-contains english "Built things"
                                          "English bullet")
                         (expect-contains dutch "Ada Voorbeeld" "Dutch name")
                         (expect-contains dutch "Bouwde dingen"
                                          "Dutch bullet")
                         (expect-not-contains english "Ada Voorbeeld"
                                              "Dutch text in English CV")
                         (expect-not-contains dutch "Ada Example"
                                              "English text in Dutch CV"))
                       (expect-contains output "rendering ef-cyprus for en"
                                        "English render log")
                       (expect-contains output "rendering ef-cyprus for nl"
                                        "Dutch render log")))))))
         (test "renders one text resume per persona locale"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:persona bilingual-persona
                                           #:all-locales? #t
                                           #:output-format "text")))
                       (expect-equal 0 status "renderer exit status")
                       (expect-true
                        (file-exists? (text-path
                                       (in-vicinity destination "en")))
                        "English resume.txt")
                       (expect-true
                        (file-exists? (text-path
                                       (in-vicinity destination "nl")))
                        "Dutch resume.txt")
                       (expect-true (not (file-exists? (text-path destination)))
                                    "no root resume.txt")
                       (expect-contains (read-text (in-vicinity destination "nl"))
                                        "Bouwde dingen"
                                        "Dutch resume text")))))))
         (test "all-locales falls back to the requested locale"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:persona
                                           `((display-name . ((all . "Ada")))
                                             (job-title . ((all . "Engineer")))
                                             (document-theme . ef-cyprus))
                                           #:locale 'nl
                                           #:all-locales? #t)))
                       (expect-equal 0 status "renderer exit status")
                       (expect-true
                        (file-exists? (index-path
                                       (in-vicinity destination "nl")))
                        "fallback locale directory")
                       (expect-true
                        (not (file-exists?
                              (index-path (in-vicinity destination "all"))))
                        "all is not a locale directory")))))))
         (test "escapes persona text in the generated file"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:theme 'ats)))
                       (expect-equal 0 status "renderer exit status")
                       (let ((html (read-index destination)))
                         (expect-contains html
                                          "Ada &amp; Bob &lt;CEO&gt;"
                                          "escaped display name")
                         (expect-not-contains html
                                              "Ada & Bob <CEO>"
                                              "raw display name"))))))))
         (test "writes resume.txt in plain-text format"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:theme 'fatum
                                           #:output-format "TXT")))
                       (expect-equal 0 status "renderer exit status")
                       (expect-true (file-exists? (text-path destination))
                                    "resume.txt should exist")
                       (expect-true (not (file-exists? (index-path destination)))
                                    "text mode should not write index.html")
                       (let ((text (read-text destination)))
                         (expect-contains text "PROFESSIONAL SUMMARY"
                                          "summary heading")
                         (expect-contains text "- Built things"
                                          "job bullet")
                         (expect-contains text
                                          "Scala, Kubernetes, PostgreSQL"
                                          "skills line")
                         (expect-not-contains text "<h2>" "HTML heading")
                         (expect-not-contains text "href=" "HTML link")
                         (expect-not-contains text "@page" "CSS"))))))))
         (test "plain-text mode ignores missing theme resources"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((file (in-vicinity root "persona.scm"))
                            (destination (in-vicinity root "dist")))
                       (persona-file file (with-theme rich-persona 'ef-cyprus))
                       (let-values (((status output)
                                     (run-guile
                                      "-c"
                                      (render-expression
                                       file destination
                                       "/does/not/exist"
                                       #:output-format "text"))))
                         (expect-equal 0 status "renderer exit status")
                         (expect-true (file-exists? (text-path destination))
                                      "resume.txt should exist"))))))))
         (test "an unknown output format fails without clearing the destination"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((file (in-vicinity root "persona.scm"))
                            (resources (make-resources
                                        (in-vicinity root "resources")))
                            (destination (in-vicinity root "dist"))
                            (keep (in-vicinity destination "keep.txt")))
                       (persona-file file (with-theme rich-persona 'ef-cyprus))
                       (write-file keep "keep")
                       (let-values (((status output)
                                     (run-guile
                                      "-c"
                                      (render-expression
                                       file destination resources
                                       #:output-format "docx"))))
                         (expect-true (not (zero? status))
                                      "unknown format should fail")
                         (expect-true (file-exists? keep)
                                      "destination should survive")
                         (expect-true (not (file-exists?
                                           (index-path destination)))
                                      "no index.html should be written")
                         (expect-true (not (file-exists?
                                           (text-path destination)))
                                      "no resume.txt should be written"))))))))
         (test "accepts destination names containing spaces"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:destination-name "dist with spaces")))
                       (expect-equal 0 status "renderer exit status")
                       (expect-true (file-exists? (index-path destination))
                                    "index.html should exist")))))))
         (test "accepts resource paths containing spaces"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((status output file resources destination)
                                   (render #:root root
                                           #:resources-name "resources dir")))
                       (expect-equal 0 status "renderer exit status")
                       (expect-contains (read-index destination)
                                        ".ef-test-marker"
                                        "theme stylesheet")))))))
         (test "never evaluates shell metacharacters in the destination"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((sentinel (in-vicinity root "pwned"))
                            (destination-name
                             (format #f "dist; touch ~a" sentinel)))
                       (let-values (((status output file resources destination)
                                     (render #:root root
                                             #:destination-name destination-name)))
                         (expect-equal 0 status "renderer exit status")
                         (expect-true (not (file-exists? sentinel))
                                      "shell metacharacters must not run")
                         (expect-true (file-exists? (index-path destination))
                                      "index.html should exist"))))))))
         (test "renders every theme to a PDF with the configured browser"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let-values (((browser log) (fake-browser root)))
                       (dynamic-wind
                        (lambda () #t)
                        (lambda ()
                          (setenv "ITER_VITAE_BROWSER" browser)
                          (let-values (((status output file resources destination)
                                        (render #:root root
                                                #:output-format "pdf"
                                                #:all-themes? #t)))
                            (expect-equal 0 status "PDF exit status")
                            (for-each
                             (lambda (theme)
                               (expect-true
                                (file-exists?
                                 (in-vicinity
                                  (in-vicinity destination
                                               (symbol->string theme))
                                  "resume.pdf"))
                                (format #f "~a PDF" theme)))
                             '(ats fatum ef-cyprus fundamental))
                            (expect-true
                             (not (file-exists?
                                   (in-vicinity destination "resume.pdf")))
                             "no root PDF")
                            (let ((arguments (read-file log)))
                              (expect-contains arguments "--headless=new"
                                               "headless flag")
                              (expect-contains arguments
                                               "--no-pdf-header-footer"
                                               "no browser header")
                              (expect-contains arguments
                                               "--print-to-pdf="
                                               "print flag")
                              (expect-contains arguments "file://"
                                               "file URL")
                              (expect-contains
                               arguments
                               (in-vicinity (in-vicinity destination "ats")
                                            "resume.pdf")
                               "ATS output path"))
                            (expect-contains output "rendering ats for en"
                                             "theme log")))
                        (lambda ()
                          (unsetenv "ITER_VITAE_BROWSER")))))))))
         (test "rejects --all-themes with plain text before clearing output"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((file (in-vicinity root "persona.scm"))
                            (resources (make-resources
                                        (in-vicinity root "resources")))
                            (destination (in-vicinity root "dist"))
                            (keep (in-vicinity destination "keep.txt")))
                       (persona-file file (with-theme sample-persona 'ef-cyprus))
                       (write-file keep "keep")
                       (let-values (((status output)
                                     (run-guile
                                      "-c"
                                      (render-expression
                                       file destination resources
                                       #:output-format "text"
                                       #:all-themes? #t))))
                         (expect-true (not (zero? status))
                                      "text/all-themes should fail")
                         (expect-true (file-exists? keep)
                                      "destination should survive"))))))))
         (test "renders the persona with every theme"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (for-each
                      (lambda (theme)
                        (let-values (((status output file resources destination)
                                      (render #:root root
                                              #:theme theme
                                              #:destination-name
                                              (symbol->string theme))))
                          (expect-equal 0 status
                                        (format #f "~a exit status" theme))
                          (expect-true (file-exists? (index-path destination))
                                       (format #f "~a index.html" theme))))
                      '(ef-cyprus fatum fundamental ats)))))))
         (test "a missing persona file is reported as a failure"
               (assert-no-error
                (lambda ()
                  (call-with-temp-dir
                   (lambda (root)
                     (let* ((resources (make-resources
                                        (in-vicinity root "resources")))
                            (destination (in-vicinity root "dist"))
                            (file (in-vicinity root "missing.scm")))
                       (let-values (((status output)
                                     (run-guile "-c"
                                                (render-expression
                                                 file destination resources))))
                         (expect-true (not (eq? status 0))
                                      "a missing persona should fail")
                         (expect-true (not (file-exists?
                                           (index-path destination)))
                                      "no index.html should be written"))))))))))

(define (spec)
  (veritas-run #:concurrent? #f renderer-suite))
