;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (maak)
  #:use-module (maak maak)
  ;; The container helpers are imported under a prefix because the tasks
  ;; below are named the way maak exposes them on the command line, and a
  ;; task may not shadow the helper it calls.
  #:use-module ((maak container) #:prefix ct:)
  #:declarative? #t)

;; ====== Maak constants ======

;; The path to the directory where the main project files will be deployed.
(define deploy-dir
  "/srv/http/jointhefreeworld.org")

;; The URL for the CSS stylesheet used to style API documentation.
(define api-docs-css-url
  "https://jointhefreeworld.org/static/css/jointhefreeworld.css")

(define project-name
  'iter-vitae)

(define hot-reload-file-types
  '(scm))

;; ====== Maak tasks ======

(define (help)
  "Display program help screen."
  (time-machine-program-shell (list "iter-vitae" "--help")))

(define (default)
  "Default task to run, call program's help."
  (list-tasks))

(define (fmt)
  "Format Scheme source code files according to the Guix style guide."
  ;; The task named `run' below shadows the helper of the same name, so the
  ;; module that defines it is named here.
  ((@ (maak maak) run)
   (list "find" "." "-maxdepth" "8" "-name" "*.scm"
         "-type" "f" "-exec" "guix" "style" "-f" "{}" ";")
   #:verbose? #t))

(define (test)
  "Run the Veritas unit test suite."
  (manifest-shell (list "guile" "--fresh-auto-compile" "-L" "./src" "-L" "./test"
                        "-c" "'((@ (veritas runner) run-tests))'")
                  #:env '("VERITAS_TEST_TYPE=unit"
                          "VERITAS_RUN_BENCHMARKS=false")
                  #:verbose? #t))

(define (repl)
  "Development REPL."
  (manifest-shell (list "guile" "-L" "./src"
                        "-c" "'((@ (ares server) run-nrepl-server))'")))

(define (docs)
  "Generate technical API documentation for Maak."
  (delete-file-recursively "doc")
  (time-machine-manifest-shell (list "documenta" "api"
                                     (~ "./src/~a" project-name)))
  (time-machine-manifest-shell (list "texi2any" "-v" "--html"
                                     (~ "--css-ref=~a" api-docs-css-url)
                                     "./doc/api/index.texi"))
  (mv "./index" "./doc/api-dist"))

(define (deploy)
  "Deploy Iter Vitae."
  ;; english
  (run-joe-en)
  (docs)
  (delete-file-recursively (~ "~a/joe-cv" deploy-dir))
  (mv "dist"
      (~ "~a/joe-cv" deploy-dir))

  ;; dutch
  (run-joe-nl)
  (mv "dist"
      (~ "~a/joe-cv/nl" deploy-dir))

  ;; spanish
  (run-joe-es)
  (mv "dist"
      (~ "~a/joe-cv/es" deploy-dir))

  ;; Deploy API docs
  (remkdir-p (~ "~a/api-docs/~a" deploy-dir project-name))
  (mv "doc/api-dist/*"
      (~ "~a/api-docs/~a" deploy-dir project-name)
      #:expand? #t)
  (delete-file-recursively "doc"))

(define (package-docker)
  "Build the container image for Iter Vitae."
  ;; `guix-pack' would run the ambient Guix; this project builds its image at
  ;; the revision channels.scm pins, inside the manifest shell, as before.
  (time-machine-manifest-shell
   (list "guix" "pack" "--file=./guix.scm" "--format=docker"
         "--image-tag=iter-vitae" "-S" "/bin=bin"
         "bash" "coreutils" "util-linux-with-udev" "guile")))

(define (push-docker-latest)
  "Push the latest locally generated Docker image to Dockerhub."
  (ct:container (list "push"
                      (~ "localhost/~a:latest" project-name)
                      (~ "docker.io/jjba23/~a:latest" project-name))
                #:verbose? #t))

(define (push-docker-tag)
  "Push the locally generated Docker image to Dockerhub."
  (git-fetch "--all")
  ;; A dry run asks git nothing, so the tag read here comes back empty and the
  ;; command below is printed without one; a real run reads the tag first and
  ;; raises if there is none.
  (let ((latest-tag (git-describe-tag)))
    (ct:container (list "push"
                        (~ "localhost/~a:latest" project-name)
                        (~ "docker.io/jjba23/~a:~a" project-name latest-tag))
                  #:verbose? #t)))

(define (dev-run* persona locale)
  (time-machine-manifest-shell
   (list "guile" "-L" "./src"
         "-c" "'((@(iter-vitae main) main))'"
         (~ "--file /home/joe/Hacking/iter-vitae/populus/~a.scm" persona)
         "--destination" "./dist"
         (~ "--locale ~a" locale)
         "--resources" "./resources")
   #:verbose? #t))

(define (run* persona locale)
  (time-machine-program-shell
   (list "iter-vitae" (~ "--file ./populus/~a.scm" persona)
         "--destination" "./dist"
         (~ "--locale ~a" locale))))

(define (run)
  (run* 'joe
        'en))

(define (dev-run)
  (dev-run* 'joe
            'en))

(define (run-joe-en)
  (run* 'joe
        'en))

(define (run-joe-es)
  (run* 'joe
        'es))

(define (run-joe-nl)
  (run* 'joe
        'nl))

(define (dev-run-joe-en)
  (dev-run* 'joe
            'en))
(define (dev-run-joe-nl)
  (dev-run* 'joe
            'nl))

(define (dev-run-joe-es)
  (dev-run* 'joe
            'es))

(define (hot-reload)
  "Hot-reloading developer's setup."
  (time-machine-manifest-shell
   (list "watchexec"
         "--clear"
         (~ "--exts ~a"
            (string-join (map symbol->string
                              hot-reload-file-types)
                         ","))
         "--on-busy-update=restart"
         "--shell" "bash"
         "--watch" "." "--"
         "maak" "dev-run-joe-en")))

(define (hr)
  "Alias to hot-reloading."
  (hot-reload))

(define (dev)
  "Developer's setup."
  (hot-reload))

(define (olive-css)
  (curl-download
   "https://codeberg.org/jjba23/olive-css/raw/branch/trunk/resources/css/iter-vitae.olive.min.css"
   #:output "./resources/css/iter-vitae.olive.min.css"
   #:verbose? #t)
  (curl-download
   "https://codeberg.org/jjba23/olive-css/raw/branch/trunk/resources/css/fatum.olive.min.css"
   #:output "./resources/css/fatum.olive.min.css"
   #:verbose? #t))

;; ====== Container tasks ======

(define (container-build)
  "Build the container image for iter-vitae."
  (ct:container-build "." #:tag "iter-vitae:latest" #:verbose? #t))

(define (container-run)
  "Run the container image for iter-vitae."
  (ct:container-run "iter-vitae" #:interactive? #t #:tty? #t #:verbose? #t))
