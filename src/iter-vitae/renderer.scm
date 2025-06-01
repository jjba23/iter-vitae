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

(define-module (iter-vitae renderer)
  #:declarative? #f
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae html) 
  #:use-module (iter-vitae prelude) 
  #:use-module (iter-vitae tailwind)
  #:export (render-curriculum))

(define* (render-curriculum #:key locale persona-file)
  (display-separator)
  (display "\n\tstarting iter-vitae\n")
  (display (format #f "\n\tconfigured with locale: ~a" locale))
  (display (format #f "\n\tconfigured with persona-file: ~a" persona-file))
  (newline)
  (display-separator)
  (newline)

  ;; choose person to generate curriculum vitae for
  (load persona-file)
  ;; then build a persona by blending defaults and user settings
  (define p
    `((display-name unquote
                    (get-setting 'display-name))
      (job-title unquote
                 (get-setting 'job-title))
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
      (education unquote
                 (get-setting 'education))
      (titles unquote
              (get-setting 'titles))
      (short-intro unquote
                   (get-setting 'short-intro))
      (jobs unquote
            (get-setting 'jobs))
      (font unquote
            (get-setting 'font))
      (palette unquote
               (get-setting 'palette))))

  (write (assq-ref (assq-ref p
                             'personal-links)
                   'blog))

  (display-separator)
  (display "about to process persona:")
  (newline)
  (write p)
  (newline)

  (with-output-to-file "dist/index.html"
    (lambda ()
      (display (iter-vitae-curriculum-page #:locale locale
                                           #:persona p)))))
