;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (veritas unit iter-vitae prelude)
  #:declarative? #t
  #:use-module (veritas veritas)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 textual-ports)
  #:use-module (iter-vitae prelude)
  #:use-module (veritas support)
  #:export (spec))

;; ---------------------------------------------------------------------------
;; CSS class names
;; ---------------------------------------------------------------------------

(define class-suite
  (suite "CSS class helpers"
         #:concurrent? #f
         (test "an empty class list becomes an empty string"
               (assert-equal #:expect "" #:got (mk-class '())))
         (test "#f becomes an empty string"
               (assert-equal #:expect "" #:got (mk-class #f)))
         (test "class names are sorted, de-duplicated and joined"
               (assert-equal #:expect "a b c"
                             #:got (mk-class '(c b a b)))
               (assert-equal #:expect "flex gap-1"
                             #:got (mk-class '(gap-1 flex gap-1))))
         (test "a single class name is unchanged"
               (assert-equal #:expect "hidden" #:got (mk-class '(hidden))))))

;; ---------------------------------------------------------------------------
;; Locale-aware alist lookup
;; ---------------------------------------------------------------------------

(define locale-suite
  (suite "locale-aware alist lookup"
         #:concurrent? #f
         (test "the all entry wins over a locale entry"
               (assert-equal #:expect "Everywhere"
                             #:got (assq-ref-all-or-lang
                                    '((all . "Everywhere")
                                      (en . "English"))
                                    'en)))
         (test "the requested locale is used when all is absent"
               (assert-equal #:expect "English"
                             #:got (assq-ref-all-or-lang
                                    '((nl . "Nederlands")
                                      (en . "English"))
                                    'en)))
         (test "a missing translation becomes an empty string"
               (assert-equal #:expect ""
                             #:got (assq-ref-all-or-lang
                                    '((nl . "Nederlands"))
                                    'en)))
         (test "an empty alist becomes an empty string"
               (assert-equal #:expect "" #:got (assq-ref-all-or-lang '() 'en)))
         (test "#f becomes an empty string"
               (assert-equal #:expect "" #:got (assq-ref-all-or-lang #f 'en)))))

;; ---------------------------------------------------------------------------
;; Links and contact details
;; ---------------------------------------------------------------------------

(define url-suite
  (suite "URL helpers"
         #:concurrent? #f
         (test "bare hosts get an https scheme"
               (assert-equal #:expect "https://example.org"
                             #:got (external-url "example.org")))
         (test "an existing https scheme is preserved"
               (assert-equal #:expect "https://example.org"
                             #:got (external-url "https://example.org")))
         (test "an existing http scheme is preserved"
               (assert-equal #:expect "http://example.org"
                             #:got (external-url "http://example.org")))
         (test "surrounding whitespace is removed"
               (assert-equal #:expect "https://example.org"
                             #:got (external-url "  example.org  ")))
         (test "empty and non-string links are #f"
               (assert-equal #:expect #f #:got (external-url ""))
               (assert-equal #:expect #f #:got (external-url "   "))
               (assert-equal #:expect #f #:got (external-url #f))
               (assert-equal #:expect #f #:got (external-url 42)))
         (test "phone numbers become tel URLs"
               (assert-equal #:expect "tel:+31612345678"
                             #:got (tel-url "+31 6 1234 5678"))
               (assert-equal #:expect "tel:0031612345678"
                             #:got (tel-url "00 31 6 1234 5678")))
         (test "empty phone numbers are #f"
               (assert-equal #:expect #f #:got (tel-url ""))
               (assert-equal #:expect #f #:got (tel-url #f)))))

(define persona-accessor-suite
  (suite "persona accessors"
         #:concurrent? #f
         (test "personal links are read by key"
               (assert-equal #:expect "blog.example.org"
                             #:got (personal-link sample-persona 'blog))
               (assert-equal #:expect "https://codeberg.org/ada"
                             #:got (personal-link sample-persona 'code)))
         (test "missing and empty personal links are #f"
               (assert-equal #:expect #f
                             #:got (personal-link sample-persona 'linked-in))
               (assert-equal #:expect #f
                             #:got (personal-link '() 'blog))
               (assert-equal #:expect #f
                             #:got (personal-link
                                    '((personal-links . ((blog . "  "))))
                                    'blog)))
         (test "contact details are read by key"
               (assert-equal #:expect "ada@example.org"
                             #:got (personal-contact-value
                                    sample-persona 'emails))
               (assert-equal #:expect "+31 6 1234 5678"
                             #:got (personal-contact-value
                                    sample-persona 'phone-numbers)))
         (test "missing contact details are #f"
               (assert-equal #:expect #f
                             #:got (personal-contact-value
                                    sample-persona 'fax))
               (assert-equal #:expect #f
                             #:got (personal-contact-value '() 'emails)))))

;; ---------------------------------------------------------------------------
;; Settings
;; ---------------------------------------------------------------------------

(define settings-suite
  (suite "settings"
         #:concurrent? #f
         (test "a default setting is visible"
               (assert-equal #:expect 'ef-cyprus
                             #:got (get-setting 'document-theme)))
         (test "job-title-link has an empty default"
               (assert-equal #:expect '()
                             #:got (get-setting 'job-title-link)))
         (test "an unknown setting is #f instead of raising"
               (assert-no-error
                (lambda ()
                  (get-setting 'a-setting-that-does-not-exist)))
               (assert-equal #:expect #f
                             #:got (get-setting 'a-setting-that-does-not-exist)))))

;; ---------------------------------------------------------------------------
;; Resources
;; ---------------------------------------------------------------------------

(define asset-suite
  (suite "resource loading"
         #:concurrent? #f
         (test "stylesheets are read from the requested resources directory"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (make-resources root)
                    (let ((css (asset-css "iter-vitae.olive.min.css" root)))
                      ((assert-contains #:expect css
                                        #:got ".ef-test-marker > span")
                       vc)
                      ((assert-false (string-contains css "\n")) vc)
                      ((assert-true (string? css)) vc))))))
         (test "the asset library keys assets by their full path"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (make-resources root)
                    (let* ((library (load-asset-library root))
                           (ef-path (in-vicinity
                                     (in-vicinity root "css")
                                     "iter-vitae.olive.min.css"))
                           (fatum-path (in-vicinity
                                        (in-vicinity root "css")
                                        "fatum.olive.min.css")))
                      ((assert-contains #:expect (assoc-ref library ef-path)
                                        #:got "ef-test-marker")
                       vc)
                      ((assert-contains #:expect (assoc-ref library fatum-path)
                                        #:got "fatum-test-marker")
                       vc))))))
         (test "a missing stylesheet raises"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    ((assert-error
                      (lambda ()
                        (asset-css "missing.css" root)))
                     vc)))))))

;; ---------------------------------------------------------------------------
;; Filesystem helpers
;; ---------------------------------------------------------------------------

(define filesystem-suite
  (suite "filesystem helpers"
         #:concurrent? #f
         (test "make-directories creates nested paths"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let ((path (in-vicinity root "a/b/c")))
                      ((assert-false (file-exists? path)) vc)
                      (make-directories path)
                      ((assert-true (file-exists? path)) vc)
                      ((assert-equal #:expect 'directory
                                     #:got (stat:type (stat path)))
                       vc)
                      ;; Calling it again is a no-op, like mkdir -p.
                      ((assert-no-error (lambda () (make-directories path))) vc))))))
         (test "delete-file-tree removes files and nested directories"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    (let ((tree (in-vicinity root "a/b"))
                          (file (in-vicinity root "a/b/c/file.txt")))
                      (write-file file "hello")
                      ((assert-true (file-exists? file)) vc)
                      (delete-file-tree (in-vicinity root "a"))
                      ((assert-false (file-exists? tree)) vc)
                      ((assert-false (file-exists? file)) vc))))))
         (test "deleting a missing path is a no-op"
               (lambda (vc)
                 (call-with-temp-dir
                  (lambda (root)
                    ((assert-no-error
                      (lambda ()
                        (delete-file-tree (in-vicinity root "missing"))))
                     vc)))))))

;; ---------------------------------------------------------------------------
;; Plain text
;; ---------------------------------------------------------------------------

(define plain-text-suite
  (suite "plain text"
         #:concurrent? #f
         (test "inline tags are stripped"
               (assert-equal
                #:expect "greenest moment of the day"
                #:got (plain-text
                       "<em class=\"italic\">greenest moment of the day</em>")))
         (test "HTML entities are decoded"
               (assert-equal
                #:expect "Ada & Bob <CEO> \"quoted\" 'single'"
                #:got (plain-text
                       "Ada &amp; Bob &lt;CEO&gt; &quot;quoted&quot; &#39;single&#39;")))
         (test "common named entities are decoded"
               (assert-equal
                #:expect "a – b — c … “q” • 5° €"
                #:got (plain-text
                       "a &ndash; b &mdash; c &hellip; &ldquo;q&rdquo; &bull; 5&deg; &euro;")))
         (test "entities are decoded exactly once"
               (assert-equal #:expect "&mdash;"
                             #:got (plain-text "&amp;mdash;")))
         (test "plain text is left untouched"
               (assert-equal #:expect "C, Lisp & Scheme"
                             #:got (plain-text "C, Lisp & Scheme")))
         (test "comparisons are not mistaken for tags"
               (assert-equal #:expect "latency < 50 > budget"
                             #:got (plain-text "latency < 50 > budget")))
         (test "non-strings and empty strings become empty text"
               (assert-equal #:expect "" #:got (plain-text #f))
               (assert-equal #:expect "" #:got (plain-text '()))
               (assert-equal #:expect "" #:got (plain-text "")))))

;; ---------------------------------------------------------------------------
;; Logging
;; ---------------------------------------------------------------------------

(define logging-suite
  (suite "logging"
         #:concurrent? #f
         (test "log-info formats its arguments"
               (assert-equal #:expect "\nhello 42"
                             #:got (with-output-to-string
                                     (lambda () (log-info "hello ~a" 42)))))
         (test "log-error prefixes the message"
               (assert-equal #:expect "\n[error] boom"
                             #:got (with-output-to-string
                                     (lambda () (log-error "boom")))))
         (test "log formats its arguments"
               (assert-equal #:expect "\n1 + 2 = 3"
                             #:got (with-output-to-string
                                     (lambda () (log "~a + ~a = ~a"
                                                     1 2 3)))))))

(define (spec)
  (veritas-run class-suite
               locale-suite
               url-suite
               persona-accessor-suite
               settings-suite
               asset-suite
               filesystem-suite
               plain-text-suite
               logging-suite))
