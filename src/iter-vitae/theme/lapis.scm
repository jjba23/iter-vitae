;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae theme lapis)
  #:declarative? #t
  #:use-module (ice-9 format)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae theme lapis-faces)
  #:use-module (iter-vitae prelude)
  #:export (lapis-html-template lapis-main-body))

;; Theme-specific refinements sit after the Olive stylesheet, so they can
;; override utility defaults without editing the generated CSS asset.  The
;; class names are stable hooks for print rules as well as for the screen.
;;
;; The palette is greys and blues only, taken from the Olive tokens: `onyx'
;; for text, `stone' for surfaces and hairlines, `lapis-lazuli' for structure
;; and `jeans-blue' for links.  No warm accent survives from fatum.
(define lapis-styles
  "\
:root { color-scheme: light; }

.lapis-page {
  max-width: 64rem;
  margin-left: auto;
  margin-right: auto;
  border-top: 4px solid oklch(0.5095 0.0968 251.94);
  overflow-wrap: anywhere;
}

.lapis-header {
  padding-bottom: 1.5rem;
  border-bottom: 1px solid oklch(0.907 0.0013 286.37);
}

.lapis-header h1 {
  letter-spacing: -0.035em;
}

.lapis-identity {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  min-width: 0;
}

.lapis-portrait {
  flex: 0 0 auto;
  width: 6rem;
  height: 6rem;
  border: 3px solid oklch(0.947 0.0013 286.37);
  border-radius: 9999px;
  box-shadow: 0 0 0 1px oklch(0.807 0.0013 286.37);
  object-fit: cover;
}

.lapis-role {
  letter-spacing: 0.08em;
}

.lapis-section-title {
  display: flex;
  flex: 1 1 auto;
  align-items: center;
  gap: 0.75rem;
}

.lapis-section-title::after {
  content: '';
  flex: 1 1 auto;
  height: 1px;
  margin-left: 0.5rem;
  background: oklch(0.907 0.0013 286.37);
}

.lapis-section-icon {
  display: inline-grid;
  flex: 0 0 1.65rem;
  width: 1.65rem;
  height: 1.65rem;
  place-items: center;
  border-radius: 9999px;
  background: oklch(0.947 0.0013 286.37);
  color: oklch(0.4095 0.0968 251.94);
  font-size: 0.95rem;
}

.lapis-skills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.45rem;
  margin: 0.85rem 0 1.25rem;
  padding: 0;
  list-style: none;
}

.lapis-skill {
  padding: 0.32rem 0.62rem;
  border: 1px solid oklch(0.857 0.0013 286.37);
  border-radius: 9999px;
  background: oklch(0.987 0.0013 286.37);
  color: oklch(0.3088 0.0044 247.95);
  font-family: 'JuliaMono', ui-monospace, monospace;
  font-size: 0.78rem;
  line-height: 1.25;
  white-space: nowrap;
}

.lapis-entry {
  padding: 0.9rem 0 0.25rem;
  break-inside: avoid;
}

.lapis-entry + .lapis-entry {
  border-top: 1px solid oklch(0.947 0.0013 286.37);
}

.lapis-date {
  color: oklch(0.4588 0.0044 247.95);
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.01em;
}

.lapis-table {
  border-collapse: collapse;
  border-radius: 0;
  background: transparent;
  box-shadow: none;
}

.lapis-table thead {
  border-bottom: 1px solid oklch(0.807 0.0013 286.37);
}

.lapis-table tbody tr {
  border-bottom: 1px solid oklch(0.947 0.0013 286.37);
}

.lapis-table tbody tr:last-child {
  border-bottom: 0;
}

.lapis-table th,
.lapis-table td {
  padding: 0.65rem 0.5rem;
  color: oklch(0.3588 0.0044 247.95);
}

.lapis-table th:first-child,
.lapis-table td:first-child {
  padding-left: 0.75rem;
  text-align: left;
}

.lapis-table th:last-child,
.lapis-table td:last-child {
  padding-right: 0.75rem;
}

.lapis-footer {
  margin-top: 2.25rem;
}

/* `hr` carries only its width as a utility class: the compiled Olive build
   ships no colored `border-t-*' utilities, so the hairline colour is set
   here, in grey. */
.lapis-page hr {
  border-top-color: oklch(0.907 0.0013 286.37);
}

.lapis-code,
.lapis-page code {
  padding: 0.08em 0.3em;
  border-radius: 0.25rem;
  background: oklch(0.947 0.0013 286.37);
  color: oklch(0.3088 0.0044 247.95);
  font-family: 'JuliaMono', ui-monospace, monospace;
  font-size: 0.9em;
}

@media (max-width: 767px) {
  .lapis-page {
    border-top-width: 3px;
  }

  .lapis-identity {
    align-items: flex-start;
  }

  .lapis-portrait {
    width: 4.5rem;
    height: 4.5rem;
  }
}

@media print {
  @page { size: A4; margin: 12mm; }

  html {
    font-size: 13.5px;
  }

  html,
  body {
    background: #fff !important;
  }

  body {
    display: block !important;
    padding: 0 !important;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
    font-size: 10pt;
    line-height: 1.38;
  }

  .lapis-page {
    width: auto !important;
    max-width: none !important;
    min-height: 0 !important;
    margin: 0 !important;
    padding: 0 !important;
    border-top: 0 !important;
    border-radius: 0 !important;
    box-shadow: none !important;
  }

  .lapis-header {
    padding-bottom: 0.75rem;
    break-inside: avoid;
    break-after: avoid;
  }

  .lapis-identity {
    gap: 0.9rem;
  }

  .lapis-section-title {
    break-after: avoid;
  }

  .lapis-section-title::after {
    background: #ddd;
  }

  .lapis-section-icon {
    display: none !important;
  }

  .lapis-entry,
  .lapis-skills,
  .lapis-table,
  .lapis-table tr,
  .lapis-education {
    break-inside: avoid;
  }

  .lapis-entry {
    padding-top: 0.4rem;
  }

  .lapis-entry + .lapis-entry {
    margin-top: 0.3rem;
  }

  .lapis-table {
    margin: 0.45rem 0 0.6rem !important;
    font-size: 8.5pt;
  }

  .lapis-page hr {
    margin: 0.45rem 0 !important;
  }

  .lapis-table th,
  .lapis-table td {
    padding: 0.25rem 0.3rem;
  }

  .lapis-portrait {
    width: 4.25rem;
    height: 4.25rem;
    border-color: #ccc;
    box-shadow: none;
  }

  a {
    color: inherit !important;
    text-decoration: none !important;
  }

  .lapis-footer {
    display: none !important;
  }

  p,
  li {
    orphans: 2;
    widows: 2;
  }
}
")

;; The stylesheet is the same compiled Olive build fatum loads: it already
;; carries the onyx, stone, lapis-lazuli and jeans-blue utilities and the
;; `font-serif' face, so a second asset would only duplicate two megabytes.
(define* (lapis-html-template #:key title body locale persona resources)
  `("<!DOCTYPE html>" (html (@ (lang ,(locale-code locale)))
                            (head (title ,title)
                                  (link (@ (rel stylesheet)
                                           (type text/css)
                                           (href
                                            "https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.1/src/regular/style.css")))
                                  (style
                                   ,(self-hosted-faces))
                                  (meta (@ (name "viewport")
                                           (content
                                            "width=device-width, initial-scale=1.0")))
                                  (meta (@ (charset "UTF-8")))
                                  (style ,(asset-css "fatum.olive.min.css"
                                                     resources))
                                  (style ,lapis-styles))
                            (body (@ (class ,(mk-class '(break-words flex
                                                         md:justify-center
                                                         md:bg-stone-500
                                                         md:py-12
                                                         md:min-h-screen))))
                                  (div (@ (class ,(mk-class '(lapis-page
                                                              px-4 sm:px-8
                                                              md:px-12
                                                              py-4
                                                              sm:py-8
                                                              md:py-12
                                                              font-serif
                                                              w-full
                                                              md:w-full
                                                              md:min-h-96
                                                              md:bg-white
                                                              md:shadow-2xl
                                                              md:rounded-md))))
                                       ,@body
                                       ,(page-footer #:persona persona
                                                     #:locale locale))))))

(define* (page-footer #:key locale persona)
  `((footer (@ (class "lapis-footer"))
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
            (div (@ (class ,(mk-class '(my-2 block text-center font-serif))))
                 (div (@ (class ,(mk-class '(flex flex-row gap-3 flex-wrap
                                                  justify-center))))
                      (small (@ (class ,address-face))
                             "Made with "
                             (a (@ (class ,small-a-face)
                                   (href "https://codeberg.org/jjba23/iter-vitae"))
                                "Iter Vitae")))))))

(define* (render-profile-picture #:key locale persona)
  (let ((picture (persona-profile-picture persona)))
    (and picture
         `(img (@ (class "lapis-portrait")
                  (src ,picture)
                  (alt ,(plain-text
                         (assq-ref-all-or-lang (assq-ref persona
                                                          'display-name)
                                               locale)))
                  (width "112")
                  (height "112"))))))

(define* (render-display-name #:key locale persona)
  `(h1 (@ (class ,display-name-face))
       ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let ((link (job-title-link persona locale)))
    (if link
        `(a (@ (class ,(string-append "lapis-role " h2-special-face))
               (href ,link))
            ,(assq-ref-all-or-lang (assq-ref persona
                                             'job-title) locale))
        `(p (@ (class ,(string-append "lapis-role " h2-special-face)))
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

;; One section heading keeps the icon, rule and title geometry consistent and
;; avoids repeating a deeply nested SXML shape in every section.
(define* (lapis-section-heading #:key locale persona title-key icon)
  (let ((title (assq-ref-all-or-lang (assq-ref (assq-ref persona 'titles)
                                                title-key)
                                     locale)))
    (if icon
        `((div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3
                                           items-center))))
               (i (@ (class ,(mk-class (list 'lapis-section-icon
                                             'ph icon)))
                     (aria-hidden "true")) "")
               (h4 (@ (class ,(string-append "lapis-section-title " h4-face)))
                   ,title)))
        `((h4 (@ (class ,(string-append "lapis-section-title " h4-face)))
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
        `(,@(lapis-section-heading #:locale locale
                                   #:persona persona
                                   #:title-key 'skills
                                   #:icon 'ph-wrench)
          (ul (@ (class "lapis-skills"))
              ,(map (lambda (skill)
                      `(li (@ (class "lapis-skill")) ,skill))
                    skills))))))

(define* (render-jobs #:key locale persona)
  (map (lambda (job)
         `(div (@ (class ,(mk-class '(lapis-entry pt-3 pb-2 px-1))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (div (@ (class ,(mk-class '(flex flex-col gap-2 flex-1
                                                     min-w-0))))

                         (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-2 items-center
                                                          align-center))))
                              (h5 (@ (class ,h5-strong-face))
                                  ,(string-append
                                    (assq-ref-all-or-lang (assq-ref job
                                                                     'position)
                                                           locale)
                                    ", ")
                                  (span (@ (class ,h5-face))
                                        ,(assq-ref-all-or-lang (assq-ref job
                                                                         'name)
                                                               locale)))
                              ,@(let ((location
                                       (assq-ref-all-or-lang (assq-ref job
                                                                       'location)
                                                             locale)))
                                  (if (string-null? location)
                                      '()
                                      `((em (@ (class ,h5-em-face))
                                            ,(format #f "— ~a" location))))))
                         (span (@ (class ,(mk-class '(lapis-date pl-2 text-xs
                                                               md:text-sm
                                                               font-mono))))
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
         `(div (@ (class ,(mk-class '(lapis-entry p-3))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (div (@ (class ,(mk-class '(flex flex-col gap-2 flex-1
                                                     min-w-0))))
                         (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-2 items-center))))
                              (h5 (@ (class ,h5-strong-face))
                                  ,(string-append
                                    (assq-ref-all-or-lang (assq-ref education
                                                                     'position)
                                                           locale)
                                    ", ")
                                  (span (@ (class ,h5-face))
                                        ,(assq-ref-all-or-lang (assq-ref
                                                               education
                                                               'name)
                                                              locale)))
                              ,@(let ((location
                                       (assq-ref-all-or-lang (assq-ref
                                                              education
                                                              'location)
                                                             locale)))
                                  (if (string-null? location)
                                      '()
                                      `((em (@ (class ,h5-em-face))
                                            ,(format #f "— ~a" location))))))
                         (span (@ (class ,(mk-class '(lapis-date pl-2 text-xs
                                                               md:text-sm
                                                               font-mono))))
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
        (table (@ (class ,(string-append "lapis-table " table-face)))
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

(define* (lapis-main-body #:key locale persona)
  `((div (@ (class ,(mk-class '(lapis-header flex flex-col md:flex-row
                                          md:flex-wrap gap-6 justify-between))))
         (div (@ (class "lapis-identity"))
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

    ,@(if (null? (or (assq-ref persona 'short-intro) '()))
          '()
          `((div (@ (class ,(mk-class '(mt-8))))
                 ,@(lapis-section-heading #:locale locale
                                          #:persona persona
                                          #:title-key 'short-intro
                                          #:icon 'ph-user))
            ,@(render-short-intro #:locale locale
                                  #:persona persona)))

    ,@(render-skills #:locale locale
                     #:persona persona)

    ,@(if (null? (or (assq-ref persona 'jobs) '()))
          '()
          `(,@(lapis-section-heading #:locale locale
                                     #:persona persona
                                     #:title-key 'work-experience
                                     #:icon 'ph-briefcase)
            ,@(render-jobs #:locale locale
                           #:persona persona)))

    ,@(if (null? (or (assq-ref persona 'education) '()))
          '()
          `((div (@ (class "lapis-education"))
                 (hr (@ (class ,hr-face)))
                 ,@(lapis-section-heading #:locale locale
                                          #:persona persona
                                          #:title-key 'education
                                          #:icon 'ph-student)
                 ,@(render-education #:locale locale
                                     #:persona persona))))

    ,@(if (null? (or (assq-ref persona 'languages) '()))
          '()
          `((hr (@ (class ,hr-face)))
            ,@(lapis-section-heading #:locale locale
                                     #:persona persona
                                     #:title-key 'language
                                     #:icon 'ph-translate)
            ,(render-languages #:persona persona
                               #:locale locale)))

    ,@(if (nil? (assq-ref persona 'driver-licenses))
          '()
          `((hr (@ (class ,hr-face)))
            ,@(lapis-section-heading #:locale locale
                                     #:persona persona
                                     #:title-key 'driver-license
                                     #:icon 'ph-car)
            ,(render-driver-licenses #:locale locale
                                     #:persona persona)))

    ,@(if (nil? (assq-ref persona 'interests-hobbies))
          '()
          `((hr (@ (class ,hr-face)))
            ,@(lapis-section-heading #:locale locale
                                     #:persona persona
                                     #:title-key 'interests-hobbies
                                     #:icon 'ph-person-simple-ski)
            ,(render-interests-hobbies #:locale locale
                                       #:persona persona)))))
