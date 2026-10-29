;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; PDF output is produced by the browser that is already needed to inspect a
;; CV: a headless Chromium/Chrome print.  We deliberately do not shell out
;; through a command string, so paths containing spaces, quotes or shell
;; metacharacters are safe.  The browser is looked up portably because the
;; project runs on GNU/Linux, macOS and Nix/Guix installations where the
;; executable is named differently.

(define-module (iter-vitae pdf)
  #:declarative? #t
  #:use-module (ice-9 format)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 textual-ports)
  #:use-module (rnrs bytevectors)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae prelude)
  #:export (browser-command render-html-to-pdf))

(define (executable-file? path)
  (catch #t
    (lambda ()
      (let ((info (stat path)))
        (and (eq? (stat:type info) 'regular)
             (not (zero? (logand (stat:mode info) #o111)))
             path)))
    (lambda args #f)))

(define (windows?)
  (or (getenv "WINDIR") (getenv "SystemRoot")))

(define (path-separator)
  (if (windows?) #\; #\:))

(define (program-extensions)
  (if (windows?)
      (let ((pathext (getenv "PATHEXT")))
        (if pathext
            (map (lambda (extension)
                   (string-downcase (string-trim-both extension)))
                 (string-split pathext #\;))
            '(".exe" ".cmd" ".bat" ".com")))
      '("")))

(define (find-in-path name)
  (let* ((path (or (getenv "PATH") ""))
         (directories (string-split path (path-separator)))
         (extensions (program-extensions))
         (candidates
          (append-map (lambda (directory)
                        (map (lambda (extension)
                               (in-vicinity directory
                                            (string-append name extension)))
                             extensions))
                      directories)))
    (find executable-file? candidates)))

(define (resolve-program value)
  (cond
    ((or (not value) (string-null? value)) #f)
    ((or (string-contains value "/")
         (string-contains value "\\"))
     (executable-file? value))
    (else (find-in-path value))))

(define (known-browser-paths)
  (let ((program-files (or (getenv "ProgramFiles") ""))
        (program-files-x86 (or (getenv "ProgramFiles(x86)") ""))
        (local-app-data (or (getenv "LOCALAPPDATA") "")))
    (filter (lambda (path) (and path (not (string-null? path))))
            (list
             "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
             "/Applications/Chromium.app/Contents/MacOS/Chromium"
             "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
             "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
             (and (not (string-null? program-files))
                  (in-vicinity program-files
                               "Google/Chrome/Application/chrome.exe"))
             (and (not (string-null? program-files-x86))
                  (in-vicinity program-files-x86
                               "Google/Chrome/Application/chrome.exe"))
             (and (not (string-null? local-app-data))
                  (in-vicinity local-app-data
                               "Google/Chrome/Application/chrome.exe"))
             (and (not (string-null? local-app-data))
                  (in-vicinity local-app-data
                               "Microsoft/Edge/Application/msedge.exe"))
             (and (not (string-null? local-app-data))
                  (in-vicinity local-app-data
                               "Chromium/Application/chrome.exe"))
             (and (not (string-null? program-files))
                  (in-vicinity program-files
                               "Chromium/Application/chrome.exe"))
             (and (not (string-null? program-files))
                  (in-vicinity program-files
                               "Microsoft/Edge/Application/msedge.exe"))))))

;; `ITER_VITAE_BROWSER' is an escape hatch for an unusual installation.  When
;; it is set it wins; a typo must not silently select a different browser.
(define (browser-command)
  (let ((explicit (getenv "ITER_VITAE_BROWSER")))
    (if explicit
        (resolve-program explicit)
        (or (find-in-path "google-chrome")
            (find-in-path "google-chrome-stable")
            (find-in-path "chromium")
            (find-in-path "chromium-browser")
            (find-in-path "ungoogled-chromium")
            (find-in-path "microsoft-edge")
            (find-in-path "brave-browser")
            (find (lambda (path) (executable-file? path))
                  (known-browser-paths))))))

;; Encode a filesystem path for a file:// URL.  Slashes stay readable; spaces,
;; `#', `?' and non-ASCII bytes are percent-encoded.
(define (unreserved-path-char? char)
  (or (char-alphabetic? char)
      (char-numeric? char)
      (member char '(#\/ #\- #\. #\_ #\~))))

(define (percent-encode-path path)
  (let loop ((characters (string->list path))
             (encoded '()))
    (if (null? characters)
        (apply string-append (reverse encoded))
        (let ((char (car characters)))
          (if (unreserved-path-char? char)
              (loop (cdr characters)
                    (cons (string char) encoded))
              (loop (cdr characters)
                    (cons (call-with-output-string
                            (lambda (port)
                              (let ((bytes (string->utf8 (string char))))
                                (let byte-loop ((index 0))
                                  (when (< index (bytevector-length bytes))
                                    (format port "%~2,'0X"
                                            (bytevector-u8-ref bytes index))
                                    (byte-loop (+ index 1)))))))
                          encoded)))))))

(define (file-url path)
  (let* ((path (canonicalize-path path))
         (path (if (windows?)
                   (string-replace-substring path "\\" "/")
                   path))
         (path (if (string-prefix? "/" path)
                   path
                   (string-append "/" path))))
    (string-append "file://" (percent-encode-path path))))

(define (valid-pdf? path)
  (and (file-exists? path)
       (let ((size (stat:size (stat path))))
         (and (> size 4)
              (call-with-input-file path
                (lambda (port)
                  (equal? (get-string-n port 4) "%PDF")))))))

(define* (browser-arguments html pdf profile #:key old-headless?)
  (append
   (list (if old-headless? "--headless" "--headless=new")
         "--disable-gpu"
         "--disable-dev-shm-usage"
         "--disable-extensions"
         "--no-first-run"
         "--no-default-browser-check"
         "--no-pdf-header-footer"
         "--print-to-pdf-no-header"
         "--log-level=3"
         "--virtual-time-budget=10000"
         "--run-all-compositor-stages-before-draw"
         (string-append "--user-data-dir=" profile)
         (string-append "--print-to-pdf=" pdf))
   (if (and (defined? 'getuid) (zero? (getuid)))
       (list "--no-sandbox")
       '())
   (list (file-url html))))

(define (run-browser browser arguments)
  ;; Chromium prints the size of the PDF on stderr even at log level 3.  The
  ;; shell only provides redirection; every browser argument remains a
  ;; separate argv element, so no persona or destination path is parsed as
  ;; shell syntax.
  (let ((status
         (if (file-exists? "/bin/sh")
             (apply system* "/bin/sh" "-c" "exec \"$@\" 2>/dev/null"
                    "iter-vitae-browser" browser arguments)
             (apply system* browser arguments))))
    (and status (zero? (status:exit-val status)))))

(define* (render-html-to-pdf html pdf #:key browser)
  "Print @var{html} to @var{pdf} with headless Chromium/Chrome."
  (let ((browser (or browser (browser-command))))
    (unless browser
      (error (string-append
              "No Chromium or Chrome found for PDF output. Install one or "
              "set ITER_VITAE_BROWSER to its executable.")))
    (unless (file-exists? html)
      (error "PDF source HTML not found:" html))
    (make-directories (dirname pdf))
    ;; A stale PDF must never make a failed print look successful.
    (when (file-exists? pdf)
      (delete-file pdf))
    (let ((profile (mkdtemp (in-vicinity (temporary-directory)
                                         "iter-vitae-pdf-XXXXXX"))))
      (dynamic-wind
        (lambda () #t)
        (lambda ()
          (unless (run-browser browser
                               (browser-arguments html pdf profile))
            ;; Chromium before 109 only understands the original spelling.
            (unless (run-browser browser
                                 (browser-arguments html pdf profile
                                                    #:old-headless? #t))
              (error "The browser could not print the CV to PDF.")))
          (unless (valid-pdf? pdf)
            (error "The browser exited without writing a valid PDF:" pdf))
          pdf)
        (lambda ()
          (catch #t
                 (lambda () (delete-file-tree profile))
                 (lambda args #t)))))))
