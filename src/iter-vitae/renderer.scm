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

(define-module (iter-vitae renderer)
  #:declarative? #f
  #:use-module (iter-vitae defaults)
  #:use-module (iter-vitae html)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae text)
  #:export (render-curriculum))

(define* (render-curriculum #:key locale (destination "./dist")
                            (resources "resources") file (format "html"))
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
      ;; The destination is a filesystem path, never a shell command line, so
      ;; names containing spaces or metacharacters are safe.
      (log-info "removing: ~a" destination)
      (delete-file-tree destination)

      (log-info "creating: ~a" destination)
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
                                                   #:resources resources)))))
      (log-info "Completed rendering of Curriculum Vitae/Resume"))))
