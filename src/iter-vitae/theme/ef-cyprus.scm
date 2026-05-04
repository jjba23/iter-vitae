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

(define-module (iter-vitae theme ef-cyprus)
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
  #:use-module (iter-vitae theme ef-cyprus-faces)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 threads)
  #:export (ef-cyprus-html-template ef-cyprus-main-body))

(define* (ef-cyprus-html-template #:key title body locale persona)
  `("<!DOCTYPE html>" (html (head (title ,title)
                                  (link (@ (rel preconnect)
                                           (href
                                            "https://fonts.googleapis.com")))
                                  (link (@ (rel preconnect)
                                           (href "https://fonts.gstatic.com")
                                           (crossorigin "")))
                                  (link (@ (rel stylesheet)
                                           (href
                                            "https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;1,100;1,200;1,300;1,400;1,500;1,600;1,700&family=IBM+Plex+Sans:ital,wght@0,100..700;1,100..700&family=IBM+Plex+Serif:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;1,100;1,200;1,300;1,400;1,500;1,600;1,700&display=swap")))
                                  (link (@ (rel stylesheet)
                                           (type text/css)
                                           (href
                                            "https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.1/src/regular/style.css")))
                                  (meta (@ (name "viewport")
                                           (content
                                            "width=device-width, initial-scale=1.0")))
                                  (meta (@ (charset "UTF-8")))
                                  (style ,(assoc-ref my-asset-library
                                           "resources/css/iter-vitae.olive.min.css")))
                            (body (@ (class "break-words"))
                                  (div (@ (class ,(mk-class '(px-4 sm:px-8
                                                                   md:px-12
                                                                   py-4
                                                                   sm:py-8
                                                                   md:py-12
                                                                   max-w-4xl
                                                                   lg:mx-6
                                                                   font-sans))))
                                       ,@body
                                       ,(page-footer #:persona persona
                                                     #:locale locale))))))

(define* (page-footer #:key locale persona)
  `((hr (@ (class ,hr-face)))
    (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-2 justify-evenly))))
         ,(render-blog-link #:locale locale
                            #:persona persona)
         ,(render-code-link #:locale locale
                            #:persona persona)
         ,(render-linked-in-link #:locale locale
                                 #:persona persona))
    (div (@ (class ,(mk-class '(my-2 block text-center font-sans))))
         (div (@ (class ,(mk-class '(flex flex-row gap-3 flex-wrap
                                          justify-center))))
              (small (@ (class ,address-face))
                     "this Curriculum Vitae was rendered with "
                     (a (@ (class ,small-a-face)
                           (href "https://codeberg.org/jjba23/iter-vitae"))
                        "Lisp (Guile Scheme) code"))))))

(define* (render-display-name #:key locale persona)
  `(h1 (@ (class ,display-name-face))
       ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let* ((jt (assq-ref persona
                       'job-title-link)))
    (cond
      ((list? jt)
       `(a (@ (class ,h2-special-face)
              (href ,(assq-ref-all-or-lang jt locale)))
           ,(assq-ref-all-or-lang (assq-ref persona
                                            'job-title) locale)))
      (else `(p (@ (class ,h2-special-face))
                ,(assq-ref-all-or-lang (assq-ref persona
                                                 'job-title) locale)))))

  )

(define* (render-email #:key locale persona)
  `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-envelope text-onyx-500 text-xl)))) "")
         (a (@ (class ,small-a-face))
            ,(assq-ref (assq-ref persona
                                 'personal-contact)
                       'emails)))))

(define* (render-phone-number #:key locale persona)
  `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-phone text-onyx-500 text-xl)))) "")
         (small (@ (class ,address-face))
                ,(assq-ref (assq-ref persona
                                     'personal-contact)
                           'phone-numbers)))))

(define* (render-blog-link #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-rss text-onyx-500 xl)))) "")
         (a (@ (class ,small-a-face)
               (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'blog))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'blog)))))

(define* (render-code-link #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-code text-onyx-500 text-xl)))) "")
         (a (@ (class ,small-a-face)
               (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'code))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'code)))))

(define* (render-linked-in-link #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-link text-onyx-500 text-xl)))) "")
         (a (@ (class ,small-a-face)
               (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'linked-in))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'linked-in)))))

(define* (render-address-lines #:key locale persona)
  `(small (@ (class ,(mk-class '(flex flex-col))))
          ,(map (lambda (address-line)
                  `(span (@ (class ,address-face))
                         ,(assq-ref-all-or-lang address-line locale)))
                (assq-ref persona
                          'address-lines))))

(define* (render-driver-licenses #:key locale persona)
  `(p (@ (class ,p-face))
      ,(map (lambda (driver-license)
              `(span (@ (class ,(mk-class '(mr-4))))
                     ,(assq-ref-all-or-lang driver-license locale)))
            (assq-ref persona
                      'driver-licenses))))

(define* (render-short-intro #:key locale persona)
  (map (lambda (intro-line)
         `(p (@ (class ,p-face))
             ,(assq-ref-all-or-lang intro-line locale)))
       (assq-ref persona
                 'short-intro)))

(define* (render-interests-hobbies #:key locale persona)
  (map (lambda (interest-hobby)
         `(p (@ (class ,p-face))
             ,(assq-ref-all-or-lang interest-hobby locale)))
       (assq-ref persona
                 'interests-hobbies)))

(define* (render-jobs #:key locale persona)
  (map (lambda (job)
         `(div (@ (class ,(mk-class '(p-3))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (span (@ (class "")) "⤷")
                    (div (@ (class ,(mk-class '(flex flex-col gap-2))))

                         (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-2 items-center))))
                              (h5 (@ (class ,h5-face))
                                  ,(assq-ref-all-or-lang (assq-ref job
                                                                   'name)
                                                         locale))
                              (span "-")
                              (h5 (@ (class ,h5-strong-face))
                                  ,(assq-ref-all-or-lang (assq-ref job
                                                                   'position)
                                                         locale)))
                         (em (@ (class ,h5-em-face))
                             ,(assq-ref-all-or-lang (assq-ref job
                                                              'location)
                                                    locale))
                         (p (@ (class ,(mk-class '(text-lg font-light mb-4))))
                            ,(assq-ref-all-or-lang (assq-ref job
                                                             'time) locale))
                         (ul ,(map (lambda (ip)
                                     `(li (@ (class ,bullet-face)
                                             (style "list-style: circle"))
                                          ,(assq-ref-all-or-lang ip locale)))
                                   (assq-ref job
                                             'experience)))))))
       (assq-ref persona
                 'jobs)))

(define* (render-education #:key locale persona)
  (map (lambda (education)
         `(div (@ (class ,(mk-class '(p-3))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (span (@ (class "")) "⤷")
                    (div (@ (class ,(mk-class '(flex flex-col gap-2))))
                         (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-3 items-center))))
                              (h5 (@ (class ,h5-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'name)
                                                         locale))
                              (span "-")
                              (h5 (@ (class ,h5-strong-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'position)
                                                         locale)))
                         (em (@ (class ,h5-em-face))
                             ,(assq-ref-all-or-lang (assq-ref education
                                                              'location)
                                                    locale))
                         (p (@ (class ,(mk-class '(text-lg font-light mb-4))))
                            ,(assq-ref-all-or-lang (assq-ref education
                                                             'time) locale))
                         (ul ,(map (lambda (ip)
                                     `(li (@ (class ,bullet-face)
                                             (style "list-style: circle"))
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
  `(div (table (@ (class ,table-face))
               (thead (tr (@ (class ,top-row-face))
                          (th "")
                          (th (@ (class ,th-face))
                              ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'speaking)
                                                     locale))
                          (th (@ (class ,th-face))
                              ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'reading)
                                                     locale))
                          (th (@ (class ,th-face))
                              ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'writing)
                                                     locale))))
               (tbody ,(map (lambda (l)
                              `((tr (td (@ (class ,first-td-face))
                                        (em ,(assq-ref-all-or-lang (assq-ref l
                                                                    'name)
                                                                   locale)))
                                    (td (@ (class ,td-face))
                                        ,(language-proficiency->string
                                          #:persona persona
                                          #:locale locale
                                          #:level (assq-ref (assq-ref l
                                                                      'proficiency)
                                                            'speaking)))
                                    (td (@ (class ,td-face))
                                        ,(language-proficiency->string
                                          #:persona persona
                                          #:locale locale
                                          #:level (assq-ref (assq-ref l
                                                                      'proficiency)
                                                            'reading)))
                                    (td (@ (class ,td-face))
                                        ,(language-proficiency->string
                                          #:persona persona
                                          #:locale locale
                                          #:level (assq-ref (assq-ref l
                                                                      'proficiency)
                                                            'writing))))))
                            (assq-ref persona
                                      'languages))))))

(define* (ef-cyprus-main-body #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-6 justify-between))))
         (div (@ (class ,(mk-class '(flex flex-col gap-3 align-left
                                          items-start))))
              ,(render-display-name #:locale locale
                                    #:persona persona)
              ,(render-job-title #:locale locale
                                 #:persona persona))
         (div (@ (class ,(mk-class '(my-3 sm:my-1 flex flex-col justify-start))))
              ,(render-email #:locale locale
                             #:persona persona)
              ,(render-phone-number #:locale locale
                                    #:persona persona)
              ,(render-address-lines #:locale locale
                                     #:persona persona)))
    
    (div (@ (class ,(mk-class '(mt-8))))
         (h4 (@ (class ,h4-face))
             ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'short-intro) locale)))
    ,(render-short-intro #:locale locale
                         #:persona persona)

    (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3 items-center))))
         (i (@ (class ,(mk-class '(ph ph-briefcase text-onyx-500 text-xl))))
            "")
         (h4 (@ (class ,h4-face))
             ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'work-experience) locale)))
    ,(render-jobs #:locale locale
                  #:persona persona)

    (hr (@ (class ,hr-face)))
    (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3 items-center))))
         (i (@ (class ,(mk-class '(ph ph-student text-onyx-500 text-xl)))) "")
         (h4 (@ (class ,h4-face))
             ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'education) locale)))
    ,(render-education #:locale locale
                       #:persona persona)

    (hr (@ (class ,hr-face)))
    (div (@ (class ,(mk-class '(mt-3 flex flex-row flex-wrap gap-3
                                     items-center))))
         (i (@ (class ,(mk-class '(ph ph-translate text-onyx-500 text-xl))))
            "")
         (h4 (@ (class ,h4-face))
             ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'language) locale)))
    ,(render-languages #:persona persona
                       #:locale locale)

    (hr (@ (class ,hr-face)))
    (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-4 items-center))))
         (i (@ (class ,(mk-class '(ph ph-car text-onyx-500 text-xl)))) "")
         (h4 (@ (class ,h4-face))
             ,(string-append (assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                              'titles)
                                                             'driver-license)
                                                   locale) ":"))
         ,(render-driver-licenses #:locale locale
                                  #:persona persona))

    (hr (@ (class ,hr-face)))
    (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3 items-center))))
         (i (@ (class ,(mk-class '(ph ph-person-simple-ski text-onyx-500
                                      text-xl)))) "")
         (h4 (@ (class ,h4-face))
             ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                        'titles)
                                              'interests-hobbies) locale)))
    ,(render-interests-hobbies #:locale locale
                               #:persona persona)))
