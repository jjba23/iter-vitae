;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae renderer)
  #:declarative? #f
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae html)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae text)
  #:export (render-curriculum persona-locales))

;; Collect the keys of one translation-alist, ignoring the language-independent
;; `all' fallback.
(define (translation-locales alist)
  (if (list? alist)
      (filter-map (lambda (entry)
                    (and (pair? entry)
                         (symbol? (car entry))
                         (not (eq? (car entry) 'all))
                         (car entry)))
                  alist)
      '()))

;; Collect locales from a list of translation-alists (bullets, address lines,
;; paragraphs, skills, ...).
(define (translation-list-locales values)
  (if (list? values)
      (append-map translation-locales values)
      '()))

;; A job or education entry has several translated fields plus a translated
;; bullet list.
(define (entry-locales entry)
  (if (list? entry)
      (append (translation-locales (assq-ref entry 'name))
              (translation-locales (assq-ref entry 'location))
              (translation-locales (assq-ref entry 'position))
              (translation-locales (assq-ref entry 'time))
              (translation-list-locales (assq-ref entry 'experience)))
      '()))

;; Each language row is (code . ((name . translation-alist) ...)).
(define (language-locales languages)
  (if (list? languages)
      (append-map
       (lambda (entry)
         (let ((profile (and (pair? entry) (cdr entry))))
           (translation-locales (and profile (assq-ref profile 'name)))))
       languages)
      '()))

;; The locales a persona actually uses.  The default titles contain en/nl/es
;; headings for fallback, so they are deliberately not counted as content.
(define* (persona-locales persona #:key (fallback 'en))
  (let* ((keys
          (append
           (translation-locales (assq-ref persona 'display-name))
           (translation-locales (assq-ref persona 'job-title))
           (translation-locales (assq-ref persona 'job-title-link))
           (translation-list-locales (assq-ref persona 'address-lines))
           (translation-list-locales (assq-ref persona 'driver-licenses))
           (translation-list-locales (assq-ref persona 'interests-hobbies))
           (translation-list-locales (assq-ref persona 'short-intro))
           (translation-list-locales (assq-ref persona 'skills))
           (append-map entry-locales (or (assq-ref persona 'jobs) '()))
           (append-map entry-locales (or (assq-ref persona 'education) '()))
           (language-locales (assq-ref persona 'languages))))
         (keys (sort (delete-duplicates keys eq?)
                     (lambda (left right)
                       (string<? (locale-code left) (locale-code right))))))
    (if (null? keys)
        (list fallback)
        keys)))

;; A locale code is also a directory name.  Reject anything that could escape
;; the destination instead of trusting a symbol from a persona file.
(define (locale-directory locale)
  (let ((code (locale-code locale)))
    (unless (and (not (string=? code "all"))
                 (string-match "^[A-Za-z][A-Za-z0-9-]*$" code))
      (error "Invalid locale for --all-locales:" code))
    code))

;; Write one document.  The caller owns the destination lifecycle, because the
;; all-locales mode writes several documents below one freshly-cleared root.
(define* (write-curriculum #:key persona locale destination resources text?)
  (make-directories destination)
  (if text?
      (with-output-to-file (in-vicinity destination "resume.txt")
        (lambda ()
          (display (render-plain-text #:locale locale
                                      #:persona persona))))
      (with-output-to-file (in-vicinity destination "index.html")
        (lambda ()
          (display (iter-vitae-curriculum-page #:locale locale
                                               #:persona persona
                                               #:resources resources))))))

(define* (render-all-locales #:key persona locale destination resources text?)
  (let* ((locales (persona-locales persona #:fallback (or locale 'en)))
         ;; Validate every directory name before deleting the destination, so
         ;; a bad locale cannot destroy existing output and then fail.
         (targets (map (lambda (current-locale)
                         (cons current-locale
                               (locale-directory current-locale)))
                       locales)))
    (log-info "\tlocales: ~a"
              (string-join (map locale-code locales) ", "))
    ;; The destination is a filesystem path, never a shell command line, so
    ;; names containing spaces or metacharacters are safe.
    (log-info "removing: ~a" destination)
    (delete-file-tree destination)

    (log-info "creating: ~a" destination)
    (make-directories destination)

    (for-each
     (lambda (target)
       (let ((current-locale (car target))
             (directory (in-vicinity destination (cdr target))))
         (log-info "rendering locale ~a into ~a" current-locale directory)
         (write-curriculum #:persona persona
                           #:locale current-locale
                           #:destination directory
                           #:resources resources
                           #:text? text?)))
     targets)
    (log-info "Completed rendering of Curriculum Vitae/Resume")))

(define* (render-curriculum #:key locale (destination "./dist")
                            (resources "resources") file (format "html")
                            (all-locales? #f))
  (let* ((resources (or resources "resources"))
         (destination (or destination "./dist"))
         (output-format (cond
                           ((symbol? format) (symbol->string format))
                           ((string? format) format)
                           (else (error "Invalid output format" format))))
         (output-format (string-downcase output-format))
         (text? (member output-format '("text" "txt")))
         (html? (member output-format '("html" "htm"))))
    ;; Validate before touching the destination, so a typo cannot delete an
    ;; existing resume and then fail.
    (unless (or text? html?)
      (error "Unknown output format; expected 'html' or 'text':" format))
    (log-info "Start rendering curriculum with settings:")
    (log-info "\tlocale: ~a" locale)
    (log-info "\tfile: ~a" file)
    (log-info "\tresources: ~a" resources)
    (log-info "\tdestination: ~a" destination)
    (log-info "\tformat: ~a" output-format)
    (log-info "\tall locales: ~a" (if all-locales? "yes" "no"))

    ;; choose person to generate curriculum vitae for
    (load file)

    (let* (;; build a persona by blending defaults and user settings
         (persona `((display-name unquote
                                  (get-setting 'display-name))
                    (job-title unquote
                               (get-setting 'job-title))
                    (job-title-link unquote
                                    (get-setting 'job-title-link))
                    (personal-contact unquote
                                      (get-setting 'personal-contact))
                    (personal-links unquote
                                    (get-setting 'personal-links))
                    (address-lines unquote
                                   (get-setting 'address-lines))
                    (driver-licenses unquote
                                     (get-setting 'driver-licenses))
                    (interests-hobbies unquote
                                       (get-setting 'interests-hobbies))
                    (languages unquote
                               (get-setting 'languages))
                    (language-proficiency unquote
                                          (get-setting 'language-proficiency))
                    (education unquote
                               (get-setting 'education))
                    (titles unquote
                            (get-setting 'titles))
                    (short-intro unquote
                                 (get-setting 'short-intro))
                    (skills unquote
                            (get-setting 'skills))
                    (jobs unquote
                          (get-setting 'jobs))
                    (document-theme unquote
                                    (get-setting 'document-theme)))))
      (if all-locales?
          (render-all-locales #:persona persona
                              #:locale locale
                              #:destination destination
                              #:resources resources
                              #:text? text?)
          (begin
            ;; The destination is a filesystem path, never a shell command line,
            ;; so names containing spaces or metacharacters are safe.
            (log-info "removing: ~a" destination)
            (delete-file-tree destination)

            (log-info "creating: ~a" destination)
            (make-directories destination)

            (write-curriculum #:persona persona
                              #:locale locale
                              #:destination destination
                              #:resources resources
                              #:text? text?)
            (log-info "Completed rendering of Curriculum Vitae/Resume"))))))
