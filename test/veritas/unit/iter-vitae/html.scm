;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (veritas unit iter-vitae html)
  #:declarative? #t
  #:use-module (veritas veritas)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 textual-ports)
  #:use-module (iter-vitae html)
  #:use-module (iter-vitae prelude)
  #:use-module (veritas support)
  #:export (spec))

(define test-resources (make-resources (make-temp-dir)))

(define* (page persona #:key (theme 'ef-cyprus) (locale 'en)
                (resources test-resources))
  (iter-vitae-curriculum-page #:locale locale
                              #:resources resources
                              #:persona (with-theme persona theme)))

(define (serialize tree)
  (with-output-to-string (lambda () (sxml->xml tree))))

;; ---------------------------------------------------------------------------
;; SXML serialization
;; ---------------------------------------------------------------------------

(define serializer-suite
  (suite "SXML serializer"
         #:concurrent? #f
         (test "elements and text"
               (assert-equal #:expect "<p>hello</p>"
                             #:got (serialize '(p "hello"))))
         (test "text is escaped"
               (assert-equal #:expect "<p>a &amp; b &lt; c &gt; d</p>"
                             #:got (serialize '(p "a & b < c > d"))))
         (test "attributes are escaped"
               (assert-equal
                #:expect
                "<a href=\"x?a=1&amp;b=2\" title=\"say &quot;hi&quot;\">link</a>"
                #:got (serialize '(a (@ (href "x?a=1&b=2")
                                       (title "say \"hi\""))
                                   "link"))))
         (test "nested elements and nodelists"
               (assert-equal #:expect "<div><p>one</p><p>two</p></div>"
                             #:got (serialize '(div ((p "one")
                                                     (p "two"))))))
         (test "style and script bodies stay raw"
               (assert-equal #:expect "<style>a > b { color: red; }</style>"
                             #:got (serialize '(style "a > b { color: red; }")))
               (assert-equal #:expect "<script>if (a < b) go();</script>"
                             #:got (serialize '(script "if (a < b) go();"))))
         (test "the doctype remains raw while element text is escaped"
               (assert-equal
                #:expect "<!DOCTYPE html><html><body>a &amp; b</body></html>"
                #:got (serialize '("<!DOCTYPE html>"
                                   (html (body "a & b"))))))
         (test "an element without a body is self-closing"
               (assert-equal #:expect "<meta charset=\"UTF-8\" />"
                             #:got (serialize '(meta (@ (charset "UTF-8"))))))
         (test "numbers are serialized as text"
               (assert-equal #:expect "<p>42</p>"
                             #:got (serialize '(p 42))))
         (test "*TOP* serializes its children"
               (assert-equal #:expect "<p>x</p>"
                             #:got (serialize '(*TOP* (p "x")))))
         (test "empty and false children are ignored"
               (assert-equal #:expect "<p></p>"
                             #:got (serialize '(p ()))))))

;; ---------------------------------------------------------------------------
;; Page rendering
;; ---------------------------------------------------------------------------

(define page-suite
  (suite "curriculum page"
         #:concurrent? #f
         (test "ef-cyprus renders the complete persona"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona #:theme 'ef-cyprus)))
                    (expect-contains html "<!DOCTYPE html>" "doctype")
                    (expect-contains html
                                     "<title>Ada &amp; Bob &lt;CEO&gt;</title>"
                                     "escaped title")
                    (expect-not-contains html
                                        "Ada & Bob <CEO>"
                                        "raw display name")
                    (expect-contains html
                                     "href=\"mailto:ada@example.org\""
                                     "email link")
                    (expect-contains html
                                     "href=\"tel:+31612345678\""
                                     "phone link")
                    (expect-contains html
                                     "href=\"https://blog.example.org\""
                                     "blog link")
                    (expect-contains html
                                     "href=\"https://codeberg.org/ada\""
                                     "code link")
                    (expect-contains html
                                     "href=\"https://linkedin.com/in/ada\""
                                     "linked-in link")
                    (expect-contains html
                                     ".ef-test-marker > span"
                                     "ef-cyprus stylesheet")
                    (expect-contains html "Acme" "job")
                    (expect-contains html "Built things" "job detail")
                    (expect-contains html "Test University" "education")
                    (expect-contains html "English" "language")
                    (expect-contains html "Professional"
                                     "language proficiency")
                    (expect-contains html
                                     "Interests &amp; Hobbies"
                                     "interests heading")
                    (expect-contains html
                                     "Lisp (Guile Scheme) code"
                                     "footer")))))
         (test "fatum renders the same persona with its own theme"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona #:theme 'fatum)))
                    (expect-contains html
                                     ".fatum-test-marker > span"
                                     "fatum stylesheet")
                    (expect-contains html
                                     "Ada &amp; Bob &lt;CEO&gt;"
                                     "escaped display name")
                    (expect-contains html
                                     "mailto:ada@example.org"
                                     "email link")
                    (expect-contains html
                                     "href=\"tel:+31612345678\""
                                     "phone link")
                    (expect-contains html "Test University" "education")
                    (expect-contains html "Wrote tests" "job detail")))))
         (test "fundamental renders without external theme assets"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona #:theme 'fundamental)))
                    (expect-contains html
                                     "font-family: -apple-system"
                                     "inline style")
                    (expect-not-contains html
                                        ".ef-test-marker"
                                        "ef-cyprus stylesheet")
                    (expect-not-contains html
                                        ".fatum-test-marker"
                                        "fatum stylesheet")
                    (expect-contains html
                                     "mailto:ada@example.org"
                                     "email link")
                    (expect-contains html
                                     "href=\"tel:+31612345678\""
                                     "phone link")
                    (expect-contains html ">Blog<" "blog label")
                    (expect-contains html ">Code<" "code label")
                    (expect-contains html ">LinkedIn<" "LinkedIn label")))))
         (test "ats renders plain text with conventional headings"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona #:theme 'ats)))
                    (expect-contains html
                                     "<h1>Ada &amp; Bob &lt;CEO&gt;</h1>"
                                     "escaped name")
                    (expect-contains html
                                     "<h2>Professional Summary</h2>"
                                     "summary heading")
                    (expect-contains html "<h2>Skills</h2>" "skills heading")
                    (expect-contains html
                                     "Scala, Kubernetes, PostgreSQL"
                                     "skills line")
                    (expect-contains html "Hello &amp; welcome"
                                     "summary text")
                    (expect-not-contains html ".ef-test-marker"
                                        "ef-cyprus stylesheet")
                    (expect-not-contains html "<table" "table layout")))))
         (test "existing themes keep the documented inline HTML"
               (assert-no-error
                (lambda ()
                  (let* ((persona
                          (acons 'short-intro
                                 (list (list (cons 'all
                                                   "<em class=\"italic\">Hello</em>")))
                                 rich-persona))
                         (html (page persona #:theme 'fatum)))
                    (expect-contains html
                                     "<em class=\"italic\">Hello</em>"
                                     "inline emphasis")
                    (expect-not-contains html "&lt;em"
                                        "escaped emphasis tag")
                    (expect-not-contains html "&amp;lt;em"
                                        "double-escaped emphasis tag")))))))

(define options-suite
  (suite "persona options"
         #:concurrent? #f
         (test "an unknown theme falls back to ef-cyprus"
               (assert-no-error
                (lambda ()
                  (expect-contains (page rich-persona
                                        #:theme 'no-such-theme)
                                   ".ef-test-marker > span"
                                   "fallback stylesheet"))))
         (test "the requested locale is used"
               (assert-no-error
                (lambda ()
                  (let ((html (page sample-persona #:locale 'nl)))
                    (expect-contains html "Ingenieur" "Dutch job title")
                    (expect-not-contains html "Engineer"
                                        "English job title")))))
         (test "the all entry wins over the locale"
               (assert-no-error
                (lambda ()
                  (expect-contains (page rich-persona
                                        #:locale 'nl
                                        #:theme 'fatum)
                                   "Engineer"
                                   "all-locale job title"))))
         (test "missing personal links produce no empty anchors"
               (assert-no-error
                (lambda ()
                  (let ((html (page sample-persona)))
                    (expect-not-contains html
                                        "href=\"https://\""
                                        "empty external link")
                    (expect-not-contains html
                                        "linkedin.com"
                                        "unconfigured LinkedIn link")
                    (expect-contains html
                                     "href=\"https://blog.example.org\""
                                     "blog link")
                    ;; A link that already has a scheme is not doubled.
                    (expect-not-contains html
                                        "https://https://"
                                        "doubled scheme")))))
         (test "without a job-title-link the title is not an anchor"
               (assert-no-error
                (lambda ()
                  (let* ((persona (filter (lambda (pair)
                                            (not (eq? (car pair)
                                                      'job-title-link)))
                                          sample-persona))
                         (html (page persona)))
                    (expect-not-contains html
                                        "example.org/job"
                                        "job title link")
                    (expect-contains html "Engineer" "job title")))))
         (test "empty optional sections are omitted"
               (assert-no-error
                (lambda ()
                  (let ((html (page sample-persona)))
                    (expect-not-contains html "Driving" "driving section")
                    (expect-not-contains html
                                        "Interests &amp; Hobbies"
                                        "interests section")))))
         (test "missing resource files raise instead of silently rendering"
               (assert-error
                (lambda ()
                  (page sample-persona
                        #:resources "/does/not/exist"))))))

(define (spec)
  (dynamic-wind
    (lambda () #t)
    (lambda ()
      (veritas-run serializer-suite
                   page-suite
                   options-suite))
    (lambda ()
      (catch #t
             (lambda () (delete-file-tree test-resources))
             (lambda args #t)))))
