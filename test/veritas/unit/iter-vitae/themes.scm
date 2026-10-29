;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (veritas unit iter-vitae themes)
  #:declarative? #t
  #:use-module (veritas veritas)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 textual-ports)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae html)
  #:use-module (iter-vitae prelude)
  #:use-module (veritas support)
  #:export (spec))

(define test-resources (make-resources (make-temp-dir)))

(define* (page persona theme #:key (locale 'en))
  (iter-vitae-curriculum-page #:locale locale
                              #:resources test-resources
                              #:persona (with-theme persona theme)))

;; ---------------------------------------------------------------------------
;; ef-cyprus
;; ---------------------------------------------------------------------------

(define ef-cyprus-suite
  (suite "ef-cyprus theme"
         #:concurrent? #f
         (test "renders every scheduled section"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ef-cyprus)))
                    (expect-contains html "Work Experience" "work heading")
                    (expect-contains html "Education" "education heading")
                    (expect-contains html "Languages" "language heading")
                    (expect-contains html "Driving" "driving heading")
                    (expect-contains html
                                     "Interests"
                                     "interests heading")
                    (expect-contains html "Acme" "job")
                    (expect-contains html "Test University" "education")
                    (expect-contains html "English" "language")
                    (expect-contains html "Native" "language proficiency")
                    (expect-contains html "Testing" "hobby")
                    (expect-contains html "Lisp" "hobby")
                    (expect-contains html ">B</span>" "driver license")
                    (expect-contains html ">A</span>" "driver license")
                    (expect-contains html "BSc" "degree")
                    (expect-contains html "2010 - 2014" "education time")
                    (expect-contains html "Skills" "skills heading")
                    (expect-contains html "Kubernetes" "skills tag")
                    (expect-contains html "ef-skills" "skills list")))))
         (test "prints with the green accent and no split entries"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ef-cyprus)))
                    (expect-contains html "@media print" "print styles")
                    (expect-contains html "size: A4" "print page size")
                    (expect-contains html "break-inside: avoid"
                                     "entry pagination")
                    (expect-contains html "ef-page" "printable page")))))
         (test "renders the complete contact block"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ef-cyprus)))
                    (expect-contains html
                                     "href=\"mailto:ada@example.org\""
                                     "email link")
                    (expect-contains html
                                     "href=\"tel:+31612345678\""
                                     "phone link")
                    (expect-contains html "Main Street 1" "address")
                    (expect-contains html "+31 6 1234 5678" "phone number")))))
         (test "omits sections the persona did not configure"
               (assert-no-error
                (lambda ()
                  (let ((html (page sample-persona 'ef-cyprus)))
                    (expect-not-contains html "Driving" "driving section")
                    (expect-not-contains html
                                        "Interests"
                                        "interests section")
                    (expect-not-contains html
                                        "linkedin.com"
                                        "unconfigured link")))))
         (test "uses only configured footer links"
               (assert-no-error
                (lambda ()
                  (let ((html (page sample-persona 'ef-cyprus)))
                    (expect-contains html ">blog.example.org<" "blog label")
                    (expect-contains html
                                     ">https://codeberg.org/ada<"
                                     "code label")
                    (expect-not-contains html
                                        "href=\"https://\""
                                        "empty external link")))))))

;; ---------------------------------------------------------------------------
;; fatum
;; ---------------------------------------------------------------------------

(define fatum-suite
  (suite "fatum theme"
         #:concurrent? #f
         (test "renders every scheduled section"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fatum)))
                    (expect-contains html "Work Experience" "work heading")
                    (expect-contains html "Education" "education heading")
                    (expect-contains html "Languages" "language heading")
                    (expect-contains html "Driving" "driving heading")
                    (expect-contains html
                                     "Interests"
                                     "interests heading")
                    (expect-contains html "Acme" "job")
                    (expect-contains html "Wrote tests" "job detail")
                    (expect-contains html "Test University" "education")
                    (expect-contains html "English" "language")
                    (expect-contains html
                                     "Professional working"
                                     "language proficiency")
                    (expect-contains html "Skills" "skills heading")
                    (expect-contains html "Kubernetes" "skills tag")
                    (expect-contains html "fatum-skills" "skills list")))))
         (test "prints without the screen card or split entries"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fatum)))
                    (expect-contains html "@media print" "print styles")
                    (expect-contains html "size: A4" "print page size")
                    (expect-contains html "break-inside: avoid"
                                     "entry pagination")
                    (expect-contains html "fatum-page" "printable card")))))
         (test "escapes persona text inside its own template"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fatum)))
                    (expect-contains html
                                     "Ada &amp; Bob &lt;CEO&gt;"
                                     "escaped display name")
                    (expect-not-contains html
                                        "Ada & Bob <CEO>"
                                        "raw display name")))))
         (test "renders all configured personal links"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fatum)))
                    (expect-contains html
                                     "https://blog.example.org"
                                     "blog link")
                    (expect-contains html
                                     "https://codeberg.org/ada"
                                     "code link")
                    (expect-contains html
                                     "https://linkedin.com/in/ada"
                                     "linked-in link")))))
         (test "supports a persona without optional sections"
               (assert-no-error
                (lambda ()
                  (let ((html (page sample-persona 'fatum)))
                    (expect-not-contains html "Driving" "driving section")
                    (expect-contains html
                                     "I write software."
                                     "short intro")))))))

;; ---------------------------------------------------------------------------
;; fundamental
;; ---------------------------------------------------------------------------

(define fundamental-suite
  (suite "fundamental theme"
         #:concurrent? #f
         (test "renders every scheduled section"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fundamental)))
                    (expect-contains html "Work Experience" "work heading")
                    (expect-contains html "Education" "education heading")
                    (expect-contains html "Languages" "language heading")
                    (expect-contains html "Driving" "driving heading")
                    (expect-contains html
                                     "Interests"
                                     "interests heading")
                    (expect-contains html "Acme" "job")
                    (expect-contains html "Wrote tests" "job detail")
                    (expect-contains html "Test University" "education")
                    (expect-contains html "English" "language")
                    (expect-contains html
                                     "Professional working"
                                     "language proficiency")
                    (expect-contains html "Skills" "skills heading")
                    (expect-contains html "Scala, Kubernetes, PostgreSQL"
                                     "skills line")))))
         (test "includes print rules"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fundamental)))
                    (expect-contains html "@media print" "print styles")
                    (expect-contains html "size: A4" "print page size")
                    (expect-contains html "fundamental-footer"
                                     "printable footer")))))
         (test "keeps its inline styling"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fundamental)))
                    (expect-contains html
                                     "font-family: -apple-system"
                                     "inline style")
                    (expect-not-contains html
                                        ".ef-test-marker"
                                        "ef-cyprus stylesheet")
                    (expect-not-contains html
                                        ".fatum-test-marker"
                                        "fatum stylesheet")))))
         (test "labels footer links instead of echoing the URL"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'fundamental)))
                    (expect-contains html ">Blog<" "blog label")
                    (expect-contains html ">Code<" "code label")
                    (expect-contains html ">LinkedIn<" "LinkedIn label")))))
         (test "renders no footer links when none are configured"
               (assert-no-error
                (lambda ()
                  (let* ((persona (cons (cons 'personal-links '())
                                        (filter (lambda (pair)
                                                  (not (eq? (car pair)
                                                            'personal-links)))
                                                sample-persona)))
                         (html (page persona 'fundamental)))
                    (expect-not-contains html ">Blog<" "blog label")
                    (expect-not-contains html ">Code<" "code label")
                    (expect-not-contains html ">LinkedIn<" "LinkedIn label")
                    (expect-not-contains html
                                        "href=\"https://\""
                                        "empty external link")))))))

;; ---------------------------------------------------------------------------
;; ats
;; ---------------------------------------------------------------------------

(define ats-suite
  (suite "ats theme"
         #:concurrent? #f
         (test "uses the conventional section headings ATS parsers expect"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ats)))
                    (expect-contains html "<h1>Ada" "name heading")
                    (expect-contains html
                                     "<h2>Professional Summary</h2>"
                                     "summary heading")
                    (expect-contains html "<h2>Skills</h2>" "skills heading")
                    (expect-contains html
                                     "<h2>Work Experience</h2>"
                                     "work heading")
                    (expect-contains html "<h2>Education</h2>"
                                     "education heading")
                    (expect-contains html "<h2>Languages</h2>"
                                     "languages heading")
                    (expect-contains html
                                     "<h2>Additional Information</h2>"
                                     "additional heading")
                    (expect-contains html "<h3>Engineer, Acme</h3>"
                                     "job subheading")
                    (expect-contains html
                                     "<h3>BSc, Test University</h3>"
                                     "education subheading")))))
         (test "keeps the document single-column and free of parser traps"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ats)))
                    (for-each (lambda (trap)
                                (expect-not-contains html trap trap))
                              '("<table"
                                "<img"
                                "<svg"
                                "<i "
                                "display: flex"
                                "display:flex"
                                "display: grid"
                                "display:grid"
                                "@import"
                                "fonts.googleapis"
                                "cdn.jsdelivr"
                                "target=\"_blank\""))
                    (expect-contains html "<main>" "main landmark")
                    (expect-contains html "<ul>" "bullet list")
                    (expect-contains html "<li>Built things</li>"
                                     "experience bullet")
                    (expect-contains html
                                     "font-family: Arial, Helvetica, sans-serif"
                                     "ATS-safe font stack")
                    (expect-contains html "font-size: 11pt"
                                     "standard body size")
                    (expect-contains html "size: A4 portrait"
                                     "A4 page size")
                    (expect-contains html "class=\"language-list\""
                                     "language list pagination hook")))))
         (test "renders contact details as selectable text"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ats)))
                    (expect-contains html "ada@example.org" "email text")
                    (expect-contains html
                                     "href=\"mailto:ada@example.org\""
                                     "email link")
                    (expect-contains html "+31 6 1234 5678" "phone text")
                    (expect-contains html
                                     "href=\"tel:+31612345678\""
                                     "phone link")
                    (expect-contains html "Main Street 1" "address")
                    (expect-contains html
                                     "linkedin.com/in/ada"
                                     "visible profile URL")))))
         (test "renders skills as a scan-friendly list"
               (assert-no-error
                (lambda ()
                  (expect-contains (page rich-persona 'ats)
                                   "Scala, Kubernetes, PostgreSQL"
                                   "skills line"))))
         (test "removes emoji and normalizes date separators"
               (assert-no-error
                (lambda ()
                  (let* ((persona
                          (with-theme
                           (acons 'job-title '((all . "Engineer ⚙️ • Remote"))
                                  (acons 'jobs
                                         (list
                                          (list (cons 'name '((all . "Acme")))
                                                (cons 'position '((all . "Engineer")))
                                                (cons 'time '((all . "2020 – now")))
                                                (cons 'experience '())))
                                         rich-persona))
                           'ats))
                         (html (page persona 'ats)))
                    (expect-contains html "Engineer Remote"
                                     "cleaned job title")
                    (expect-not-contains html "⚙" "emoji")
                    (expect-not-contains html "•" "bullet character")
                    (expect-contains html "2020 - now" "normalized dates")
                    (expect-not-contains html "=>" "raw date separator")
                    (expect-not-contains html "–" "en dash")))))
         (test "strips inline HTML and escapes the remaining text"
               (assert-no-error
                (lambda ()
                  (let* ((persona
                          (with-theme
                           (acons 'short-intro
                                  (list (list (cons 'all
                                                    "<em class=\"italic\">Hello &amp; welcome</em>")))
                                  (acons 'jobs
                                         (list
                                          (list (cons 'name '((all . "Acme")))
                                                (cons 'position '((all . "Engineer")))
                                                (cons 'location '((all . "Remote")))
                                                (cons 'time '((all . "2020 - now")))
                                                (cons 'experience
                                                      (list
                                                       (list (cons 'all
                                                                   "Used <strong>C</strong> &amp; Lisp"))))))
                                         rich-persona))
                           'ats))
                         (html (page persona 'ats)))
                    (expect-contains html "Hello &amp; welcome"
                                     "summary text")
                    (expect-contains html
                                     "Used C &amp; Lisp"
                                     "bullet text")
                    (expect-not-contains html "<em" "inline emphasis tag")
                    (expect-not-contains html "&lt;em" "escaped emphasis tag")
                    (expect-not-contains html "<strong>C</strong>"
                                        "inline strong tag")
                    (expect-not-contains html "&lt;strong"
                                        "escaped strong tag")))))
         (test "omits sections the persona did not configure"
               (assert-no-error
                (lambda ()
                  (let ((html (page sample-persona 'ats)))
                    (expect-not-contains html "<h2>Skills</h2>"
                                        "skills section")
                    (expect-not-contains html "<h2>Languages</h2>"
                                        "languages section")
                    (expect-not-contains html "<h2>Additional Information</h2>"
                                        "additional section")
                    (expect-not-contains html "<h2>Work Experience</h2>"
                                        "work section")))))
         (test "localizes the standard headings"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ats #:locale 'nl)))
                    (expect-contains html "Professioneel profiel"
                                     "Dutch summary heading")
                    (expect-contains html "Werkervaring"
                                     "Dutch work heading")
                    (expect-contains html "Opleiding"
                                     "Dutch education heading")))))
         (test "has no decorative footer or attribution"
               (assert-no-error
                (lambda ()
                  (let ((html (page rich-persona 'ats)))
                    (expect-not-contains html "Rendered with" "attribution")
                    (expect-not-contains html "Lisp (Guile Scheme)"
                                        "attribution link")
                    (expect-not-contains html "<footer" "footer element")))))))

;; ---------------------------------------------------------------------------
;; Contract shared by every theme
;; ---------------------------------------------------------------------------

(define (index-of needle haystack label)
  (let ((index (string-contains haystack needle)))
    (expect-true index label)
    index))

(define shared-suite
  (suite "shared theme contract"
         #:concurrent? #f
         (test "every theme declares the document language"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (expect-contains (page rich-persona theme)
                                      "<html lang=\"en\">"
                                      "English lang attribute")
                     (expect-contains (page rich-persona theme #:locale 'nl)
                                      "<html lang=\"nl\">"
                                      "Dutch lang attribute"))
                   '(ef-cyprus fatum fundamental ats)))))
         (test "every theme normalizes the job-title link"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (expect-contains
                      (page rich-persona theme)
                      "href=\"https://example.org/job\""
                      "absolute job-title link"))
                   '(ef-cyprus fatum fundamental ats)))))
         (test "every theme renders all address lines and languages"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (let ((html (page rich-persona theme)))
                       (expect-contains html "Main Street 1" "first address line")
                       (expect-contains html "Testville" "second address line")
                       (expect-contains html "English" "first language")
                       (expect-contains html "Dutch" "second language")))
                   '(ef-cyprus fatum fundamental ats)))))
         (test "face variables expand into utility classes"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (let ((html (page rich-persona theme)))
                       (expect-not-contains html "h2-special-face"
                                            "literal face name")
                       (expect-not-contains html "table-face"
                                            "literal table face name")
                       (expect-contains html "bg-stone-300"
                                        "table background")
                       (expect-contains html "shadow-md"
                                        "table shadow")))
                   '(ef-cyprus fatum))))
         (test "visual themes render an optional profile picture"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (let ((html (page rich-persona theme)))
                       (expect-contains html "https://example.org/ada.png"
                                        "profile picture source")
                       (expect-contains
                        html
                        "alt=\"Ada &amp; Bob &lt;CEO&gt;\""
                        "profile picture alternative text")))
                   '(ef-cyprus fatum fundamental))
                  (expect-not-contains (page rich-persona 'ats)
                                       "ada.png"
                                       "ATS profile picture"))))
         (test "themes omit the picture element when no picture is set"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (expect-not-contains (page sample-persona theme)
                                          "<img"
                                          "absent profile picture"))
                   '(ef-cyprus fatum fundamental ats)))))
         (test "every theme renders configured skills"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (expect-contains (page rich-persona theme)
                                      "Kubernetes"
                                      "configured skill"))
                   '(ef-cyprus fatum fundamental ats)))))
         (test "visual themes format date ranges with an en dash"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (let* ((job `((name . ((all . "Acme")))
                                   (location . ((all . "Remote")))
                                   (position . ((all . "Engineer")))
                                   (time . ((all . "2020 => now")))
                                   (experience . (((all . "Built things"))))))
                            (persona (with-theme
                                      (acons 'jobs (list job) rich-persona)
                                      theme))
                            (html (page persona theme)))
                       (expect-contains html "2020 – now" "formatted date")
                       (expect-not-contains html "=>" "raw separator")))
                   '(ef-cyprus fatum fundamental)))))
         (test "visual themes omit skills when the persona has none"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (expect-not-contains (page sample-persona theme)
                                          ">Skills<"
                                          "empty skills section"))
                   '(ef-cyprus fatum fundamental)))))
         (test "language tables read reading, speaking, writing"
               (assert-no-error
                (lambda ()
                  (for-each
                   (lambda (theme)
                     (let ((html (page rich-persona theme)))
                       (expect-contains html ">Language<" "language column")
                       (expect-true
                        (< (index-of ">Reading<" html "reading heading")
                           (index-of ">Speaking<" html "speaking heading"))
                        "reading before speaking")
                       (expect-true
                        (< (index-of ">Speaking<" html "speaking heading")
                           (index-of ">Writing<" html "writing heading"))
                        "speaking before writing")))
                   '(ef-cyprus fatum fundamental)))))
         (test "ats tidies punctuation left by removed emoji"
               (assert-no-error
                (lambda ()
                  (let* ((persona
                          (with-theme
                           (acons 'interests-hobbies
                                  '(((all . "Music 🎻."))
                                    ((all . "Reading.")))
                                  rich-persona)
                           'ats))
                         (html (page persona 'ats)))
                    (expect-contains html "Music. Reading."
                                     "sentence-style interests")
                    (expect-not-contains html "Music ."
                                        "space before punctuation")
                    (expect-not-contains html "Music.,"
                                        "comma after a full stop"))))))))

(define (spec)
  (dynamic-wind
    (lambda () #t)
    (lambda ()
      (veritas-run ef-cyprus-suite
                   fatum-suite
                   fundamental-suite
                   ats-suite
                   shared-suite))
    (lambda ()
      (catch #t
             (lambda () (delete-file-tree test-resources))
             (lambda args #t)))))
