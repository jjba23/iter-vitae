;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; An ATS-first theme.
;;
;; Applicant Tracking Systems and automated resume screeners parse plain text
;; before a person ever sees the page.  This theme therefore deliberately uses
;; the least surprising markup it can:
;;
;; - one column, ordinary document flow, no flex, grid, tables or text boxes;
;; - Arial/Helvetica with a normal 11pt body, no letter-spacing or decorative
;;   text transforms;
;; - contact details and links in the body as selectable text, never icons;
;; - conventional headings such as "Professional Summary", "Skills" and
;;   "Work Experience";
;; - no images, icon fonts, web fonts, headers, footers or external assets.
;;
;; Persona strings may contain the inline HTML documented in the README.  For
;; this theme those tags are stripped (see `plain-text') so a parser never sees
;; literal markup, and the remaining text is escaped by the serializer.

(define-module (iter-vitae theme ats)
  #:declarative? #t
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 format)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 string-fun)
  #:use-module (iter-vitae prelude)
  #:export (ats-html-template ats-main-body))

;; --- Theme styles ---

(define ats-styles
  "\
@page {
  size: Letter portrait;
  margin: 0.75in;
}

html { background: #fff; }

body {
  margin: 0;
  padding: 0.75in;
  color: #000;
  background: #fff;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 11pt;
  line-height: 1.4;
}

main {
  max-width: 8.5in;
  margin: 0 auto;
}

h1 {
  margin: 0 0 2pt 0;
  font-size: 20pt;
  line-height: 1.2;
  font-weight: 700;
}

h2 {
  margin: 16pt 0 6pt 0;
  padding-bottom: 2pt;
  border-bottom: 1px solid #000;
  font-size: 13pt;
  font-weight: 700;
}

h3 {
  margin: 10pt 0 2pt 0;
  font-size: 11.5pt;
  font-weight: 700;
}

p {
  margin: 0 0 5pt 0;
}

ul {
  margin: 3pt 0 8pt 18pt;
  padding: 0;
}

li {
  margin: 0 0 2pt 0;
}

a {
  color: #000;
  text-decoration: none;
}

.job-title {
  margin: 0 0 6pt 0;
  font-size: 12pt;
}

.contact {
  margin: 4pt 0 0 0;
}

.meta {
  margin: 0 0 4pt 0;
}

@media print {
  body {
    padding: 0;
  }

  main {
    max-width: none;
  }
}
")

;; --- Helpers ---

;; Emoji, arrows and other pictographs are meaningful to a person but noise to
;; a parser.  Keep letters (including accented ones) and ordinary punctuation,
;; and drop the symbol blocks that resume text tends to pick up from job-title
;; decorations.  Dates written with `=>' are normalized to a plain hyphen.
(define (ats-safe-char? char)
  (let ((code (char->integer char)))
    (not (or (<= #x2190 code #x21FF)
             (<= #x2300 code #x23FF)
             (<= #x25A0 code #x25FF)
             (<= #x2600 code #x27BF)
             (<= #x2B00 code #x2BFF)
             (<= #x1F000 code #x1FAFF)
             ;; Zero-width and formatting characters.
             (= code #x200B)
             (= code #x200C)
             (= code #x200D)
             (= code #x2060)
             (= code #xFEFF)
             (= code #xFE0F)
             (= code #x00AD)))))

;; Smart typography looks polished in a browser and confusing in a parser.
;; Replace the common curly quotes, dashes and bullets with their ASCII
;; equivalents before the symbol filter runs.  Whitespace is collapsed later by
;; `string-tokenize'.
(define (ats-normalize-char char)
  (case char
    ((#\– #\— #\− #\‒ #\―) #\-)
    ((#\‘ #\’ #\‚ #\‛) #\')
    ((#\“ #\” #\„ #\‟) #\")
    ((#\• #\· #\ ) #\space)
    (else char)))

(define (ats-clean value)
  (let* ((text (plain-text value))
         (text (string-replace-substring text "=>" " - "))
         (text (string-map ats-normalize-char text))
         (text (string-filter ats-safe-char? text))
         (text (string-join (string-tokenize text) " ")))
    ;; Removing an emoji can leave the space that surrounded it in front of a
    ;; full stop.  Tidy that, and the space that sometimes follows `('.
    (let* ((text (regexp-substitute/global #f " +([.,;:!?])" text
                                           'pre 1 'post))
           (text (regexp-substitute/global #f "\\( +" text
                                           'pre "(" 'post)))
      text)))

;; Persona fields are translation alists, but they may also contain inline
;; HTML.  Everything that reaches the page goes through this, so the theme
;; never emits markup taken from the CV data.
(define* (ats-text al #:optional (locale 'en))
  (ats-clean (assq-ref-all-or-lang al locale)))

(define (non-empty-string? value)
  (and value (string? value) (not (string-null? value))))

(define (join-parts parts separator)
  (string-join (filter non-empty-string? parts) separator))

(define (join-nodes nodes separator)
  (cond
    ((null? nodes) '())
    ((null? (cdr nodes)) nodes)
    (else (cons (car nodes)
                (cons separator (join-nodes (cdr nodes) separator))))))

(define* (ats-title #:key persona locale title-key)
  (let ((titles (assq-ref persona 'titles)))
    (if (list? titles)
        (ats-text (assq-ref titles title-key) locale)
        "")))

(define* (ats-section #:key persona locale title-key body)
  (let ((heading (ats-title #:persona persona
                            #:locale locale
                            #:title-key title-key)))
    (if (or (string-null? heading) (null? body))
        '()
        `((h2 ,heading) ,@body))))

;; --- Sections ---

(define* (render-display-name #:key locale persona)
  `(h1 ,(ats-text (assq-ref persona 'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let* ((title (ats-text (assq-ref persona 'job-title) locale))
         (link (job-title-link persona locale)))
    (if (string-null? title)
        '()
        `((p (@ (class "job-title"))
             ,(if link
                  `(a (@ (href ,link)) ,title)
                  title))))))

(define* (render-contact #:key locale persona)
  (let* ((email (personal-contact-value persona 'emails))
         (phone (personal-contact-value persona 'phone-numbers))
         (address (join-parts
                   (map (lambda (line) (ats-text line locale))
                        (or (assq-ref persona 'address-lines) '()))
                   ", "))
         (links (filter-map
                 (lambda (entry)
                   (let ((value (personal-link persona (car entry))))
                     (and value
                          `(a (@ (href ,(external-url value)))
                              ,(string-append (cdr entry)
                                              (ats-clean value))))))
                 '((blog . "Blog: ")
                   (code . "Code: ")
                   (linked-in . "LinkedIn: "))))
         (items (append
                 (if email
                     `((a (@ (href ,(string-append "mailto:"
                                                   (ats-clean email))))
                          ,(ats-clean email)))
                     '())
                 (if phone
                     `((a (@ (href ,(tel-url phone)))
                          ,(ats-clean phone)))
                     '())
                 (if (string-null? address) '() (list address))
                 links)))
    (if (null? items)
        '()
        `((p (@ (class "contact"))
             ,@(join-nodes items " | "))))))

(define* (render-summary #:key locale persona)
  (filter-map (lambda (line)
                (let ((text (ats-text line locale)))
                  (and (not (string-null? text))
                       `(p ,text))))
              (or (assq-ref persona 'short-intro) '())))

(define* (render-skills #:key locale persona)
  (let ((skills (filter-map (lambda (skill)
                              (let ((text (ats-text skill locale)))
                                (and (not (string-null? text)) text)))
                            (or (assq-ref persona 'skills) '()))))
    (if (null? skills)
        '()
        `((p (@ (class "skills")) ,(string-join skills ", "))))))

(define* (render-bullets #:key locale experience)
  (filter-map (lambda (item)
                (let ((text (ats-text item locale)))
                  (and (not (string-null? text))
                       `(li ,text))))
              (or experience '())))

(define* (render-entry #:key locale position name location time experience)
  (let* ((heading (join-parts (list (ats-text position locale)
                                    (ats-text name locale))
                              ", "))
         (meta (join-parts (list (ats-text location locale)
                                 (ats-text time locale))
                           " | "))
         (bullets (render-bullets #:locale locale
                                  #:experience experience)))
    (and (not (string-null? heading))
         `(div (@ (class "entry"))
               (h3 ,heading)
               ,@(if (string-null? meta)
                     '()
                     `((p (@ (class "meta")) ,meta)))
               ,@(if (null? bullets)
                     '()
                     `((ul ,@bullets)))))))

(define* (render-jobs #:key locale persona)
  (filter-map (lambda (job)
                (render-entry #:locale locale
                              #:position (assq-ref job 'position)
                              #:name (assq-ref job 'name)
                              #:location (assq-ref job 'location)
                              #:time (assq-ref job 'time)
                              #:experience (assq-ref job 'experience)))
              (or (assq-ref persona 'jobs) '())))

(define* (render-education #:key locale persona)
  (filter-map (lambda (education)
                (render-entry #:locale locale
                              #:position (assq-ref education 'position)
                              #:name (assq-ref education 'name)
                              #:location (assq-ref education 'location)
                              #:time (assq-ref education 'time)
                              #:experience (assq-ref education 'experience)))
              (or (assq-ref persona 'education) '())))

(define* (proficiency-description #:key persona locale level)
  (let* ((scale (assq-ref persona 'language-proficiency))
         (levels (and (list? scale)
                      (assq-ref-all-or-lang scale locale))))
    (and (list? levels)
         (assoc-ref levels level))))

(define* (render-languages #:key locale persona)
  (let ((items
         (filter-map
          (lambda (language)
            (let* ((name (ats-text (assq-ref language 'name) locale))
                   (proficiency (assq-ref language 'proficiency))
                   (details
                    (filter-map
                     (lambda (skill-key)
                       (let ((level (and (list? proficiency)
                                         (assq-ref proficiency skill-key)))
                             (label (ats-title #:persona persona
                                               #:locale locale
                                               #:title-key skill-key)))
                         (and level
                              (let ((description
                                     (proficiency-description #:persona persona
                                                             #:locale locale
                                                             #:level level)))
                                (and description
                                     (format #f "~a: ~a" label description))))))
                     '(reading speaking writing))))
              (and (not (string-null? name))
                   `(li (strong ,name)
                        ,(if (null? details)
                             ""
                             (string-append " - "
                                            (string-join details "; ")))))))
          (or (assq-ref persona 'languages) '()))))
    (if (null? items)
        '()
        `((ul ,@items)))))

;; Two interests written as sentences read badly when joined with a comma
;; ("... Org mode., Playing bass ...").  Use a space when an item already
;; ends its sentence, and commas for short keyword-style interests.
(define (join-sentences items)
  (if (any (lambda (item)
             (or (string-suffix? "." item)
                 (string-suffix? "!" item)
                 (string-suffix? "?" item)))
           items)
      (string-join items " ")
      (string-join items ", ")))

(define* (render-additional #:key locale persona)
  (let* ((licenses (filter-map (lambda (license)
                                 (let ((text (ats-text license locale)))
                                   (and (not (string-null? text)) text)))
                               (or (assq-ref persona 'driver-licenses) '())))
         (interests (filter-map (lambda (interest)
                                  (let ((text (ats-text interest locale)))
                                    (and (not (string-null? text)) text)))
                                (or (assq-ref persona 'interests-hobbies)
                                    '())))
         (license-label (ats-title #:persona persona
                                   #:locale locale
                                   #:title-key 'driver-license))
         (interests-label (ats-title #:persona persona
                                     #:locale locale
                                     #:title-key 'interests-hobbies)))
    (append
     (if (null? licenses)
         '()
         `((p (strong ,(string-append license-label ": "))
                      ,(string-join licenses ", "))))
     (if (null? interests)
         '()
         `((p (strong ,(string-append interests-label ": "))
                      ,(join-sentences interests)))))))

;; --- Templates ---

(define* (ats-html-template #:key title body locale persona resources)
  `("<!DOCTYPE html>"
    (html (@ (lang ,(locale-code locale)))
          (head (meta (@ (charset "UTF-8")))
                (meta (@ (name "viewport")
                         (content "width=device-width, initial-scale=1.0")))
                (title ,(ats-clean title))
                (style ,ats-styles))
          (body (main ,@body)))))

(define* (ats-main-body #:key locale persona)
  `(,(render-display-name #:locale locale
                          #:persona persona)
    ,@(render-job-title #:locale locale
                        #:persona persona)
    ,@(render-contact #:locale locale
                      #:persona persona)
    ,@(ats-section #:persona persona
                   #:locale locale
                   #:title-key 'professional-summary
                   #:body (render-summary #:locale locale
                                          #:persona persona))
    ,@(ats-section #:persona persona
                   #:locale locale
                   #:title-key 'skills
                   #:body (render-skills #:locale locale
                                         #:persona persona))
    ,@(ats-section #:persona persona
                   #:locale locale
                   #:title-key 'work-experience
                   #:body (render-jobs #:locale locale
                                       #:persona persona))
    ,@(ats-section #:persona persona
                   #:locale locale
                   #:title-key 'education
                   #:body (render-education #:locale locale
                                            #:persona persona))
    ,@(ats-section #:persona persona
                   #:locale locale
                   #:title-key 'language
                   #:body (render-languages #:locale locale
                                            #:persona persona))
    ,@(ats-section #:persona persona
                   #:locale locale
                   #:title-key 'additional-information
                   #:body (render-additional #:locale locale
                                             #:persona persona))))
