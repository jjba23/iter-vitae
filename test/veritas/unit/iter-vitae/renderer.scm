;;; Iter Vitae

;; Copyright © Josep Jesus Bigorra Algaba

;; iter-vitae is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; iter-vitae is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public License
;; along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

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
                            #:key (locale 'en) (output-format "html"))
  (format #f
          "((@(iter-vitae renderer) render-curriculum) #:locale '~a #:destination ~s #:resources ~s #:format ~s #:file ~s)"
          locale
          destination
          resources
          output-format
          file))

(define* (render #:key (root (make-temp-dir))
                 (theme 'ef-cyprus)
                 (persona rich-persona)
                 (destination-name "dist")
                 (resources-name "resources")
                 (locale 'en)
                 (output-format "html"))
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
                                                output-format))))
      (values status output file resources destination))))

(define (index-path destination)
  (in-vicinity destination "index.html"))

(define (read-index destination)
  (call-with-input-file (index-path destination) get-string-all))

(define (text-path destination)
  (in-vicinity destination "resume.txt"))

(define (read-text destination)
  (call-with-input-file (text-path destination) get-string-all))

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
                                       #:output-format "pdf"))))
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
