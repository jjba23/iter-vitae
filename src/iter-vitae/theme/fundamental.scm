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
  #:use-module (ice-9 time)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 threads)
  #:export (fundamental-html-template fundamental-main-body))

;; --- Theme Styles ---

(define body-style
  "font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 40px 20px;")

(define footer-container-style
  "margin-top: 50px; font-size: 0.8rem; color: #666; text-align: center; border-top: 1px solid #ddd; padding-top: 20px;")

(define footer-flex-style
  "display: flex; justify-content: center; gap: 15px; margin-bottom: 10px;")

(define link-style
  "color: inherit; text-decoration: none; border-bottom: 1px solid currentColor;")

(define email-link-style
  "color: inherit; text-decoration: none;")

(define h1-style
  "margin: 0 0 5px 0; font-size: 2.5rem; letter-spacing: -0.02em;")

(define h4-style
  "border-bottom: 1px solid #ddd; padding-bottom: 5px; margin: 35px 0 15px 0; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.1em; color: #666;")

(define h5-style
  "margin: 0; font-size: 1.1rem; font-weight: 600;")

(define subtitle-style
  "font-size: 1.2rem; color: #666;")

(define p-style
  "margin: 0 0 10px 0;")

(define section-item-style
  "margin-bottom: 25px;")

(define section-header-flex-style
  "display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 2px;")

(define time-span-style
  "font-style: italic; color: #666; font-size: 0.9rem;")

(define location-div-style
  "font-style: italic; color: #666; font-size: 0.9rem; margin-bottom: 8px;")

(define ul-style
  "margin: 5px 0 15px 0; padding-left: 20px;")

(define li-style
  "margin-bottom: 4px;")

(define table-style
  "width: 100%; border-collapse: collapse; margin-bottom: 15px;")

(define th-style
  "text-align: left; padding: 8px 0; border-bottom: 1px solid #f5f5f5; font-weight: 600; color: #666;")

(define td-style
  "text-align: left; padding: 8px 0; border-bottom: 1px solid #f5f5f5;")

(define main-body-container-style
  "margin-bottom: 40px;")

(define contact-flex-style
  "display: flex; gap: 15px; flex-wrap: wrap; font-size: 0.9rem; color: #666; margin-top: 10px;")

;; --- Templates ---

(define* (fundamental-html-template #:key title body locale persona)
  `("<!DOCTYPE html>" (html (head (title ,title)
                                  (meta (@ (name "viewport")
                                           (content
                                            "width=device-width, initial-scale=1.0")))
                                  (meta (@ (charset "UTF-8"))))
                            (body (@ (style ,body-style))
                                  (div ,@body
                                       ,(page-footer #:persona persona
                                                     #:locale locale))))))

(define* (page-footer #:key locale persona)
  `(div (@ (style ,footer-container-style))
        (div (@ (style ,footer-flex-style))
             ,(render-blog-link #:locale locale
                                #:persona persona)
             ,(render-code-link #:locale locale
                                #:persona persona)
             ,(render-linked-in-link #:locale locale
                                     #:persona persona))
        (div (small "Rendered with "
                    (a (@ (style ,link-style)
                          (href "https://www.gnu.org/software/guile/"))
                       "Lisp (Guile Scheme)")))))

(define* (render-display-name #:key locale persona)
  `(h1 (@ (style ,h1-style))
       ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let* ((jt (assq-ref persona
                       'job-title-link)))
    (cond
      ((list? jt)
       `(div (@ (style ,subtitle-style))
             (a (@ (style ,link-style)
                   (href ,(assq-ref-all-or-lang jt locale)))
                ,(assq-ref-all-or-lang (assq-ref persona
                                                 'job-title) locale))))
      (else `(div (@ (style ,subtitle-style))
                  ,(assq-ref-all-or-lang (assq-ref persona
                                                   'job-title) locale))))))

(define* (render-email #:key locale persona)
  `(div (a (@ (style ,email-link-style)
              (href ,(string-append "mailto:"
                                    (assq-ref (assq-ref persona
                                                        'personal-contact)
                                              'emails))))
           ,(assq-ref (assq-ref persona
                                'personal-contact)
                      'emails))))

(define* (render-phone-number #:key locale persona)
  `(div ,(assq-ref (assq-ref persona
                             'personal-contact)
                   'phone-numbers)))

(define* (render-blog-link #:key locale persona)
  `(div (a (@ (style ,link-style)
              (target "_blank")
              (href ,(format #f "https://~a"
                             (assq-ref (assq-ref persona
                                                 'personal-links)
                                       'blog)))) "Blog")))

(define* (render-code-link #:key locale persona)
  `(div (a (@ (style ,link-style)
              (target "_blank")
              (href ,(format #f "https://~a"
                             (assq-ref (assq-ref persona
                                                 'personal-links)
                                       'code)))) "Code")))

(define* (render-linked-in-link #:key locale persona)
  `(div (a (@ (style ,link-style)
              (target "_blank")
              (href ,(format #f "https://~a"
                             (assq-ref (assq-ref persona
                                                 'personal-links)
                                       'linked-in)))) "LinkedIn")))

(define* (render-address-lines #:key locale persona)
  `(div ,(string-join (map (lambda (address-line)
                             (assq-ref-all-or-lang address-line locale))
                           (assq-ref persona
                                     'address-lines)) ", ")))

(define* (render-driver-licenses #:key locale persona)
  `(p (@ (style ,p-style))
      ,(string-join (map (lambda (driver-license)
                           (assq-ref-all-or-lang driver-license locale))
                         (assq-ref persona
                                   'driver-licenses)) ", ")))

(define* (render-short-intro #:key locale persona)
  (map (lambda (intro-line)
         `(p (@ (style ,p-style))
             ,(assq-ref-all-or-lang intro-line locale)))
       (assq-ref persona
                 'short-intro)))

(define* (render-interests-hobbies #:key locale persona)
  (map (lambda (interest-hobby)
         `(p (@ (style ,p-style))
             ,(assq-ref-all-or-lang interest-hobby locale)))
       (assq-ref persona
                 'interests-hobbies)))

(define* (render-jobs #:key locale persona)
  (map (lambda (job)
         `(div (@ (style ,section-item-style))
               (div (@ (style ,section-header-flex-style))
                    (h5 (@ (style ,h5-style))
                        ,(string-append (assq-ref-all-or-lang (assq-ref job
                                                                        'position)
                                                              locale) ", "
                                        (assq-ref-all-or-lang (assq-ref job
                                                                        'name)
                                                              locale)))
                    (span (@ (style ,time-span-style))
                          ,(assq-ref-all-or-lang (assq-ref job
                                                           'time) locale)))
               (div (@ (style ,location-div-style))
                    ,(assq-ref-all-or-lang (assq-ref job
                                                     'location) locale))
               (ul (@ (style ,ul-style))
                   ,(map (lambda (ip)
                           `(li (@ (style ,li-style))
                                ,(assq-ref-all-or-lang ip locale)))
                         (assq-ref job
                                   'experience)))))
       (assq-ref persona
                 'jobs)))

(define* (render-education #:key locale persona)
  (map (lambda (education)
         `(div (@ (style ,section-item-style))
               (div (@ (style ,section-header-flex-style))
                    (h5 (@ (style ,h5-style))
                        ,(string-append (assq-ref-all-or-lang (assq-ref
                                                               education
                                                               'position)
                                                              locale) ", "
                                        (assq-ref-all-or-lang (assq-ref
                                                               education
                                                               'name) locale)))
                    (span (@ (style ,time-span-style))
                          ,(assq-ref-all-or-lang (assq-ref education
                                                           'time) locale)))
               (div (@ (style ,location-div-style))
                    ,(assq-ref-all-or-lang (assq-ref education
                                                     'location) locale))
               (ul (@ (style ,ul-style))
                   ,(map (lambda (ip)
                           `(li (@ (style ,li-style))
                                ,(assq-ref-all-or-lang ip locale)))
                         (assq-ref education
                                   'experience)))))
       (assq-ref persona
                 'education)))

(define* (language-proficiency->string #:key persona locale level)
  (let* ((lp (assq-ref persona
                       'language-proficiency))
         (ll (assq-ref-all-or-lang lp locale)))
    (assoc-ref ll level)))

(define* (render-languages #:key locale persona)
  `(div (table (@ (style ,table-style))
               (thead (tr (th (@ (style ,th-style)) "")
                          (th (@ (style ,th-style))
                              ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'speaking)
                                                     locale))
                          (th (@ (style ,th-style))
                              ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'reading)
                                                     locale))
                          (th (@ (style ,th-style))
                              ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'writing)
                                                     locale))))
               (tbody ,(map (lambda (l)
                              `(tr (td (@ (style ,td-style))
                                       (strong ,(assq-ref-all-or-lang (assq-ref
                                                                       l
                                                                       'name)
                                                                      locale)))
                                   (td (@ (style ,td-style))
                                       ,(language-proficiency->string
                                                                      #:persona
                                                                      persona
                                                                      #:locale
                                                                      locale
                                                                      #:level (assq-ref
                                                                               (assq-ref
                                                                                l
                                                                                'proficiency)
                                                                               'speaking)))
                                   (td (@ (style ,td-style))
                                       ,(language-proficiency->string
                                                                      #:persona
                                                                      persona
                                                                      #:locale
                                                                      locale
                                                                      #:level (assq-ref
                                                                               (assq-ref
                                                                                l
                                                                                'proficiency)
                                                                               'reading)))
                                   (td (@ (style ,td-style))
                                       ,(language-proficiency->string
                                                                      #:persona
                                                                      persona
                                                                      #:locale
                                                                      locale
                                                                      #:level (assq-ref
                                                                               (assq-ref
                                                                                l
                                                                                'proficiency)
                                                                               'writing)))))
                            (assq-ref persona
                                      'languages))))))

(define* (fundamental-main-body #:key locale persona)
  `((div (@ (style ,main-body-container-style))
         ,(render-display-name #:locale locale
                               #:persona persona)
         ,(render-job-title #:locale locale
                            #:persona persona)
         (div (@ (style ,contact-flex-style))
              ,(render-email #:locale locale
                             #:persona persona)
              ,(render-phone-number #:locale locale
                                    #:persona persona)
              ,(render-address-lines #:locale locale
                                     #:persona persona)))
    
    (h4 (@ (style ,h4-style))
        ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                   'titles)
                                         'short-intro) locale))
    ,@(render-short-intro #:locale locale
                          #:persona persona)

    (h4 (@ (style ,h4-style))
        ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                   'titles)
                                         'work-experience) locale))
    ,@(render-jobs #:locale locale
                   #:persona persona)

    (h4 (@ (style ,h4-style))
        ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                   'titles)
                                         'education) locale))
    ,@(render-education #:locale locale
                        #:persona persona)

    (h4 (@ (style ,h4-style))
        ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                   'titles)
                                         'language) locale))
    ,(render-languages #:persona persona
                       #:locale locale)

    ,(unless (nil? (assq-ref persona
                             'driver-licenses))
       `((h4 (@ (style ,h4-style))
             ,(string-append (assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                              'titles)
                                                             'driver-license)
                                                   locale) ":"))
         ,(render-driver-licenses #:locale locale
                                  #:persona persona)))

    ,(unless (nil? (assq-ref persona
                             'interests-hobbies))
       `((h4 (@ (style ,h4-style))
             ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'interests-hobbies) locale))
         ,@(render-interests-hobbies #:locale locale
                                     #:persona persona)))))
