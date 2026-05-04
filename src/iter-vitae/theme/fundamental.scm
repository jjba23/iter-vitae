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

(define-module (iter-vitae theme fundamental)
  #:declarative? #t
  #:use-module (web uri)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 time)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 threads)
  #:export (fundamental-html-template fundamental-main-body))

(define* (fundamental-html-template #:key title body locale persona)
  `("<!DOCTYPE html>" (html (head (title ,title)
                                  (link (@ (rel preconnect)
                                           (href
                                            "https://fonts.googleapis.com")))
                                  (link (@ (rel preconnect)
                                           (href "https://fonts.gstatic.com")
                                           (crossorigin "")))
                                  (meta (@ (name "viewport")
                                           (content
                                            "width=device-width, initial-scale=1.0")))
                                  (meta (@ (charset "UTF-8"))))
                            (body (div ,@body
                                       ,(page-footer #:persona persona
                                                     #:locale locale))))))

(define* (page-footer #:key locale persona)
  `((hr)
    (div ,(render-blog-link #:locale locale
                            #:persona persona)
         ,(render-code-link #:locale locale
                            #:persona persona)
         ,(render-linked-in-link #:locale locale
                                 #:persona persona))
    (div (div (small "this Curriculum Vitae was rendered with "
                     (a "Lisp (Guile Scheme) code"))))))

(define* (render-display-name #:key locale persona)
  `(h1 ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let* ((jt (assq-ref persona
                       'job-title-link)))
    (cond
      ((list? jt)
       `(a (@ (href ,(assq-ref-all-or-lang jt locale)))
           ,(assq-ref-all-or-lang (assq-ref persona
                                            'job-title) locale)))
      (else `(p ,(assq-ref-all-or-lang (assq-ref persona
                                                 'job-title) locale)))))

  )

(define* (render-email #:key locale persona)
  `((div (a ,(assq-ref (assq-ref persona
                                 'personal-contact)
                       'emails)))))

(define* (render-phone-number #:key locale persona)
  `((div (small ,(assq-ref (assq-ref persona
                                     'personal-contact)
                           'phone-numbers)))))

(define* (render-blog-link #:key locale persona)
  `((div

         (a (@ (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'blog))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'blog)))))

(define* (render-code-link #:key locale persona)
  `((div

         (a (@ (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'code))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'code)))))

(define* (render-linked-in-link #:key locale persona)
  `((div

         (a (@ (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'linked-in))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'linked-in)))))

(define* (render-address-lines #:key locale persona)
  `(small ,(map (lambda (address-line)
                  `(span ,(assq-ref-all-or-lang address-line locale)))
                (assq-ref persona
                          'address-lines))))

(define* (render-driver-licenses #:key locale persona)
  `(p ,(map (lambda (driver-license)
              `(span ,(assq-ref-all-or-lang driver-license locale)))
            (assq-ref persona
                      'driver-licenses))))

(define* (render-short-intro #:key locale persona)
  (map (lambda (intro-line)
         `(p ,(assq-ref-all-or-lang intro-line locale)))
       (assq-ref persona
                 'short-intro)))

(define* (render-interests-hobbies #:key locale persona)
  (map (lambda (interest-hobby)
         `(p ,(assq-ref-all-or-lang interest-hobby locale)))
       (assq-ref persona
                 'interests-hobbies)))

(define* (render-jobs #:key locale persona)
  (map (lambda (job)
         `(div (div (span "⤷")
                    (div

                         (div (h5 ,(assq-ref-all-or-lang (assq-ref job
                                                                   'name)
                                                         locale))
                              (span "-")
                              (h5 ,(assq-ref-all-or-lang (assq-ref job
                                                                   'position)
                                                         locale)))
                         (em ,(assq-ref-all-or-lang (assq-ref job
                                                              'location)
                                                    locale))
                         (p ,(assq-ref-all-or-lang (assq-ref job
                                                             'time) locale))
                         (ul ,(map (lambda (ip)
                                     `(li (@ (style "list-style: circle"))
                                          ,(assq-ref-all-or-lang ip locale)))
                                   (assq-ref job
                                             'experience)))))))
       (assq-ref persona
                 'jobs)))

(define* (render-education #:key locale persona)
  (map (lambda (education)
         `(div (div (span "⤷")
                    (div (div (h5 ,(assq-ref-all-or-lang (assq-ref education
                                                                   'name)
                                                         locale))
                              (span "-")
                              (h5 ,(assq-ref-all-or-lang (assq-ref education
                                                                   'position)
                                                         locale)))
                         (em ,(assq-ref-all-or-lang (assq-ref education
                                                              'location)
                                                    locale))
                         (p ,(assq-ref-all-or-lang (assq-ref education
                                                             'time) locale))
                         (ul ,(map (lambda (ip)
                                     `(li (@ (style "list-style: circle"))
                                          ,(assq-ref-all-or-lang ip locale)))
                                   (assq-ref education
                                             'experience)))))))
       (assq-ref persona
                 'education)))

(define* (language-proficiency->string #:key persona locale level)
  (let* ((lp (assq-ref persona
                       'language-proficiency))
         (ll (assq-ref-all-or-lang lp locale)))
    (assoc-ref ll level)))

(define* (render-languages #:key locale persona)
  `(div (table (thead (tr (th "")
                          (th ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'speaking)
                                                     locale))
                          (th ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'reading)
                                                     locale))
                          (th ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'writing)
                                                     locale))))
               (tbody ,(map (lambda (l)
                              `((tr (td (em ,(assq-ref-all-or-lang (assq-ref l
                                                                    'name)
                                                                   locale)))
                                    (td ,(language-proficiency->string
                                          #:persona persona
                                          #:locale locale
                                          #:level (assq-ref (assq-ref l
                                                                      'proficiency)
                                                            'speaking)))
                                    (td ,(language-proficiency->string
                                          #:persona persona
                                          #:locale locale
                                          #:level (assq-ref (assq-ref l
                                                                      'proficiency)
                                                            'reading)))
                                    (td ,(language-proficiency->string
                                          #:persona persona
                                          #:locale locale
                                          #:level (assq-ref (assq-ref l
                                                                      'proficiency)
                                                            'writing))))))
                            (assq-ref persona
                                      'languages))))))

(define* (fundamental-main-body #:key locale persona)
  `((div (div ,(render-display-name #:locale locale
                                    #:persona persona)
              ,(render-job-title #:locale locale
                                 #:persona persona))
         (div ,(render-email #:locale locale
                             #:persona persona)
              ,(render-phone-number #:locale locale
                                    #:persona persona)
              ,(render-address-lines #:locale locale
                                     #:persona persona)))

    (div (h4 ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'short-intro) locale)))
    ,(render-short-intro #:locale locale
                         #:persona persona)

    (div

         (h4 ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'work-experience) locale)))
    ,(render-jobs #:locale locale
                  #:persona persona)

    (hr)
    (div

         (h4 ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'education) locale)))
    ,(render-education #:locale locale
                       #:persona persona)

    (hr)
    (div

         (h4 ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'language) locale)))
    ,(render-languages #:persona persona
                       #:locale locale)

    (hr)
    (div

         (h4 ,(string-append (assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                              'titles)
                                                             'driver-license)
                                                   locale) ":"))
         ,(render-driver-licenses #:locale locale
                                  #:persona persona))

    (hr)
    (div

         (h4 ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'interests-hobbies) locale)))
    ,(render-interests-hobbies #:locale locale
                               #:persona persona)))
