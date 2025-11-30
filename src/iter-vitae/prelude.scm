;;; Iter Vitae 

;; Copyright © Josep Jesus Bigorra Algaba

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
  #:export (get-setting assq-ref-all-or-lang
                        log-info
                        log-error
                        my-asset-library
                        log-message
                        log
                        mk-class
                        syscall
                        ))

(define-syntax-rule (get-setting setting)
  "Get a setting for iter-vitae, either from persona or from default values."
  (let* ((default (module-variable (resolve-module '(iter-vitae defaults))
                                   setting))
         (user-override (module-variable (resolve-module '(iter-vitae persona))
                                         setting)))
    (catch #t
           (lambda ()
             (if (equal? #f user-override)
                 (variable-ref default)
                 (variable-ref user-override)))
           (lambda (key . args)
             (variable-ref default)))))

;; for translatable fields, behave like assq-ref
;; but by ensuring if 'all is specified, it is
;; highest priority
;;
;; k is expected to be a symbol
(define-public (assq-ref-all-or-lang al k)
  (cond
    ((not (equal? #f
                  (assq 'all al)))
     (assq-ref al
               'all))
    ((not (equal? #f
                  (assq k al)))
     (assq-ref al k))
    (else (symbol->string k))))

;; mk-class: Convert a list of symbols into a CSS `class` attribute pair.
;;
;; This function takes a list of symbols representing CSS class names and
;; returns an S-expression `(class "class-names")`. The class names are
;; space-separated in a string. If the input is an empty list or `#f`,
;; it returns `(class "")`, ensuring that an empty class attribute is still valid.
(define* (mk-class xs)
  (cond
    ((nil? xs)
     "")
    (else (string-join (sort (map symbol->string
                                  (delete-duplicates xs)) string<?) " "))))

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

(define my-asset-library
  (build-asset-library '("resources/css/iter-vitae.olive.min.css")))
