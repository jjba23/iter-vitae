;;; Iter Vitae 

;; Copyright © Josep Jesus Bigorra Algaba

;; iter-vitae is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; iter-vitae is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
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
  #:export (get-setting display-separator assq-ref-all-or-lang mk-class
                        syscall))

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

(define (display-separator)
  (display "
====================================================
"))

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
;;
;; Examples:
;; (mk-class '())                       ⇒ ""
;; (mk-class '(p-2 bg-stone-900/75))    ⇒ "bg-stone-900/75 p-2 "
;; (mk-class #f)                        ⇒ ""
;;
(define* (mk-class xs)
  (cond
    ((nil? xs)
     "")
    (else (string-join (sort (map symbol->string
                                  (delete-duplicates xs)) string<?) " "))))

(define (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process) process-output))
