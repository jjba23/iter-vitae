;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae theme fundamental)
  #:declarative? #t
  #:use-module (web uri)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
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
  "font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; line-height: 1.62; color: #1f2933; max-width: 52rem; margin: 0 auto; padding: 48px 28px;")

(define footer-container-style
  "margin-top: 3rem; font-size: 0.8rem; color: #667085; text-align: center; border-top: 1px solid #d9e2ec; padding-top: 1.25rem;")

(define footer-flex-style
  "display: flex; justify-content: center; flex-wrap: wrap; gap: 15px; margin-bottom: 10px;")

(define link-style
  "color: inherit; text-decoration: none; border-bottom: 1px solid #bcccdc;")

(define email-link-style
  "color: inherit; text-decoration: none;")

(define h1-style
  "margin: 0 0 0.35rem 0; font-size: clamp(2.1rem, 6vw, 2.8rem); line-height: 1.08; letter-spacing: -0.035em;")

(define h4-style
  "border-bottom: 1px solid #d9e2ec; padding-bottom: 0.35rem; margin: 2.4rem 0 0.9rem 0; text-transform: uppercase; font-size: 0.78rem; letter-spacing: 0.12em; color: #52606d; break-after: avoid;")

(define h5-style
  "margin: 0; font-size: 1.05rem; font-weight: 600; line-height: 1.35;")

(define subtitle-style
  "font-size: 1.15rem; color: #52606d; margin-bottom: 0.85rem;")

(define p-style
  "margin: 0 0 0.75rem 0;")

(define section-item-style
  "margin-bottom: 1.65rem; break-inside: avoid;")

(define section-header-flex-style
  "display: flex; justify-content: space-between; align-items: baseline; gap: 1rem; margin-bottom: 0.15rem; flex-wrap: wrap;")

(define time-span-style
  "color: #667085; font-size: 0.85rem; font-variant-numeric: tabular-nums; white-space: nowrap;")

(define location-div-style
  "color: #667085; font-size: 0.9rem; margin-bottom: 0.45rem;")

(define ul-style
  "margin: 0.4rem 0 0.8rem 0; padding-left: 1.25rem;")

(define li-style
  "margin-bottom: 0.3rem;")

(define table-style
  "width: 100%; border-collapse: collapse; margin: 0.5rem 0 1.5rem 0; font-size: 0.95rem;")

(define th-style
  "text-align: left; padding: 0.5rem 0.4rem; border-bottom: 1px solid #d9e2ec; font-weight: 600; color: #52606d;")

(define td-style
  "text-align: left; padding: 0.5rem 0.4rem; border-bottom: 1px solid #eef2f6;")

(define main-body-container-style
  "margin-bottom: 0;")

(define contact-flex-style
  "display: flex; gap: 0.4rem 1.1rem; flex-wrap: wrap; font-size: 0.9rem; color: #52606d; margin-top: 0.5rem;")

(define identity-style
  "display: flex; align-items: center; gap: 1.25rem; margin-bottom: 0.75rem;")

(define portrait-style
  "width: 88px; height: 88px; flex: 0 0 auto; border: 2px solid #d9e2ec; border-radius: 50%; object-fit: cover;")

(define fundamental-print-styles
  "@media print { @page { size: A4; margin: 14mm; } body { max-width: none !important; padding: 0 !important; color: #000 !important; } a { color: inherit !important; text-decoration: none !important; border-bottom: 0 !important; } .fundamental-footer { margin-top: 1.5rem !important; } }" )

;; --- Templates ---

(define* (fundamental-html-template #:key title body locale persona resources)
  `("<!DOCTYPE html>" (html (@ (lang ,(locale-code locale)))
                            (head (title ,title)
                                  (meta (@ (name "viewport")
                                           (content
                                            "width=device-width, initial-scale=1.0")))
                                  (meta (@ (charset "UTF-8")))
                                  (style ,fundamental-print-styles))
                            (body (@ (style ,body-style))
                                  (main ,@body)
                                  ,(page-footer #:persona persona
                                                #:locale locale)))))

(define* (page-footer #:key locale persona)
  `(footer (@ (class "fundamental-footer")
              (style ,footer-container-style))
           (div (@ (style ,footer-flex-style))
                ,(and (personal-link persona 'blog)
                      (render-blog-link #:locale locale
                                        #:persona persona))
                ,(and (personal-link persona 'code)
                      (render-code-link #:locale locale
                                        #:persona persona))
                ,(and (personal-link persona 'linked-in)
                      (render-linked-in-link #:locale locale
                                             #:persona persona)))
           (div (small "Rendered with "
                       (a (@ (style ,link-style)
                             (href "https://www.gnu.org/software/guile/"))
                          "Lisp (Guile Scheme)")))))

(define* (render-profile-picture #:key locale persona)
  (let ((picture (persona-profile-picture persona)))
    (and picture
         `(img (@ (style ,portrait-style)
                  (src ,picture)
                  (alt ,(plain-text
                         (assq-ref-all-or-lang (assq-ref persona
                                                          'display-name)
                                               locale)))
                  (width "88")
                  (height "88"))))))

(define* (render-display-name #:key locale persona)
  `(h1 (@ (style ,h1-style))
       ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let ((link (job-title-link persona locale)))
    `(div (@ (style ,subtitle-style))
          ,(if link
               `(a (@ (style ,link-style)
                      (href ,link))
                   ,(assq-ref-all-or-lang (assq-ref persona
                                                    'job-title) locale))
               (assq-ref-all-or-lang (assq-ref persona
                                               'job-title) locale)))))

(define* (render-email #:key locale persona)
  (let ((email (personal-contact-value persona 'emails)))
    (and email
         `(div (a (@ (style ,email-link-style)
                     (href ,(string-append "mailto:" email)))
                  ,email)))))

(define* (render-phone-number #:key locale persona)
  (let ((phone (personal-contact-value persona 'phone-numbers)))
    (and phone
         `(div (a (@ (style ,email-link-style)
                     (href ,(tel-url phone)))
                  ,phone)))))

(define* (render-blog-link #:key locale persona)
  (let ((blog (personal-link persona 'blog)))
    (and blog
         `(div (a (@ (style ,link-style)
                     (target "_blank")
                     (rel "noopener noreferrer")
                     (href ,(external-url blog)))
                  "Blog")))))

(define* (render-code-link #:key locale persona)
  (let ((code (personal-link persona 'code)))
    (and code
         `(div (a (@ (style ,link-style)
                     (target "_blank")
                     (rel "noopener noreferrer")
                     (href ,(external-url code)))
                  "Code")))))

(define* (render-linked-in-link #:key locale persona)
  (let ((linked-in (personal-link persona 'linked-in)))
    (and linked-in
         `(div (a (@ (style ,link-style)
                     (target "_blank")
                     (rel "noopener noreferrer")
                     (href ,(external-url linked-in)))
                  "LinkedIn")))))

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

(define* (render-skills #:key locale persona)
  (let ((skills (filter-map
                 (lambda (skill)
                   (let ((text (string-trim-both
                                (assq-ref-all-or-lang skill locale))))
                     (and (not (string-null? text)) text)))
                 (or (assq-ref persona 'skills) '()))))
    (if (null? skills)
        '()
        `((p (@ (style ,p-style)) ,(string-join skills ", "))))))

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
                          ,(format-date-range
                            (assq-ref-all-or-lang (assq-ref job
                                                           'time) locale))))
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
                          ,(format-date-range
                            (assq-ref-all-or-lang (assq-ref education
                                                           'time) locale))))
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
  (language-proficiency-label persona locale level))

(define* (render-languages #:key locale persona)
  `(div (@ (style "overflow-x: auto;"))
        (table (@ (style ,table-style))
               (thead (tr (th (@ (style ,th-style))
                              ,(assq-ref-all-or-lang
                                (assq-ref (assq-ref persona 'titles)
                                          'language-name)
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
                                                               'speaking)
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
                                                                               'writing)))))
                            (assq-ref persona
                                      'languages))))))

(define* (fundamental-main-body #:key locale persona)
  `((div (@ (style ,main-body-container-style))
         (div (@ (style ,identity-style))
              ,(render-profile-picture #:locale locale
                                       #:persona persona)
              (div ,(render-display-name #:locale locale
                                         #:persona persona)
                   ,(render-job-title #:locale locale
                                      #:persona persona)))
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

    ,@(let ((skills (render-skills #:locale locale
                                   #:persona persona)))
         (if (null? skills)
             '()
             `((h4 (@ (style ,h4-style))
                   ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                              'titles)
                                                    'skills) locale))
               ,@skills)))

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
