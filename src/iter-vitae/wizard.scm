;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; An interactive wizard for the one file Iter Vitae cannot generate for you:
;; the persona.  It asks the questions a CV answers, then writes ordinary Scheme
;; data that the renderer already understands.  Everything is optional except
;; the name and the job title, and every answer can be skipped by pressing
;; Enter, so a first persona takes a minute instead of reading the field
;; reference first.

(define-module (iter-vitae wizard)
  #:declarative? #t
  #:use-module (ice-9 format)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae prelude)
  #:export (run-wizard persona-source parse-locales))

;; ---------------------------------------------------------------------------
;; Terminal styling
;;
;; Colour and emoji make the questions easier to scan, but they must never end
;; up in a redirected transcript or break a test.  Styling is therefore only
;; used when stdout is a terminal, NO_COLOR is unset and TERM is not dumb.
;; ---------------------------------------------------------------------------

(define (styling?)
  (and (not (getenv "NO_COLOR"))
       (not (equal? (getenv "TERM") "dumb"))
       (isatty? (current-output-port))))

(define (paint code text)
  (if (styling?)
      (string-append "\033[" code "m" text "\033[0m")
      text))

(define (bold text) (paint "1" text))
(define (cyan text) (paint "36" text))
(define (green text) (paint "32" text))
(define (yellow text) (paint "33" text))
(define (grey text) (paint "90" text))

(define (section icon title)
  (newline)
  (format #t "~a ~a\n" (cyan "━━") (bold (format #f "~a ~a" icon title))))

(define (hint text)
  (format #t "   ~a\n" (grey text)))

;; ---------------------------------------------------------------------------
;; Asking questions
;; ---------------------------------------------------------------------------

;; Print @var{label} and read one answer.  An empty answer selects
;; @var{default}; a required question asks again instead of returning empty.
(define* (ask label #:key default (required? #f) help note)
  (when help (hint help))
  (let loop ()
    (display (cyan "? "))
    (display (bold label))
    (when (and default (not (string-null? default)))
      (format #t " ~a" (grey (format #f "[~a]" default))))
    (when note (format #t " ~a" (grey note)))
    (display ": ")
    (force-output)
    (let ((line (read-line (current-input-port))))
      (when (eof-object? line)
        (throw 'wizard-cancelled 'eof))
      (let ((line (string-trim-both line)))
        (cond
          ((string-null? line)
           (cond
             ((and default (not (string-null? default))) default)
             (required?
              (format #t "  ~a\n"
                      (yellow "⚠ This one is required — please type an answer."))
              (loop))
             (else "")))
          (else line))))))

(define* (ask-yes-no question #:key (default #f))
  (let loop ()
    (let ((answer (string-downcase
                   (ask question #:default (if default "Y" "n")))))
      (cond
        ((member answer '("y" "yes")) #t)
        ((member answer '("n" "no")) #f)
        (else
         (hint "Please type y (yes) or n (no).")
         (loop))))))

;; Collect one item per line until the user enters an empty line.  Used for
;; bullet points, summary paragraphs and free-form lists.
(define* (ask-lines label #:key help)
  (when help (hint help))
  (hint "One per line. Press Enter on an empty line when you are done.")
  (let loop ((number 1) (items '()))
    (let ((line (ask (format #f "  ~a" number)
                     #:note "(Enter to finish)")))
      (if (string-null? line)
          (reverse items)
          (loop (+ number 1) (cons line items))))))

(define (split-commas value)
  (if (string-null? value)
      '()
      (remove string-null?
              (map string-trim-both
                   (string-split
                    (string-map (lambda (c)
                                  (if (char=? c #\;) #\, c))
                                value)
                    #\,)))))

;; ---------------------------------------------------------------------------
;; Languages and translated answers
;; ---------------------------------------------------------------------------

(define (locale-code? code)
  (and (not (string-null? code))
       (not (string=? code "all"))
       (char-alphabetic? (string-ref code 0))
       (every (lambda (char)
                (or (char-alphabetic? char)
                    (char-numeric? char)
                    (char=? char #\-)))
              (string->list code))))

;; Turn "en, nl, es" into ("en" "nl" "es"), or #f for an empty or invalid
;; choice.  The first language is the one used for the questions.
(define (parse-locales value)
  (and (string? value)
       (let* ((codes (map string-downcase (split-commas value)))
              (codes (delete-duplicates codes string=?)))
         (and (not (null? codes))
              (every locale-code? codes)
              codes))))

(define (locale-name locale)
  (case locale
    ((en) "English")
    ((nl) "Dutch")
    ((es) "Spanish")
    ((fr) "French")
    ((de) "German")
    ((pt) "Portuguese")
    ((it) "Italian")
    ((ca) "Catalan")
    (else (string-upcase (locale-code locale)))))

(define (locales-label locales)
  (string-join (map locale-name locales) ", "))

(define* (ask-locales #:key (default 'en))
  (section "🌐" "CV languages")
  (hint "Type language codes separated by commas, e.g. en,nl,es.")
  (hint "The first language is used for the questions; the others are translations.")
  (let loop ()
    (let* ((answer (ask "Languages" #:default (locale-code default)))
           (codes (parse-locales answer)))
      (if codes
          (let ((locales (map string->symbol codes)))
            (format #t "   ~a ~a\n"
                    (grey "Selected:") (bold (locales-label locales)))
            locales)
          (begin
            (hint "⚠ Use codes such as en, nl or pt-BR, separated by commas.")
            (loop))))))

;; Ask the same question once per locale.  The first answer is the source text;
;; for the others, pressing Enter reuses it.  The result is an alist such as
;; ((en . "Ada") (nl . "Ada")), ready to be written as a translation-alist.
(define* (ask-translated label #:key (locales '(en)) (required? #f) help)
  (when help (hint help))
  (let* ((primary (car locales))
         (source (ask label #:required? required?)))
    (cons (cons primary source)
          (map (lambda (locale)
                 (cons locale
                       (ask (format #f "~a in ~a"
                                    label (locale-name locale))
                            #:default source
                            #:required? required?)))
               (cdr locales)))))

;; Combine the per-locale lists into one list of translation-alists.  Every
;; locale has the same number of items because the translations follow the
;; source list one line at a time.
(define (transpose-items locales per-locale)
  (let ((items (assq-ref per-locale (car locales))))
    (map (lambda (index)
           (map (lambda (locale)
                  (cons locale
                        (list-ref (assq-ref per-locale locale) index)))
                locales))
         (iota (length items)))))

;; Ask a list of lines in the first language, then the corresponding translated
;; line in every other language.  Empty answers reuse the source line.
(define* (ask-translated-lines label #:key (locales '(en)) help)
  (when help (hint help))
  (let* ((primary (car locales))
         (items (ask-lines label)))
    (if (null? items)
        '()
        (transpose-items
         locales
         (cons (cons primary items)
               (map (lambda (locale)
                      (cons locale
                            (map (lambda (item number)
                                   (ask (format #f "  ~a in ~a"
                                                number (locale-name locale))
                                        #:default item))
                                 items (iota (length items) 1))))
                    (cdr locales)))))))

;; Skills are entered as one comma-separated answer in the first language, then
;; translated skill by skill.
(define* (ask-translated-skills label #:key (locales '(en)) help)
  (when help (hint help))
  (let* ((primary (car locales))
         (items (split-commas (ask label))))
    (if (null? items)
        '()
        (transpose-items
         locales
         (cons (cons primary items)
               (map (lambda (locale)
                      (cons locale
                            (map (lambda (item number)
                                   (ask (format #f "  ~a in ~a"
                                                number (locale-name locale))
                                        #:default item))
                                 items (iota (length items) 1))))
                    (cdr locales)))))))

(define (ask-theme)
  (section "🎨" "Choose a look")
  (format #t "  ~a  ~a  ~a\n"
          (cyan "1") (bold "ef-cyprus") (grey "light green, modern (recommended)"))
  (format #t "  ~a  ~a  ~a\n"
          (cyan "2") (bold "fundamental") (grey "black and white, simplest, offline-safe"))
  (format #t "  ~a  ~a  ~a\n"
          (cyan "3") (bold "fatum") (grey "bold and technical, for engineers"))
  (format #t "  ~a  ~a  ~a\n"
          (cyan "4") (bold "ats") (grey "plain text, for online application systems"))
  (hint "Not sure? Press Enter for ef-cyprus.")
  (let loop ()
    (let ((answer (string-downcase (ask "Theme" #:default "1"))))
      (cond
        ((member answer '("1" "ef-cyprus")) 'ef-cyprus)
        ((member answer '("2" "fundamental")) 'fundamental)
        ((member answer '("3" "fatum")) 'fatum)
        ((member answer '("4" "ats")) 'ats)
        (else
         (hint "⚠ Please choose 1, 2, 3 or 4.")
         (loop))))))

(define (ask-level label default)
  (let loop ()
    (let* ((answer (ask label #:default (number->string default)))
           (level (string->number answer)))
      (if (and (exact-integer? level) (<= 1 level 4))
          level
          (begin
            (hint "⚠ Please type a number from 1 to 4.")
            (loop))))))

;; ---------------------------------------------------------------------------
;; Collecting one persona
;; ---------------------------------------------------------------------------

(define* (ask-job #:key (locales '(en)))
  `((name . ,(ask-translated "Company" #:locales locales #:required? #t
                            #:help "The employer or organisation."))
    (position . ,(ask-translated "Job title" #:locales locales #:required? #t
                                 #:help "Your role there, e.g. Back-end Developer."))
    (time . ,(ask-translated "Period" #:locales locales
                             #:help "For example: 2022 => present"))
    (location . ,(ask-translated "Location" #:locales locales
                                 #:help "For example: Amsterdam, Netherlands"))
    (experience . ,(ask-translated-lines
                    "Achievement" #:locales locales
                    #:help "Start each line with a verb, e.g. \"Built ...\"."))))

(define* (ask-education #:key (locales '(en)))
  `((name . ,(ask-translated "Institution" #:locales locales #:required? #t
                            #:help "School, university or course provider."))
    (position . ,(ask-translated "Degree or course" #:locales locales
                                 #:required? #t))
    (time . ,(ask-translated "Period" #:locales locales
                             #:help "For example: 2016 => 2020"))
    (location . ,(ask-translated "Location" #:locales locales))
    (experience . ,(ask-translated-lines "Highlight" #:locales locales))))

(define (language-code? code)
  (and (not (string-null? code))
       (char-alphabetic? (string-ref code 0))
       (every (lambda (char)
                (or (char-alphabetic? char)
                    (char-numeric? char)
                    (char=? char #\-)))
              (string->list code))))

(define (ask-language-code)
  (let loop ()
    (let ((code (string-downcase
                 (ask "Language code" #:required? #t
                      #:help "A short tag such as en, nl or es."))))
      (if (language-code? code)
          code
          (begin
            (hint "⚠ Use letters, numbers or hyphens, e.g. en, nl or pt-BR.")
            (loop))))))

(define* (ask-language #:key (locales '(en)))
  (let ((code (ask-language-code))
        (name (ask-translated "Language name" #:locales locales #:required? #t
                              #:help "For example: English, Dutch, Spanish.")))
    (hint "Rate reading, speaking and writing from 1 (basic) to 4 (native).")
    (cons code
          (list (cons 'name name)
                (cons 'proficiency
                      `((reading . ,(ask-level "  Reading level" 3))
                        (speaking . ,(ask-level "  Speaking level" 3))
                        (writing . ,(ask-level "  Writing level" 3))))))))

(define (ask-loop first-question next-question entry-label ask-one)
  (let loop ((entries '()) (number 1))
    (if (ask-yes-no (if (null? entries) first-question next-question)
                    #:default (null? entries))
        (begin
          (format #t "\n~a\n"
                  (bold (format #f "  ~a ~a" entry-label number)))
          (loop (cons (ask-one) entries) (+ number 1)))
        (reverse entries))))

;; Section headings are an advanced, optional feature: the defaults are good,
;; but a wizard that claims to cover the persona should not hide them.  Only
;; the headings the user renames are stored; the rest keep their translations.
(define heading-keys
  '(short-intro work-experience education skills language reading speaking
    writing interests-hobbies driver-license my-links professional-summary
    additional-information))

(define* (heading-label key #:optional (locale 'en) (fallback 'en))
  (let ((label (assq-ref-all-or-lang (assq-ref titles key) locale)))
    (if (string-null? label)
        (let ((fallback-label (assq-ref-all-or-lang (assq-ref titles key)
                                                    fallback)))
          (if (string-null? fallback-label)
              (symbol->string key)
              fallback-label))
        label)))

(define* (ask-heading-overrides-for-locale #:key (locale 'en) (primary 'en))
  (format #t "\n~a\n"
          (bold (format #f "  Headings in ~a" (locale-name locale))))
  (hint "Enter a number to rename a heading, or press Enter to finish.")
  (for-each
   (lambda (key number)
     (format #t "  ~a  ~a\n" (cyan (number->string number))
             (heading-label key locale primary)))
   heading-keys
   (iota (length heading-keys) 1))
  (let loop ((overrides '()))
    (let ((answer (ask "Number to rename")))
      (if (string-null? answer)
          (reverse overrides)
          (let ((number (string->number answer)))
            (if (and (exact-integer? number)
                     (<= 1 number (length heading-keys)))
                (let* ((key (list-ref heading-keys (- number 1)))
                       (label (heading-label key locale primary))
                       (new-heading
                        (ask (format #f "New text for ~a" label)
                             #:required? #t)))
                  (format #t "  ~a Renamed ~a to \"~a\".\n"
                          (green "✔") label new-heading)
                  (loop (acons key new-heading overrides)))
                (begin
                  (hint "⚠ Please type a number from the list, or press Enter to finish.")
                  (loop overrides))))))))

(define* (ask-heading-overrides #:key (locales '(en)))
  (if (not (ask-yes-no "Customize section headings?" #:default #f))
      '()
      (let ((overrides
             (map (lambda (locale)
                    (cons locale
                          (ask-heading-overrides-for-locale
                           #:locale locale #:primary (car locales))))
                  locales)))
        (filter (lambda (entry) (pair? (cdr entry))) overrides))))

;; Build a full `titles' alist from the defaults, replacing the headings that
;; were renamed in each locale.  Other translations survive untouched.
(define (titles-with-overrides overrides)
  (map (lambda (entry)
         (let* ((key (car entry))
                (translations (cdr entry))
                (translations
                 (fold (lambda (locale-overrides translations)
                         (let ((replacement (assq-ref (cdr locale-overrides)
                                                      key)))
                           (if replacement
                               (cons (cons (car locale-overrides) replacement)
                                     (remove (lambda (pair)
                                               (eq? (car pair)
                                                    (car locale-overrides)))
                                             translations))
                               translations)))
                       translations
                       overrides)))
           (cons key translations)))
       titles))

(define* (collect-persona #:key (locales '(en)))
  (section "👤" "About you")
  (hint "Only your name and job title are required.")
  (when (> (length locales) 1)
    (hint "Press Enter on a translation to reuse the first language."))
  (let* ((display-name (ask-translated "Full name" #:locales locales
                                       #:required? #t
                                       #:help "The name at the top of your CV."))
         (job-title (ask-translated "Job title" #:locales locales
                                    #:required? #t
                                    #:help "For example: Software Engineer, Teacher, Product Manager."))
         (job-title-link (ask-translated
                          "Link for your job title (optional)" #:locales locales
                          #:help "Paste a profile page; https:// is added automatically."))
         (theme (ask-theme))

         (emails (begin
                   (section "📫" "Contact")
                   (ask "E-mail (optional)"
                        #:help "Shown as a clickable e-mail link.")))
         (phone-numbers (ask "Phone number (optional)"
                             #:help "Shown as a clickable phone link."))

         (blog (begin
                 (section "🔗" "On the internet")
                 (ask "Blog or website (optional)"
                      #:help "Example: example.org")))
         (code (ask "Code hosting profile (optional)"
                    #:help "Example: codeberg.org/yourname"))
         (linked-in (ask "LinkedIn profile (optional)"
                         #:help "Example: linkedin.com/in/yourname"))

         (address-lines (begin
                          (section "🌍" "Location")
                          (ask-translated-lines
                           "Address line" #:locales locales
                           #:help "City and country is enough; a street address is not required.")))
         (short-intro (begin
                        (section "📝" "Summary")
                        (ask-translated-lines
                         "Paragraph" #:locales locales
                         #:help "Two or three sentences about what you do and want next.")))
         (skills (begin
                   (section "🛠" "Skills")
                   (ask-translated-skills
                    "Skills, separated by commas (optional)" #:locales locales
                    #:help "Example: Python, SQL, project management.")))
         (jobs (begin
                 (section "💼" "Work experience")
                 (hint "Newest first. Press Enter to add a job, or type n to skip.")
                 (ask-loop "Add a job?" "Add another job?" "Job"
                           (lambda () (ask-job #:locales locales)))))
         (education (begin
                      (section "🎓" "Education")
                      (hint "Most recent first. Press Enter to add one, or type n to skip.")
                      (ask-loop "Add an education entry?"
                                "Add another education entry?"
                                "Education"
                                (lambda () (ask-education #:locales locales)))))
         (languages (begin
                      (section "🗣" "Languages")
                      (hint "Press Enter to add a language, or type n to skip.")
                      (ask-loop "Add a language?" "Add another language?"
                                "Language"
                                (lambda () (ask-language #:locales locales)))))
         (interests-hobbies (begin
                              (section "🎸" "Interests and hobbies")
                              (ask-translated-lines "Interest" #:locales locales)))
         (driver-licenses (begin
                            (section "🚗" "Driving")
                            (ask-translated-lines
                             "Driver licence" #:locales locales
                             #:help "Example: B driver's licence.")))
         (titles (begin
                   (section "🧩" "Advanced (optional)")
                   (hint "Most people can leave these as they are.")
                   (let ((overrides (ask-heading-overrides #:locales locales)))
                     (if (null? overrides)
                         '()
                         (titles-with-overrides overrides))))))

    `((display-name . ,display-name)
      (job-title . ,job-title)
      (job-title-link . ,job-title-link)
      (personal-contact . ((emails . ,emails)
                           (phone-numbers . ,phone-numbers)))
      (personal-links . ((blog . ,blog)
                         (code . ,code)
                         (linked-in . ,linked-in)))
      (address-lines . ,address-lines)
      (driver-licenses . ,driver-licenses)
      (interests-hobbies . ,interests-hobbies)
      (languages . ,languages)
      (education . ,education)
      (titles . ,titles)
      (skills . ,skills)
      (short-intro . ,short-intro)
      (jobs . ,jobs)
      (document-theme . ,theme))))

;; ---------------------------------------------------------------------------
;; Writing the persona file
;; ---------------------------------------------------------------------------

(define (persona-ref persona key)
  (let ((entry (assq key persona)))
    (and entry (cdr entry))))

;; Render one translated value.  A string is legacy data and keeps the
;; language-independent `all' fallback; an alist becomes a real translation
;; such as ((en . "Ada") (nl . "Ada")).
(define (render-translation value)
  (cond
    ((string? value)
     (format #f "((all . ~s))" value))
    ((or (not value) (null? value))
     "()")
    (else
     (format #f "(~a)"
             (string-join
              (map (lambda (pair)
                     (format #f "(~a . ~s)" (car pair) (cdr pair)))
                   value)
              " ")))))

;; A list of translated values, as Iter Vitae expects for address lines,
;; paragraphs, skills and bullet points.  Each item can be a legacy string or
;; its own translation-alist.
(define (translation-list values)
  (format #f "(~a)"
          (string-join (map render-translation (or values '())) " ")))

(define (emit-translation-list port field values)
  (let ((values (or values '())))
    (unless (null? values)
      (format port "(define ~a\n  `~a)\n\n"
              field
              (translation-list values)))))

(define (render-job job)
  (format #f "((name . ~a)
   (location . ~a)
   (position . ~a)
   (time . ~a)
   (experience . ~a))"
          (render-translation (assq-ref job 'name))
          (render-translation (assq-ref job 'location))
          (render-translation (assq-ref job 'position))
          (render-translation (assq-ref job 'time))
          (if (null? (assq-ref job 'experience))
              "()"
              (translation-list (assq-ref job 'experience)))))

(define (emit-entries port field entries render)
  (let ((entries (or entries '())))
    (unless (null? entries)
      (format port "(define ~a\n  `(~a))\n\n"
              field
              (string-join (map render entries) "\n   ")))))

(define (render-language language)
  (let* ((code (car language))
         (profile (cdr language))
         (name (assq-ref profile 'name))
         (proficiency (assq-ref profile 'proficiency))
         (reading (assq-ref proficiency 'reading))
         (speaking (assq-ref proficiency 'speaking))
         (writing (assq-ref proficiency 'writing)))
    (format #f "(~a . ((name . ~a)
          (proficiency . ((reading . ~a)
                          (speaking . ~a)
                          (writing . ~a)))))"
            code (render-translation name) reading speaking writing)))

;; The labels shown inside the language table.  They are selected by the
;; document locale, so the generated scale follows the languages chosen in the
;; wizard rather than the language codes of the rows themselves.
(define proficiency-labels
  '((en (1 . "Elementary proficiency")
        (2 . "Limited working proficiency")
        (3 . "Professional proficiency")
        (4 . "Native / bilingual"))
    (nl (1 . "Elementaire vaardigheid")
        (2 . "Beperkte werkvaardigheid")
        (3 . "Professioneel vaardig")
        (4 . "Moedertaal / tweetalig"))
    (es (1 . "Competencia elemental")
        (2 . "Competencia limitada")
        (3 . "Competencia profesional")
        (4 . "Nativo / bilingüe"))))

(define (render-language-proficiency locale)
  (let ((labels (or (assq-ref proficiency-labels locale)
                    (assq-ref proficiency-labels 'en))))
    (format #f "(~a ~a)" locale (render-translations labels))))

(define (render-contact contact)
  (let ((emails (or (assq-ref contact 'emails) ""))
        (phone-numbers (or (assq-ref contact 'phone-numbers) ""))
        (fields '()))
    (unless (string-null? emails)
      (set! fields (cons (format #f "(emails . ~s)" emails) fields)))
    (unless (string-null? phone-numbers)
      (set! fields (cons (format #f "(phone-numbers . ~s)" phone-numbers)
                         fields)))
    (if (null? fields)
        ""
        (format #f "(define personal-contact\n  `(~a))\n\n"
                (string-join (reverse fields) "\n    ")))))

(define (render-links links)
  (let ((fields '()))
    (for-each
     (lambda (key)
       (let ((value (or (assq-ref links key) "")))
         (unless (string-null? value)
           (set! fields (cons (format #f "(~a . ~s)" key value) fields)))))
     '(blog code linked-in))
    (if (null? fields)
        ""
        (format #f "(define personal-links\n  `(~a))\n\n"
                (string-join (reverse fields) "\n    ")))))

(define (render-translations translations)
  (string-join
   (map (lambda (pair)
          (format #f "(~a . ~s)" (car pair) (cdr pair)))
        translations)
   " "))

(define (render-titles section-titles)
  (format #f "(~a)"
          (string-join
           (map (lambda (entry)
                  (format #f "(~a ~a)"
                          (car entry)
                          (render-translations (cdr entry))))
                section-titles)
           "\n   ")))

(define (translation-empty? value)
  (cond
    ((not value) #t)
    ((string? value) (string-null? value))
    ((list? value) (every (lambda (pair) (string-null? (cdr pair))) value))
    (else #f)))

;; Render @var{persona} as a loadable @code{(iter-vitae persona)} module.  The
;; optional @var{file} only appears in the comment that tells the user how to
;; render the generated file.  @var{locales} controls the language labels in
;; the generated proficiency table.
(define* (persona-source persona #:optional (file "my-cv.scm")
                         #:key (locales '(en)))
  (let* ((locales (if (null? locales) '(en) locales))
         (port (open-output-string))
        (display-name (persona-ref persona 'display-name))
        (job-title (persona-ref persona 'job-title))
        (job-title-link (persona-ref persona 'job-title-link))
        (contact (or (persona-ref persona 'personal-contact) '()))
        (links (or (persona-ref persona 'personal-links) '()))
        (address-lines (or (persona-ref persona 'address-lines) '()))
        (driver-licenses (or (persona-ref persona 'driver-licenses) '()))
        (interests-hobbies (or (persona-ref persona 'interests-hobbies) '()))
        (languages (or (persona-ref persona 'languages) '()))
        (education (or (persona-ref persona 'education) '()))
        (section-titles (or (persona-ref persona 'titles) '()))
        (skills (or (persona-ref persona 'skills) '()))
        (short-intro (or (persona-ref persona 'short-intro) '()))
        (jobs (or (persona-ref persona 'jobs) '()))
        (theme (persona-ref persona 'document-theme)))

    (format port ";;; ~a — persona for Iter Vitae
;;
;; Generated by `iter-vitae --init`.  This is ordinary Guile Scheme: change
;; any value, add fields from the README, or turn repeated entries into
;; functions.  Re-render after every edit.
;;
;; Render it with:
;;   iter-vitae --locale ~a --file ~a --destination dist

(define-module (iter-vitae persona)
  #:declarative? #t)

(define document-theme '~a)

(define display-name
  `~a)

(define job-title
  `~a)

"
            (locale-code (car locales))
            (translation-value display-name (car locales)) file theme
            (render-translation display-name)
            (render-translation job-title))

    (unless (translation-empty? job-title-link)
      (format port "(define job-title-link\n  `~a)\n\n"
              (render-translation job-title-link)))
    (unless (null? section-titles)
      (format port "(define titles\n  `~a)\n\n"
              (render-titles section-titles)))
    (display (render-contact contact) port)
    (display (render-links links) port)
    (emit-translation-list port "address-lines" address-lines)
    (emit-translation-list port "short-intro" short-intro)
    (emit-translation-list port "skills" skills)
    (emit-entries port "jobs" jobs render-job)
    (emit-entries port "education" education render-job)
    (unless (null? languages)
      (format port "(define languages\n  `(~a))\n\n"
              (string-join (map render-language languages) "\n   "))
      (format port "(define language-proficiency\n  `(~a))\n\n"
              (string-join (map render-language-proficiency locales)
                           "\n   ")))
    (emit-translation-list port "interests-hobbies" interests-hobbies)
    (emit-translation-list port "driver-licenses" driver-licenses)
    (get-output-string port)))

(define (count-label number singular plural)
  (format #f "~a ~a" number (if (= number 1) singular plural)))

(define (translation-value value locale)
  (cond
    ((string? value) value)
    ((or (not value) (null? value)) "")
    ((list? value)
     (cond
       ((assq locale value) (cdr (assq locale value)))
       ((assq 'all value) (cdr (assq 'all value)))
       ((pair? value) (cdr (car value)))
       (else "")))
    (else "")))

(define (show-locales locales)
  (section "🌐" "CV languages")
  (format #t "   ~a ~a\n" (grey "Selected:") (bold (locales-label locales)))
  (when (> (length locales) 1)
    (hint "Press Enter on a translated question to reuse the first language.")))

(define (print-summary persona file locales)
  (let ((primary (car locales)))
    (section "✅" "Review")
    (format #t "   ~a ~a\n"
            (grey "Name:")
            (bold (translation-value (persona-ref persona 'display-name)
                                     primary)))
    (format #t "   ~a ~a\n"
            (grey "Title:")
            (translation-value (persona-ref persona 'job-title) primary))
    (format #t "   ~a ~a\n"
            (grey "Languages:") (locales-label locales))
    (format #t "   ~a ~a\n"
            (grey "Look:") (persona-ref persona 'document-theme))
    (format #t "   ~a ~a, ~a, ~a\n"
            (grey "Contents:")
            (count-label (length (persona-ref persona 'jobs)) "job" "jobs")
            (count-label (length (persona-ref persona 'education))
                         "education entry" "education entries")
            (count-label (length (persona-ref persona 'languages))
                         "language" "languages"))
    (format #t "   ~a ~a\n" (grey "File:") (bold file))))

(define* (resolve-locales locales #:key (default 'en))
  (cond
    ((not locales) (ask-locales #:default default))
    ((string? locales)
     (let ((codes (parse-locales locales)))
       (or (and codes (map string->symbol codes))
           (error "Invalid --locales value; expected codes such as en,nl"))))
    ((list? locales)
     (let* ((value (string-join
                    (map (lambda (locale)
                           (string-downcase (locale-code locale)))
                         locales)
                    ","))
            (codes (parse-locales value)))
       (or (and codes (map string->symbol codes))
           (error "Invalid --locales value; expected codes such as en,nl"))))
    (else (error "Invalid --locales value" locales))))

;; Ask the questions, show a summary, then write the persona.  An existing file
;; is only replaced after an explicit yes, so a mistyped --file cannot destroy
;; a CV.  Input ending early (Ctrl-D) cancels without writing anything.
(define* (run-wizard #:key (file "./my-cv.scm") (locale 'en) locales)
  (newline)
  (display (bold "✨ Iter Vitae — let's build your CV"))
  (newline)
  (hint "You do not need to know Scheme; answer in plain text.")
  (hint "Press Enter to skip an optional question. Ctrl-C stops without saving.")
  (hint "You can build the CV in one language or several and translate as you go.")
  (let* ((provided? (and locales #t))
         (locales (resolve-locales locales #:default locale)))
    (when provided? (show-locales locales))
    (catch 'wizard-cancelled
      (lambda ()
        (let ((persona (collect-persona #:locales locales)))
          (print-summary persona file locales)
          (if (ask-yes-no (format #f "Write this CV to ~a?" file) #:default #t)
              (if (and (file-exists? file)
                       (not (ask-yes-no
                             (format #f "~a already exists. Replace it?" file)
                             #:default #f)))
                  (begin
                    (format #t "~a\n" (yellow "Left the existing file untouched."))
                    #f)
                  (begin
                    (make-directories (dirname file))
                    (call-with-output-file file
                      (lambda (port)
                        (display (persona-source persona file
                                                 #:locales locales)
                                 port)))
                    (format #t "\n~a ~a\n"
                            (green "✔")
                            (bold (format #f "Saved your CV to ~a" file)))
                    (hint (format #f "Render it with: iter-vitae --locale ~a --file ~a --destination dist"
                                  (locale-code (car locales)) file))
                    (when (> (length locales) 1)
                      (hint (format #f "Render every translation at once with: iter-vitae --all-locales --file ~a --destination dist"
                                    file)))
                    file))
              (begin
                (format #t "~a\n" (yellow "Cancelled — nothing was written."))
                #f))))
      (lambda args
        (display "\n")
        (format #t "~a\n" (yellow "Cancelled — nothing was written."))
        #f))))
