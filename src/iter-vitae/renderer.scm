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
  #:use-module (iter-vitae faces)
  #:export (render-curriculum))

(define* (render-curriculum #:key locale destination resources file)
  (log-info "Start rendering curriculum with settings:")
  (log-info "\tlocale: ~a" locale)
  (log-info "\tfile: ~a" file)
  (log-info "\tresources: ~a" resources)
  (log-info "\tdestination: ~a" destination)
  

  ;; choose person to generate curriculum vitae for
  (load file)

  (let* ((clean-dist-cmd (format #f "rm -rfv ~a" destination))
         (mkdir-dist-cmd (format #f "mkdir -p ~a" destination))
         (cp-to-dist-cmds (list (format #f "cp -rfv ~a/css ~a/css" resources
                                        destination)))
         ;; build a persona by blending defaults and user settings
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
                    (jobs unquote
                          (get-setting 'jobs))
                    (font unquote
                          (get-setting 'font))
                    (palette unquote
                             (get-setting 'palette)))))
    (log-info "executing: ~a" clean-dist-cmd)
    (syscall clean-dist-cmd)

    (log-info "executing: ~a" mkdir-dist-cmd)
    (syscall mkdir-dist-cmd)

    (map (lambda (c)
           (log-info "executing: ~a" c)
           (syscall c)) cp-to-dist-cmds)

    (with-output-to-file (format #f "~a/index.html" destination)
      (lambda ()
        (display (iter-vitae-curriculum-page #:locale locale
                                             #:persona persona))))
    (log-info "Completed rendering of Curriculum Vitae/Resume")))
