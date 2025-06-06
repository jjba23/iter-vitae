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

(define-module (iter-vitae main)
  #:declarative? #t
  #:use-module (ice-9 getopt-long)
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae renderer)
  #:use-module (iter-vitae tailwind)
  #:export (main))

(define* (main #:key (args (command-line)))
  (let* ((option-spec '((locale (single-char #\l)
                                (value #t))
                        (output-dir (single-char #\o)
                                    (value #t))
                        (resources-dir (single-char #\r)
                                       (value #t))
                        (persona-file (single-char #\p)
                                      (value #t)
                                      (required? #t))))
         
         (options (getopt-long args option-spec))
         (persona-file (option-ref options
                                   'persona-file #f))
         (output-dir (option-ref options
                                 'output-dir "./dist"))
         (resources-dir (option-ref options
                                    'resources-dir #f))
         (locale (option-ref options
                             'locale "en")))
    (log-info
     "Iter Vitae: Generate an attractive, modern and customizable Curriculum Vitae/Resume")
    (render-curriculum #:locale (string->symbol locale)
                       #:output-dir output-dir
                       #:resources-dir resources-dir
                       #:persona-file persona-file)))
