;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae prelude)
  #:declarative? #t
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 ftw)
  #:export (get-setting assq-ref-all-or-lang
                        log-info
                        log-error
                        log-message
                        log
                        mk-class
                        external-url
                        tel-url
                        locale-code
                        personal-link
                        personal-contact-value
                        job-title-link
                        build-asset-library
                        load-asset-library
                        asset-css
                        decode-html-entities
                        plain-text
                        make-directories
                        delete-file-tree
                        syscall))

;; A setting is taken from the persona module when it defines it, and from the
;; defaults module otherwise.  Missing bindings (a setting that exists in
;; neither module) yield #f instead of an unbound-variable error, so adding a
;; new setting to the renderer cannot break older personas or defaults.
(define-syntax-rule (get-setting setting)
  "Get a setting for iter-vitae, either from persona or from default values."
  (let* ((default (module-variable (resolve-module '(iter-vitae defaults))
                                   setting))
         (user-override (module-variable (resolve-module '(iter-vitae persona))
                                         setting)))
    (cond
      ((and user-override (variable-bound? user-override))
       (variable-ref user-override))
      ((and default (variable-bound? default))
       (variable-ref default))
      (else #f))))

;; for translatable fields, behave like assq-ref
;; but by ensuring if 'all is specified, it is
;; highest priority
;;
;; k is expected to be a symbol
(define-public (assq-ref-all-or-lang al k)
  (if (not (list? al))
      ""
      (cond
        ((not (equal? #f
                      (assq 'all al)))
         (assq-ref al
                   'all))
        ((not (equal? #f
                      (assq k al)))
         (assq-ref al k))
        (else ""))))

;; mk-class: Convert a list of symbols into a CSS `class` attribute value.
;;
;; This function takes a list of symbols representing CSS class names and
;; returns them as one space-separated, de-duplicated and sorted string.  If the
;; input is an empty list or `#f`, it returns an empty string, so an empty class
;; attribute stays valid.
(define* (mk-class xs)
  (cond
    ((or (not xs) (nil? xs))
     "")
    (else (string-join (sort (map symbol->string
                                  (delete-duplicates xs)) string<?) " "))))

;; The language tag used for the HTML `lang' attribute: symbols become their
;; name, and anything else is printed as a string.
(define (locale-code locale)
  (if (symbol? locale)
      (symbol->string locale)
      (format #f "~a" locale)))

;; Normalise a personal link into an absolute URL.  Values that already carry a
;; scheme (for example "https://example.org" or "mailto:") are kept as they
;; are; bare hosts get an https scheme.  Empty and non-string values are #f.
(define (external-url value)
  (let ((value (and value
                    (string? value)
                    (string-trim-both value))))
    (and value
         (not (string-null? value))
         (if (string-contains value "://")
             value
             (string-append "https://" value)))))

;; Turn a phone number into a tel: URL, keeping digits and a leading plus.
(define (tel-url value)
  (let ((value (and value
                    (string? value)
                    (string-trim-both value))))
    (and value
         (not (string-null? value))
         (let ((number (string-filter (lambda (c)
                                        (or (char-numeric? c)
                                            (char=? c #\+)))
                                      value)))
           (and (not (string-null? number))
                (string-append "tel:" number))))))

;; Read the optional link behind the job title, normalized to an absolute URL.
;; Returns #f when the persona has no link, so themes can emit a plain title.
(define (job-title-link persona locale)
  (let ((links (assq-ref persona 'job-title-link)))
    (and (list? links)
         (external-url (assq-ref-all-or-lang links locale)))))

;; Read one entry of the persona's personal-links alist, or #f when absent or
;; empty.  Keeping the emptiness check here means callers never emit
;; "https://"-only anchors for links the persona did not configure.
(define (personal-link persona key)
  (let* ((links (assq-ref persona 'personal-links))
         (value (and links (assq-ref links key)))
         (value (and value
                     (string? value)
                     (string-trim-both value))))
    (and value (not (string-null? value)) value)))

;; Read one entry of the persona's personal-contact alist, or #f when absent.
(define (personal-contact-value persona key)
  (let* ((contact (assq-ref persona 'personal-contact))
         (value (and contact (assq-ref contact key)))
         (value (and value
                     (string? value)
                     (string-trim-both value))))
    (and value (not (string-null? value)) value)))

(define (log-message msg)
  (display (format #f "\n~a" msg)))

(define (log msg . args)
  (log-message (apply format
                      (append (list #f msg) args))))

(define (log-info msg . args)
  (log-message (format #f "~a"
                       (apply format
                              (append (list #f msg) args)))))

(define (log-error msg . args)
  (log-message (format #f "[error] ~a"
                       (apply format
                              (append (list #f msg) args)))))

(define (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process) process-output))

(define* (build-asset-library files)
  (let* ((lib '()))
    (for-each (lambda (f)
                (let* ((file-contents (get-string-all (open-input-file f)))
                       (min-contents (cond
                                       ((string-suffix? ".css" f)
                                        (string-replace-substring
                                         file-contents "\n" ""))
                                       (else file-contents))))
                  (set! lib
                        (assoc-set! lib f min-contents)))) files) lib))

;; Files that themes embed in the generated page.
(define asset-names
  '("iter-vitae.olive.min.css"
    "fatum.olive.min.css"))

;; Load every theme asset from @var{resources}.  The directory is a parameter
;; rather than a hard-coded path so an installed copy can keep its assets in
;; the store while the caller's working directory is somewhere else.
(define* (load-asset-library #:optional (resources "resources"))
  (let ((resources (or resources "resources")))
    (build-asset-library
     (map (lambda (name)
            (in-vicinity (in-vicinity resources "css") name))
          asset-names))))

;; Read one theme stylesheet, with newlines removed.  Stylesheets are cached by
;; path, because a page renders the same stylesheet for every locale.
(define css-cache (make-hash-table))

(define* (asset-css name #:optional (resources "resources"))
  (let* ((resources (or resources "resources"))
         (path (in-vicinity (in-vicinity resources "css") name))
         (cached (hash-ref css-cache path)))
    (or cached
        (let ((css (call-with-input-file
                       path
                     (lambda (port)
                       (string-replace-substring (get-string-all port)
                                                 "\n"
                                                 "")))))
          (hash-set! css-cache path css)
          css))))

;; Convert a persona string that may contain the inline HTML documented in the
;; README into plain text.  The ATS theme uses this so tags and HTML entities
;; never reach a resume parser: `<em class="italic">x</em>' becomes `x' and
;; `&amp;' becomes `&'.  Strings are the only supported input; anything else is
;; treated as empty.
(define (decode-html-entities value)
  (if (not (string? value))
      ""
      (let ((entities '(("&nbsp;" . " ") ("&lt;" . "<")
                        ("&gt;" . ">") ("&quot;" . "\"")
                        ("&#39;" . "'") ("&apos;" . "'")
                        ("&ndash;" . "–") ("&mdash;" . "—")
                        ("&hellip;" . "…")
                        ("&lsquo;" . "‘") ("&rsquo;" . "’")
                        ("&ldquo;" . "“") ("&rdquo;" . "”")
                        ("&bull;" . "•") ("&middot;" . "·")
                        ("&minus;" . "−") ("&times;" . "×")
                        ("&copy;" . "©") ("&reg;" . "®")
                        ("&trade;" . "™") ("&deg;" . "°")
                        ("&euro;" . "€") ("&pound;" . "£")
                        ("&yen;" . "¥")
                        ;; Keep this one last so a literal `&amp;mdash;' is
                        ;; decoded exactly once, to the text `&mdash;'.
                        ("&amp;" . "&"))))
        (fold (lambda (entity text)
                (string-replace-substring text (car entity) (cdr entity)))
              value entities))))

(define (plain-text value)
  (if (not (string? value))
      ""
      (decode-html-entities
       ;; Only real tag-shaped text is removed.  A comparison such as
       ;; "latency < 50 > budget" must survive plain-text conversion.
       (regexp-substitute/global #f "</?[a-zA-Z][^>]*>" value
                                 'pre "" 'post))))

;; Create @var{path} and every missing parent, like `mkdir -p'.  This replaces
;; shelling out to mkdir, which broke on directory names containing spaces and
;; made the destination part of a shell command line.
(define (make-directories path)
  (let ((path (if (and (string-suffix? "/" path)
                       (> (string-length path) 1))
                  (string-drop-right path 1)
                  path)))
    (cond
      ((or (string-null? path)
           (string=? path ".")
           (string=? path "..")
           (string=? path "/")
           (file-exists? path))
       #t)
      (else
       (make-directories (dirname path))
       (mkdir path)))))

;; Delete a file or a directory tree without following symlinks.  This mirrors
;; `rm -rf' without going through a shell, so destinations are never parsed as
;; shell syntax.
(define (delete-file-tree path)
  (when (file-exists? path)
    (let ((type (stat:type (lstat path))))
      (cond
        ((eq? type 'directory)
         (for-each (lambda (entry)
                     (unless (member entry '("." ".."))
                       (delete-file-tree (in-vicinity path entry))))
                   (scandir path))
         (rmdir path))
        (else
         (delete-file path))))))
