;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (veritas unit iter-vitae text)
  #:declarative? #t
  #:use-module (veritas veritas)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae text)
  #:use-module (veritas support)
  #:export (spec))

(define* (text persona #:key (locale 'en))
  (render-plain-text #:locale locale #:persona persona))

(define text-suite
  (suite "plain-text resume"
         #:concurrent? #f
         (test "renders every configured section"
               (assert-no-error
                (lambda ()
                  (let ((resume (text rich-persona)))
                    (expect-contains resume "Ada & Bob <CEO>" "name")
                    (expect-contains resume "Engineer" "job title")
                    (expect-contains resume "PROFESSIONAL SUMMARY"
                                     "summary heading")
                    (expect-contains resume "SKILLS" "skills heading")
                    (expect-contains resume "WORK EXPERIENCE"
                                     "work heading")
                    (expect-contains resume "EDUCATION" "education heading")
                    (expect-contains resume "LANGUAGES" "languages heading")
                    (expect-contains resume "ADDITIONAL INFORMATION"
                                     "additional heading")
                    (expect-contains resume "Engineer, Acme" "job entry")
                    (expect-contains resume "- Built things" "job bullet")
                    (expect-contains resume "- Wrote tests" "job bullet")
                    (expect-contains resume "BSc, Test University"
                                     "education entry")
                    (expect-contains resume "Scala, Kubernetes, PostgreSQL"
                                     "skills line")
                    (expect-contains resume "Driving: B, A" "driver license")
                    (expect-contains resume "Interests & Hobbies: Testing, Lisp"
                                     "interests")))))
         (test "keeps contact details as visible text"
               (assert-no-error
                (lambda ()
                  (let ((resume (text rich-persona)))
                    (expect-contains resume "ada@example.org" "email")
                    (expect-contains resume "+31 6 1234 5678" "phone")
                    (expect-contains resume "Main Street 1, Testville"
                                     "address")
                    (expect-contains resume "Blog: blog.example.org" "blog")
                    (expect-contains resume "Code: https://codeberg.org/ada"
                                     "code")
                    (expect-contains resume "LinkedIn: linkedin.com/in/ada"
                                     "LinkedIn")))))
         (test "contains no markup, CSS or HTML entities"
               (assert-no-error
                (lambda ()
                  (let ((resume (text rich-persona)))
                    (for-each (lambda (syntax)
                                (expect-not-contains resume syntax syntax))
                              '("<html" "<body" "<h1" "<h2" "<p>"
                                "<a " "href=" "class=" "<ul" "<li"
                                "<style" "@page" "font-family"
                                "&amp;" "&lt;" "&gt;"))))))
         (test "normalizes smart punctuation and emoji"
               (assert-no-error
                (lambda ()
                  (let* ((persona
                          (acons 'short-intro
                                 '(((all . "Built APIs &mdash; fast &amp; reliable • 5&deg; better")))
                                 (acons 'job-title '((all . "Engineer ⚙️"))
                                        rich-persona)))
                         (resume (text persona)))
                    (expect-contains resume
                                     "Built APIs - fast & reliable 5° better"
                                     "clean summary")
                    (expect-not-contains resume "&mdash;" "raw entity")
                    (expect-not-contains resume "—" "em dash")
                    (expect-not-contains resume "•" "bullet character")
                    (expect-not-contains resume "⚙" "emoji")))))
         (test "uses one blank line between blocks"
               (assert-no-error
                (lambda ()
                  (let ((resume (text rich-persona)))
                    (expect-true (not (string-prefix? "\n" resume))
                                 "leading newline")
                    (expect-true (string-suffix? "\n" resume)
                                 "trailing newline")
                    (expect-true (not (string-contains resume "\n\n\n"))
                                 "double blank line")
                    (expect-contains resume
                                     "\n\nPROFESSIONAL SUMMARY\n\n"
                                     "heading spacing")
                    (expect-true
                     (every (lambda (line)
                              (<= (string-length line) 100))
                            (string-split resume #\newline))
                     "line width")))))
         (test "wraps long bullets without duplicating words"
               (assert-no-error
                (lambda ()
                  (let* ((words (map (lambda (n)
                                       (string-append "word"
                                                      (number->string n)))
                                     (iota 40)))
                         (bullet (string-join words " "))
                         (persona
                          (acons 'jobs
                                 (list
                                  (list (cons 'name '((all . "Acme")))
                                        (cons 'position '((all . "Engineer")))
                                        (cons 'experience
                                              (list (list (cons 'all bullet))))))
                                 rich-persona))
                         (resume (text persona)))
                    (expect-contains resume "word0 word1" "first words")
                    (for-each
                     (lambda (n)
                       (expect-not-contains
                        resume
                        (string-append "word" (number->string n)
                                       " word" (number->string n))
                        "duplicated wrapped word"))
                     (iota 40))
                    (expect-true
                     (every (lambda (line)
                              (<= (string-length line) 100))
                            (string-split resume #\newline))
                     "wrapped line width")))))
         (test "localizes headings"
               (assert-no-error
                (lambda ()
                  (let ((resume (text rich-persona #:locale 'nl)))
                    (expect-contains resume "PROFESSIONEEL PROFIEL"
                                     "Dutch summary")
                    (expect-contains resume "WERKERVARING" "Dutch work")
                    (expect-contains resume "OPLEIDING" "Dutch education")
                    (expect-contains resume "TAALVAARDIGHEID"
                                     "Dutch languages")))))
         (test "omits sections the persona did not configure"
               (assert-no-error
                (lambda ()
                  (let ((resume (text sample-persona)))
                    (expect-contains resume "Ada Lovelace" "name")
                    (expect-contains resume "PROFESSIONAL SUMMARY" "summary")
                    (for-each (lambda (heading)
                                (expect-not-contains resume heading heading))
                              '("SKILLS" "WORK EXPERIENCE" "EDUCATION"
                                "LANGUAGES" "ADDITIONAL INFORMATION"))))))
         (test "an empty persona produces an empty file"
               (assert-no-error
                (lambda ()
                  (expect-equal "" (text '()) "empty persona"))))))

(define (spec)
  (veritas-run text-suite))
