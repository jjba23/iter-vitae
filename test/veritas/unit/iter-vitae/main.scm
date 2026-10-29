;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (veritas unit iter-vitae main)
  #:declarative? #t
  #:use-module (veritas veritas)
  #:use-module (srfi srfi-11)
  #:use-module (ice-9 textual-ports)
  #:use-module (iter-vitae prelude)
  #:use-module (veritas support)
  #:export (spec))

(define* (main #:key file destination resources (locale "en"))
  (run-guile "-c"
             "((@(iter-vitae main) main))"
             "--file" file
             "--destination" destination
             "--locale" locale
             "--resources" resources))

(define (read-index destination)
  (call-with-input-file (in-vicinity destination "index.html")
    get-string-all))

(define main-suite
  (suite "main entrypoint"
         #:concurrent? #f
         (test "renders a curriculum from command line arguments"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let* ((file (in-vicinity root "persona.scm"))
                           (resources (make-resources
                                       (in-vicinity root "resources")))
                           (destination (in-vicinity root "dist")))
                      (persona-file file (with-theme sample-persona 'ef-cyprus))
                      (let-values (((status output)
                                    (main #:file file
                                          #:destination destination
                                          #:resources resources)))
                        ((assert-equal #:expect 0 #:got status) vc)
                        ((assert-true (file-exists?
                                       (in-vicinity destination "index.html")))
                         vc)
                        ((assert-contains #:expect output
                                          #:got "Iter Vitae: Generate")
                         vc)
                        ((assert-contains #:expect output
                                          #:got "Completed rendering")
                         vc)
                        ;; The old entrypoint printed the raw argument list;
                        ;; the CLI now starts with its user-facing banner.
                        ((assert-not-contains #:expect output
                                              #:got "(\"guile\"")
                         vc)))))))
         (test "honours the locale argument"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let* ((file (in-vicinity root "persona.scm"))
                           (resources (make-resources
                                       (in-vicinity root "resources")))
                           (destination (in-vicinity root "dist")))
                      (persona-file file (with-theme sample-persona 'fatum))
                      (let-values (((status output)
                                    (main #:file file
                                          #:destination destination
                                          #:resources resources
                                          #:locale "nl")))
                        ((assert-equal #:expect 0 #:got status) vc)
                        ((assert-contains #:expect output
                                          #:got "locale: nl")
                         vc)
                        ((assert-contains #:expect (read-index destination)
                                          #:got "Ingenieur")
                         vc)
                        ((assert-not-contains #:expect (read-index destination)
                                              #:got ">Engineer<")
                         vc)))))))
         (test "renders every persona locale with --all-locales"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let* ((file (in-vicinity root "persona.scm"))
                           (resources (make-resources
                                       (in-vicinity root "resources")))
                           (destination (in-vicinity root "dist")))
                      (persona-file file (with-theme bilingual-persona 'ef-cyprus))
                      (let-values (((status output)
                                    (run-guile "-c"
                                               "((@(iter-vitae main) main))"
                                               "--file" file
                                               "--destination" destination
                                               "--resources" resources
                                               "--all-locales")))
                        ((assert-equal #:expect 0 #:got status) vc)
                        ((assert-true
                          (file-exists?
                           (in-vicinity (in-vicinity destination "en")
                                        "index.html")))
                         vc)
                        ((assert-true
                          (file-exists?
                           (in-vicinity (in-vicinity destination "nl")
                                        "index.html")))
                         vc)
                        ((assert-false
                          (file-exists?
                           (in-vicinity destination "index.html")))
                         vc)
                        ((assert-contains
                          #:expect (read-index (in-vicinity destination "nl"))
                          #:got "Ada Voorbeeld")
                         vc)
                        ((assert-contains #:expect output
                                          #:got "rendering ef-cyprus for nl")
                         vc)))))))
         (test "writes a text resume with --format text"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let* ((file (in-vicinity root "persona.scm"))
                           (resources (make-resources
                                       (in-vicinity root "resources")))
                           (destination (in-vicinity root "dist"))
                           (resume (in-vicinity destination "resume.txt")))
                      (persona-file file (with-theme sample-persona 'ef-cyprus))
                      (let-values (((status output)
                                    (run-guile "-c"
                                               "((@(iter-vitae main) main))"
                                               "--file" file
                                               "--destination" destination
                                               "--resources" resources
                                               "--format" "text")))
                        ((assert-equal #:expect 0 #:got status) vc)
                        ((assert-true (file-exists? resume)) vc)
                        ((assert-false (file-exists?
                                        (in-vicinity destination "index.html")))
                         vc)
                        ((assert-contains
                          #:expect
                          (call-with-input-file resume get-string-all)
                          #:got "PROFESSIONAL SUMMARY")
                         vc)
                        ((assert-contains #:expect output
                                          #:got "format: text")
                         vc)
                        ((assert-contains #:expect output
                                          #:got "Completed rendering")
                         vc)))))))
         (test "uses ./resources when --resources is omitted"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let* ((file (in-vicinity root "persona.scm"))
                           (destination (in-vicinity root "dist")))
                      (persona-file file (with-theme sample-persona 'ef-cyprus))
                      ;; The child runs from the repository root, where the
                      ;; project's real resources/ directory lives.
                      (let-values (((status output)
                                    (run-guile "-c"
                                               "((@(iter-vitae main) main))"
                                               "--file" file
                                               "--destination" destination
                                               "--locale" "en")))
                        ((assert-equal #:expect 0 #:got status) vc)
                        ((assert-true (file-exists?
                                       (in-vicinity destination "index.html")))
                         vc)))))))
         (test "reports a failure when --file is missing"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let ((destination (in-vicinity root "dist")))
                      (let-values (((status output)
                                    (run-guile "-c"
                                               "((@(iter-vitae main) main))"
                                               "--destination" destination)))
                        ((assert-false (zero? status)) vc)
                        ((assert-false (file-exists?
                                        (in-vicinity destination "index.html")))
                         vc)))))))))

(define (spec)
  (veritas-run main-suite))
