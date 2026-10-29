;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae theme ef-cyprus)
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
  #:use-module (iter-vitae theme ef-cyprus-faces)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 threads)
  #:export (ef-cyprus-html-template ef-cyprus-main-body))

;; Small, theme-owned layer over the generated Olive stylesheet.  It keeps the
;; green accent and the IBM Plex rhythm consistent on screen and in print.
(define ef-cyprus-styles
  "\
:root { color-scheme: light; }

.ef-page {
  max-width: 64rem;
  margin: 0 auto;
  border-top: 4px solid #6f8f5f;
  overflow-wrap: anywhere;
}

.ef-header {
  padding-bottom: 1.5rem;
  border-bottom: 1px solid #dde7d5;
}

.ef-header h1 {
  letter-spacing: -0.035em;
}

.ef-identity {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  min-width: 0;
}

.ef-portrait {
  flex: 0 0 auto;
  width: 5.75rem;
  height: 5.75rem;
  border: 3px solid #e2ecdb;
  border-radius: 9999px;
  box-shadow: 0 0 0 1px #cbd9c0;
  object-fit: cover;
}

.ef-role {
  letter-spacing: 0.02em;
}

.ef-section-title {
  display: flex;
  flex: 1 1 auto;
  align-items: center;
  gap: 0.75rem;
}

.ef-section-title::after {
  content: '';
  flex: 1 1 auto;
  height: 1px;
  margin-left: 0.5rem;
  background: #dde7d5;
}

.ef-section-icon {
  color: #5f7f4f;
}

.ef-skills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.45rem;
  margin: 0.85rem 0 1.25rem;
  padding: 0;
  list-style: none;
}

.ef-skill {
  padding: 0.3rem 0.6rem;
  border: 1px solid #cbd9c0;
  border-radius: 9999px;
  background: #f5f8f1;
  color: #3f5138;
  font-size: 0.8rem;
  line-height: 1.25;
  white-space: nowrap;
}

.ef-entry {
  padding: 0.85rem 0 0.25rem;
  break-inside: avoid;
}

.ef-entry + .ef-entry {
  border-top: 1px solid #eef3ea;
}

.ef-date {
  color: #667085;
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.01em;
}

.ef-table {
  border-collapse: collapse;
  border-radius: 0;
  background: transparent;
  box-shadow: none;
}

.ef-table thead {
  border-bottom: 1px solid #ccd8c2;
}

.ef-table tbody tr {
  border-bottom: 1px solid #e9f0e4;
}

.ef-table tbody tr:last-child {
  border-bottom: 0;
}

.ef-table th,
.ef-table td {
  padding: 0.65rem 0.5rem;
  color: #3f4652;
}

.ef-table th:first-child,
.ef-table td:first-child {
  padding-left: 0.75rem;
  text-align: left;
}

.ef-table th:last-child,
.ef-table td:last-child {
  padding-right: 0.75rem;
}

.ef-footer {
  margin-top: 2.25rem;
}

.ef-page code {
  padding: 0.08em 0.3em;
  border-radius: 0.25rem;
  background: #eef3ea;
  color: #3f5138;
  font-family: 'IBM Plex Mono', ui-monospace, monospace;
  font-size: 0.9em;
}

@media (max-width: 767px) {
  .ef-identity {
    align-items: flex-start;
  }

  .ef-portrait {
    width: 4.5rem;
    height: 4.5rem;
  }
}

@media print {
  @page { size: A4; margin: 14mm; }

  html,
  body {
    background: #fff !important;
  }

  body {
    padding: 0 !important;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }

  .ef-page {
    max-width: none !important;
    margin: 0 !important;
    padding: 0 !important;
    border-top: 0 !important;
  }

  .ef-section-title::after {
    background: #ddd;
  }

  .ef-entry,
  .ef-skills,
  .ef-table {
    break-inside: avoid;
  }

  .ef-portrait {
    border-color: #ccc;
    box-shadow: none;
  }

  a {
    color: inherit !important;
    text-decoration: none !important;
  }

  .ef-footer {
    margin-top: 1.25rem;
  }
}
")

(define* (ef-cyprus-html-template #:key title body locale persona resources)
  `("<!DOCTYPE html>" (html (@ (lang ,(locale-code locale)))
                            (head (title ,title)
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
                                  (style ,(asset-css "iter-vitae.olive.min.css"
                                                     resources))
                                  (style ,ef-cyprus-styles))
                            (body (@ (class ,(mk-class '(break-words flex
                                                         md:justify-center))))
                                  (div (@ (class ,(mk-class '(ef-page w-full
                                                                   min-w-0
                                                                   px-4 sm:px-8
                                                                   md:px-12
                                                                   py-4
                                                                   sm:py-8
                                                                   md:py-12
                                                                   font-sans))))
                                       ,@body
                                       ,(page-footer #:persona persona
                                                     #:locale locale))))))

(define* (page-footer #:key locale persona)
  `((footer (@ (class "ef-footer"))
            (hr (@ (class ,hr-face)))
            (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-2
                                             justify-evenly))))
                 ,(and (personal-link persona 'blog)
                       (render-blog-link #:locale locale
                                         #:persona persona))
                 ,(and (personal-link persona 'code)
                       (render-code-link #:locale locale
                                         #:persona persona))
                 ,(and (personal-link persona 'linked-in)
                       (render-linked-in-link #:locale locale
                                              #:persona persona)))
            (div (@ (class ,(mk-class '(my-2 block text-center font-sans))))
                 (div (@ (class ,(mk-class '(flex flex-row gap-3 flex-wrap
                                                  justify-center))))
                      (small (@ (class ,address-face))
                             "this Curriculum Vitae was rendered with "
                             (a (@ (class ,small-a-face)
                                   (href "https://codeberg.org/jjba23/iter-vitae"))
                                "Lisp (Guile Scheme) code")))))))

(define* (render-profile-picture #:key locale persona)
  (let ((picture (persona-profile-picture persona)))
    (and picture
         `(img (@ (class "ef-portrait")
                  (src ,picture)
                  (alt ,(plain-text
                         (assq-ref-all-or-lang (assq-ref persona
                                                          'display-name)
                                               locale)))
                  (width "108")
                  (height "108"))))))

(define* (render-display-name #:key locale persona)
  `(h1 (@ (class ,display-name-face))
       ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let ((link (job-title-link persona locale)))
    (if link
        `(a (@ (class ,(string-append "ef-role " h2-special-face))
               (href ,link))
            ,(assq-ref-all-or-lang (assq-ref persona
                                             'job-title) locale))
        `(p (@ (class ,(string-append "ef-role " h2-special-face)))
             ,(assq-ref-all-or-lang (assq-ref persona
                                              'job-title) locale)))))

(define* (render-email #:key locale persona)
  (let ((email (personal-contact-value persona 'emails)))
    (and email
         `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-envelope text-onyx-500 text-xl)))
                      (aria-hidden "true")) "")
                (a (@ (class ,small-a-face)
                      (href ,(string-append "mailto:" email)))
                   ,email))))))

(define* (render-phone-number #:key locale persona)
  (let ((phone (personal-contact-value persona 'phone-numbers)))
    (and phone
         `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-phone text-onyx-500 text-xl)))
                      (aria-hidden "true")) "")
                (a (@ (class ,small-a-face)
                      (href ,(tel-url phone)))
                   (small (@ (class ,address-face)) ,phone)))))))

(define* (render-blog-link #:key locale persona)
  (let ((blog (personal-link persona 'blog)))
    (and blog
         `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-rss text-onyx-500 xl)))
                      (aria-hidden "true")) "")
                (a (@ (class ,small-a-face)
                      (target "_blank")
                      (rel "noopener noreferrer")
                      (href ,(external-url blog)))
                   ,blog))))))

(define* (render-code-link #:key locale persona)
  (let ((code (personal-link persona 'code)))
    (and code
         `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-code text-onyx-500 text-xl)))
                      (aria-hidden "true")) "")
                (a (@ (class ,small-a-face)
                      (target "_blank")
                      (rel "noopener noreferrer")
                      (href ,(external-url code)))
                   ,code))))))

(define* (render-linked-in-link #:key locale persona)
  (let ((linked-in (personal-link persona 'linked-in)))
    (and linked-in
         `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-link text-onyx-500 text-xl)))
                      (aria-hidden "true")) "")
                (a (@ (class ,small-a-face)
                      (target "_blank")
                      (rel "noopener noreferrer")
                      (href ,(external-url linked-in)))
                   ,linked-in))))))

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

;; A single heading builder keeps the icon and rule alignment identical in
;; every section, including the optional ones.
(define* (ef-section-heading #:key locale persona title-key icon)
  (let ((title (assq-ref-all-or-lang (assq-ref (assq-ref persona 'titles)
                                                title-key)
                                     locale)))
    (if icon
        `((div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3
                                           items-center))))
               (i (@ (class ,(mk-class (list 'ef-section-icon
                                             'ph
                                             'text-xl
                                             icon)))
                     (aria-hidden "true")) "")
               (h4 (@ (class ,(string-append "ef-section-title " h4-face)))
                   ,title)))
        `((h4 (@ (class ,(string-append "ef-section-title " h4-face)))
              ,title)))))

(define* (render-skills #:key locale persona)
  (let ((skills (filter-map
                 (lambda (skill)
                   (let ((text (string-trim-both
                                (assq-ref-all-or-lang skill locale))))
                     (and (not (string-null? text)) text)))
                 (or (assq-ref persona 'skills) '()))))
    (if (null? skills)
        '()
        `(,@(ef-section-heading #:locale locale
                                #:persona persona
                                #:title-key 'skills
                                #:icon 'ph-wrench)
          (ul (@ (class "ef-skills"))
              ,(map (lambda (skill)
                      `(li (@ (class "ef-skill")) ,skill))
                    skills))))))

(define* (render-jobs #:key locale persona)
  (map (lambda (job)
         `(div (@ (class ,(mk-class '(ef-entry pt-3 pb-2 px-1))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (div (@ (class ,(mk-class '(flex flex-col gap-2 flex-1
                                                     min-w-0))))

                         (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-2 items-center
                                                          align-center))))
                              (h5 (@ (class ,h5-strong-face))
                                  ,(assq-ref-all-or-lang (assq-ref job
                                                                   'position)
                                                         locale))
                              (span "@")
                              (h5 (@ (class ,h5-face))
                                  ,(assq-ref-all-or-lang (assq-ref job
                                                                   'name)
                                                         locale))
                              (em (@ (class ,h5-em-face))
                                  ,(format #f "(~a)"
                                           (assq-ref-all-or-lang (assq-ref job
                                                                  'location)
                                                                 locale))))
                         (span (@ (class ,(mk-class '(ef-date pl-2 text-sm
                                                               md:text-md
                                                               font-light))))
                               ,(format-date-range
                                 (assq-ref-all-or-lang (assq-ref job
                                                                  'time)
                                                       locale)))
                         (div (@ (class ,(mk-class '(pl-2))))
                              (ul ,(map (lambda (ip)
                                          `(li (@ (class ,bullet-face)
                                                  (style "list-style: circle"))
                                               ,(assq-ref-all-or-lang ip
                                                                      locale)))
                                        (assq-ref job
                                                  'experience))))))))
       (assq-ref persona
                 'jobs)))

(define* (render-education #:key locale persona)
  (map (lambda (education)
         `(div (@ (class ,(mk-class '(ef-entry p-3))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (div (@ (class ,(mk-class '(flex flex-col gap-2 flex-1
                                                     min-w-0))))
                         (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-2 items-center))))
                              (h5 (@ (class ,h5-strong-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'position)
                                                         locale))
                              (span "@")
                              (h5 (@ (class ,h5-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'name)
                                                         locale))
                              (em (@ (class ,h5-em-face))
                                  ,(format #f "(~a)"
                                           (assq-ref-all-or-lang (assq-ref
                                                                  education
                                                                  'location)
                                                                 locale))))
                         (span (@ (class ,(mk-class '(ef-date pl-2 text-sm
                                                               md:text-md
                                                               font-light))))
                               ,(format-date-range
                                 (assq-ref-all-or-lang (assq-ref education
                                                                  'time)
                                                       locale)))
                         (div (@ (class ,(mk-class '(pl-2))))
                              (ul ,(map (lambda (ip)
                                          `(li (@ (class ,bullet-face)
                                                  (style "list-style: circle"))
                                               ,(assq-ref-all-or-lang ip
                                                                      locale)))
                                        (assq-ref education
                                                  'experience))))))))
       (assq-ref persona
                 'education)))

(define* (language-proficiency->string #:key persona locale level)
  (language-proficiency-label persona locale level))

(define* (render-languages #:key locale persona)
  `(div (@ (class ,(mk-class '(w-full overflow-x-auto))))
        (table (@ (class ,(string-append "ef-table " table-face)))
               (thead (tr (@ (class ,top-row-face))
                          (th (@ (class ,th-face))
                              ,(assq-ref-all-or-lang
                                (assq-ref (assq-ref persona 'titles)
                                          'language-name)
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
                                                               'speaking)
                                                     locale))
                          (th (@ (class ,th-face))
                              ,(assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'writing)
                                                     locale))))
               (tbody ,(map (lambda (l)
                              `((tr (td (@ (class ,first-td-face))
                                        ,(assq-ref-all-or-lang (assq-ref l
                                                                         'name)
                                                                locale))
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
                                                            'speaking)))
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
  `((div (@ (class ,(mk-class '(ef-header flex flex-col md:flex-row
                                          md:flex-wrap gap-6 justify-between))))
         (div (@ (class "ef-identity"))
              ,(render-profile-picture #:locale locale
                                       #:persona persona)
              (div (@ (class ,(mk-class '(flex flex-col gap-3 align-left
                                               items-start))))
                   ,(render-display-name #:locale locale
                                         #:persona persona)
                   ,(render-job-title #:locale locale
                                      #:persona persona)))
         (div (@ (class ,(mk-class '(my-3 sm:my-1 flex flex-col justify-start))))
              ,(render-email #:locale locale
                             #:persona persona)
              ,(render-phone-number #:locale locale
                                    #:persona persona)
              ,(render-address-lines #:locale locale
                                     #:persona persona)))

    (div (@ (class ,(mk-class '(mt-8))))
         ,@(ef-section-heading #:locale locale
                               #:persona persona
                               #:title-key 'short-intro
                               #:icon 'ph-user))
    ,(render-short-intro #:locale locale
                         #:persona persona)

    ,@(render-skills #:locale locale
                     #:persona persona)

    ,@(ef-section-heading #:locale locale
                          #:persona persona
                          #:title-key 'work-experience
                          #:icon 'ph-briefcase)
    ,(render-jobs #:locale locale
                  #:persona persona)

    (hr (@ (class ,hr-face)))
    ,@(ef-section-heading #:locale locale
                          #:persona persona
                          #:title-key 'education
                          #:icon 'ph-student)
    ,(render-education #:locale locale
                       #:persona persona)

    (hr (@ (class ,hr-face)))
    ,@(ef-section-heading #:locale locale
                          #:persona persona
                          #:title-key 'language
                          #:icon 'ph-translate)
    ,(render-languages #:persona persona
                       #:locale locale)

    ,@(if (nil? (assq-ref persona 'driver-licenses))
          '()
          `((hr (@ (class ,hr-face)))
            ,@(ef-section-heading #:locale locale
                                  #:persona persona
                                  #:title-key 'driver-license
                                  #:icon 'ph-car)
            ,(render-driver-licenses #:locale locale
                                     #:persona persona)))

    ,@(if (nil? (assq-ref persona 'interests-hobbies))
          '()
          `((hr (@ (class ,hr-face)))
            ,@(ef-section-heading #:locale locale
                                  #:persona persona
                                  #:title-key 'interests-hobbies
                                  #:icon 'ph-person-simple-ski)
            ,(render-interests-hobbies #:locale locale
                                       #:persona persona)))))
