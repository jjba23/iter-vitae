;; Iter Vitae

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; iter-vitae is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; iter-vitae is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public License
;; along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

(define-module (maak)
  #:use-module (maak maak)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 popen)
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

;; ====== Maak abstractions ======

(define (syscall-with-output cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process) process-output))

;; ====== Maak tasks ======

(define (help)
  "Display program help screen."
  (time-machine-program-shell '("iter-vitae --help")))

(define (default)
  "Default task to run, call program's help."
  (list-tasks))

(define (fmt)
  "Format Scheme source code files according to the Guix style guide."
  ($ '("find . -maxdepth 8 -name '*.scm'" "-type f -exec guix style -f {} \\;")
     #:verbose? #t))

(define (test)
  "Run the Veritas unit test suite."
  (manifest-shell '("env VERITAS_TEST_TYPE=unit VERITAS_RUN_BENCHMARKS=false"
                    "guile --fresh-auto-compile -L ./src -L ./test"
                    "-c '((@ (veritas runner) run-tests))'")
                  #:verbose? #t))

(define (repl)
  "Development REPL."
  (manifest-shell '("guile -L ./src"
                    "-c '((@ (ares server) run-nrepl-server))'")))

(define (docs)
  "Generate technical API documentation for Maak."
  (delete-file-recursively "doc")
  (time-machine-manifest-shell (list (~ "documenta api ./src/~a && "
                                        project-name)
                                     (~ "texi2any -v --html --css-ref=~a"
                                        api-docs-css-url)
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
      (~ "~a/api-docs/~a" deploy-dir project-name))
  (delete-file-recursively "doc"))

(define (package-docker)
  "Create a Docker image for Iter Vitae."
  (time-machine-manifest-shell '("guix pack --file=./guix.scm"
                                 "--format=docker" "--image-tag=iter-vitae"
                                 "-S /bin=bin"
                                 "bash coreutils util-linux-with-udev guile")))

(define (push-docker-latest)
  "Push the latest locally generated Docker image to Dockerhub."
  ($ (list (~ "podman push localhost/~a:latest" project-name)
           (~ "docker.io/jjba23/~a:latest" project-name))
     #:verbose? #t))

(define (push-docker-tag)
  "Push the locally generated Docker image to Dockerhub."
  ($ '("git fetch --all"))
  (let* ((latest-tag (syscall-with-output "git describe --tags --abbrev=0")))
    ($ (list (~ "podman push localhost/~a:latest" project-name)
             (~ "docker.io/jjba23/~a:~a" project-name latest-tag))
       #:verbose? #t)))

(define (dev-run* persona locale)
  (time-machine-manifest-shell (list
                                "guile -L ./src -c '((@(iter-vitae main) main))'"
                                (~
                                 "--file /home/joe/Hacking/iter-vitae/populus/~a.scm"
                                 persona) "--destination ./dist"
                                (~ "--locale ~a" locale)
                                "--resources ./resources")
                               #:verbose? #t))

(define (run* persona locale)
  (time-machine-program-shell (list (~ "iter-vitae --file ./populus/~a.scm"
                                       persona) "--destination ./dist"
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
  (time-machine-manifest-shell (list "watchexec"
                                     "--clear"
                                     (~ "--exts ~a"
                                        (string-join (map symbol->string
                                                      hot-reload-file-types)
                                                     ","))
                                     "--on-busy-update=restart"
                                     "--shell bash"
                                     "--watch . --"
                                     "maak dev-run-joe-en")))

(define (hr)
  "Alias to hot-reloading."
  (hot-reload))

(define (dev)
  "Developer's setup."
  (hot-reload))

(define (olive-css)
  ($ '("curl --verbose --output \"./resources/css/iter-vitae.olive.min.css\""
       "\"https://codeberg.org/jjba23/olive-css/raw/branch/trunk/resources/css/iter-vitae.olive.min.css\""))
  ($ '("curl --verbose --output \"./resources/css/fatum.olive.min.css\""
       "\"https://codeberg.org/jjba23/olive-css/raw/branch/trunk/resources/css/fatum.olive.min.css\"")))
