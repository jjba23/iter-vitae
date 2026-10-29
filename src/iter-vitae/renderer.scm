;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae renderer)
  #:declarative? #f
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae html)
  #:use-module (iter-vitae pdf)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae text)
  #:use-module (iter-vitae theme registry)
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

(define (persona-with-theme persona theme)
  "Return @var{persona} with @var{theme} selected."
  (cons (cons 'document-theme theme)
        (remove (lambda (pair)
                  (eq? (car pair) 'document-theme))
                persona)))

;; Write the HTML source of one document.
(define* (write-html #:key persona locale destination resources)
  (with-output-to-file (in-vicinity destination "index.html")
    (lambda ()
      (display (iter-vitae-curriculum-page #:locale locale
                                           #:persona persona
                                           #:resources resources)))))

(define* (write-text #:key persona locale destination)
  (with-output-to-file (in-vicinity destination "resume.txt")
    (lambda ()
      (display (render-plain-text #:locale locale
                                  #:persona persona)))))

;; PDF output is printed from a temporary HTML file.  The HTML is deliberately
;; not copied into the destination: `--format pdf' asks for a document, not a
;; second copy of an intermediate build artifact.
(define* (write-pdf #:key persona locale destination resources)
  (let ((temporary
         (mkdtemp (in-vicinity (temporary-directory)
                               "iter-vitae-pdf-XXXXXX"))))
    (dynamic-wind
      (lambda () #t)
      (lambda ()
        (let ((html (in-vicinity temporary "index.html"))
              (pdf (in-vicinity destination "resume.pdf")))
          (write-html #:persona persona
                      #:locale locale
                      #:destination temporary
                      #:resources resources)
          (render-html-to-pdf html pdf)
          pdf))
      (lambda ()
        (catch #t
               (lambda () (delete-file-tree temporary))
               (lambda args #t))))))

;; Write one document.  The caller owns the destination lifecycle, because
;; all-locales and all-themes modes write several documents below one freshly
;; cleared root.
(define* (write-curriculum #:key persona locale destination resources format)
  (make-directories destination)
  (case format
    ((html)
     (write-html #:persona persona
                 #:locale locale
                 #:destination destination
                 #:resources resources))
    ((text)
     (write-text #:persona persona
                 #:locale locale
                 #:destination destination))
    ((pdf)
     (write-pdf #:persona persona
                #:locale locale
                #:destination destination
                #:resources resources))
    (else
     (error "Unknown output format:" format))))

(define* (output-directory destination theme locale all-themes? all-locales?)
  "Return the directory for one theme/locale pair."
  (let ((theme-subdir (in-vicinity destination (symbol->string theme)))
        (locale-subdir (in-vicinity destination (locale-code locale))))
    (cond
      ((and all-themes? all-locales?)
       (in-vicinity theme-subdir (locale-code locale)))
      (all-themes? theme-subdir)
      (all-locales? locale-subdir)
      (else destination))))

(define* (render-curriculum #:key locale (destination "./dist")
                            (resources "resources") file (format "html")
                            (all-locales? #f) (all-themes? #f))
  (let* ((resources (or resources "resources"))
         (destination (or destination "./dist"))
         ;; `load' searches the Guile load path for a relative name.  Resolve
         ;; the persona once so a command run from any directory behaves like
         ;; the documented examples.
         (file (canonicalize-path file))
         (requested-format (cond
                             ((symbol? format) (symbol->string format))
                             ((string? format) format)
                             (else (error "Invalid output format" format))))
         (output-format (string-downcase requested-format))
         (document-format (cond
                            ((member output-format '("html" "htm")) 'html)
                            ((member output-format '("text" "txt")) 'text)
                            ((string=? output-format "pdf") 'pdf)
                            (else
                             (error "Unknown output format; expected 'html, 'text or 'pdf:"
                                    format)))))
    ;; Validate before touching the destination, so a typo cannot delete an
    ;; existing resume and then fail.
    (when (and all-themes? (eq? document-format 'text))
      (error "--all-themes cannot be combined with --format text"))
    (when (eq? document-format 'pdf)
      (unless (browser-command)
        (error (string-append
                "PDF output needs Chromium or Chrome. Install one or set "
                "ITER_VITAE_BROWSER to its executable."))))
    (log-info "Start rendering curriculum with settings:")
    (log-info "\tlocale: ~a" locale)
    (log-info "\tfile: ~a" file)
    (log-info "\tresources: ~a" resources)
    (log-info "\tdestination: ~a" destination)
    (log-info "\tformat: ~a" output-format)
    (log-info "\tall locales: ~a" (if all-locales? "yes" "no"))
    (log-info "\tall themes: ~a" (if all-themes? "yes" "no"))

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
                      (profile-picture unquote
                                       (and (not (eq? document-format 'text))
                                            (resolve-profile-picture
                                             (get-setting 'profile-picture)
                                             (dirname (canonicalize-path file)))))
                      (document-theme unquote
                                      (get-setting 'document-theme))))
           (themes (if all-themes?
                       document-themes
                       (list (normalize-theme
                              (assq-ref persona 'document-theme)))))
           (locales (if all-locales?
                        (persona-locales persona #:fallback (or locale 'en))
                        (list locale)))
           (targets (append-map
                     (lambda (theme)
                       (map (lambda (current-locale)
                              (cons theme current-locale))
                            locales))
                     themes)))

      ;; Validate every locale directory name before deleting the destination,
      ;; so a bad locale cannot destroy existing output and then fail.
      (when all-locales?
        (for-each (lambda (target)
                    (locale-directory (cdr target)))
                  targets))

      (when all-locales?
        (log-info "\tlocales: ~a"
                  (string-join (map (lambda (current-locale)
                                      (locale-code current-locale))
                                    locales)
                               ", ")))

      ;; The destination is a filesystem path, never a shell command line, so
      ;; names containing spaces or metacharacters are safe.
      (log-info "removing: ~a" destination)
      (delete-file-tree destination)

      (log-info "creating: ~a" destination)
      (make-directories destination)

      (for-each
       (lambda (target)
         (let* ((theme (car target))
                (current-locale (cdr target))
                (directory (output-directory destination theme current-locale
                                             all-themes? all-locales?)))
           (log-info "rendering ~a for ~a into ~a"
                     theme current-locale directory)
           (write-curriculum #:persona (persona-with-theme persona theme)
                             #:locale current-locale
                             #:destination directory
                             #:resources resources
                             #:format document-format)))
       targets)
      (log-info "Completed rendering of Curriculum Vitae/Resume"))))
