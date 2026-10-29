;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae theme fatum)
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
  #:use-module (iter-vitae theme fatum-faces)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 threads)
  #:export (fatum-html-template fatum-main-body))

(define* (fatum-html-template #:key title body locale persona resources)
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
                                            "https://fonts.googleapis.com/css2?family=Intel+One+Mono:ital,wght@0,300..700;1,300..700&family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap")))
                                  (link (@ (rel stylesheet)
                                           (type text/css)
                                           (href
                                            "https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.1/src/regular/style.css")))
                                  (style
                                   "
/* --- Lucida Sans --- */

@font-face {
  font-family: 'Lucida Sans';
  font-style: normal;
  font-weight: 400;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LSANS.woff') format('woff');
}

@font-face {
  font-family: 'Lucida Sans';
  font-style: italic;
  font-weight: 400;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LSANSI.woff') format('woff');
}

@font-face {
  font-family: 'Lucida Sans';
  font-style: normal;
  font-weight: 600;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LSANSD.woff') format('woff');
}

@font-face {
  font-family: 'Lucida Sans';
  font-style: italic;
  font-weight: 600;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LSANSDI.woff') format('woff');
}

/* --- Lucida Sans Typewriter --- */

@font-face {
  font-family: 'Lucida Sans Typewriter';
  font-style: normal;
  font-weight: 400;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LTYPE.woff') format('woff');
}

@font-face {
  font-family: 'Lucida Sans Typewriter';
  font-style: oblique;
  font-weight: 400;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LTYPEO.woff') format('woff');
}

@font-face {
  font-family: 'Lucida Sans Typewriter';
  font-style: normal;
  font-weight: 700;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LTYPEB.woff') format('woff');
}

@font-face {
  font-family: 'Lucida Sans Typewriter';
  font-style: oblique;
  font-weight: 700;
  src: url('https://jointhefreeworld.org/static-assets/fonts/LTYPEBO.woff') format('woff');
}

/* --- Lucida Sans Unicode --- */

@font-face {
  font-family: 'Lucida Sans Unicode';
  font-style: normal;
  font-weight: 400;
  src: url('https://jointhefreeworld.org/static-assets/fonts/l_10646.woff') format('woff');
}
")
                                  (meta (@ (name "viewport")
                                           (content
                                            "width=device-width, initial-scale=1.0")))
                                  (meta (@ (charset "UTF-8")))
                                  (style ,(asset-css "fatum.olive.min.css"
                                                     resources)))
                            (body (@ (class ,(mk-class '(break-words flex
                                                         md:justify-center
                                                         md:bg-onyx-100/50
                                                         md:py-12
                                                         md:min-h-screen))))
                                  (div (@ (class ,(mk-class '(px-4 sm:px-8
                                                              md:px-12
                                                              py-4
                                                              sm:py-8
                                                              md:py-12
                                                              font-sans
                                                              w-full
                                                              md:w-312
                                                              md:min-h-96
                                                              md:bg-white
                                                              md:shadow-2xl
                                                              md:rounded-md))))
                                       ,@body
                                       ,(page-footer #:persona persona
                                                     #:locale locale))))))

(define* (page-footer #:key locale persona)
  `((hr (@ (class ,hr-face)))
    (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-2 justify-evenly))))
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
                        "Lisp (Guile Scheme) code"))))))

(define* (render-display-name #:key locale persona)
  `(h1 (@ (class ,display-name-face))
       ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-job-title #:key locale persona)
  (let ((link (job-title-link persona locale)))
    (if link
        `(a (@ (class ,h2-special-face)
               (href ,link))
            ,(assq-ref-all-or-lang (assq-ref persona
                                             'job-title) locale))
        `(p (@ (class ,h2-special-face))
             ,(assq-ref-all-or-lang (assq-ref persona
                                              'job-title) locale)))))

(define* (render-email #:key locale persona)
  (let ((email (personal-contact-value persona 'emails)))
    (and email
         `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-envelope text-onyx-500 text-xl))))
                   "")
                (a (@ (class ,small-a-face)
                      (href ,(string-append "mailto:" email)))
                   ,email))))))

(define* (render-phone-number #:key locale persona)
  (let ((phone (personal-contact-value persona 'phone-numbers)))
    (and phone
         `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-phone text-onyx-500 text-xl))))
                   "")
                (a (@ (class ,small-a-face)
                      (href ,(tel-url phone)))
                   (small (@ (class ,address-face)) ,phone)))))))

(define* (render-blog-link #:key locale persona)
  (let ((blog (personal-link persona 'blog)))
    (and blog
         `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-rss text-onyx-500 xl)))) "")
                (a (@ (class ,small-a-face)
                      (target "_blank")
                      (rel "noopener noreferrer")
                      (href ,(external-url blog)))
                   ,blog))))))

(define* (render-code-link #:key locale persona)
  (let ((code (personal-link persona 'code)))
    (and code
         `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-code text-onyx-500 text-xl)))) "")
                (a (@ (class ,small-a-face)
                      (target "_blank")
                      (rel "noopener noreferrer")
                      (href ,(external-url code)))
                   ,code))))))

(define* (render-linked-in-link #:key locale persona)
  (let ((linked-in (personal-link persona 'linked-in)))
    (and linked-in
         `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
                (i (@ (class ,(mk-class '(ph ph-link text-onyx-500 text-xl)))) "")
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

(define* (render-jobs #:key locale persona)
  (map (lambda (job)
         `(div (@ (class ,(mk-class '(pt-3 pb-2 px-1))))
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
                         (em (@ (class ,(mk-class '(pl-2 italic text-sm
                                                         md:text-md font-light))))
                             ,(assq-ref-all-or-lang (assq-ref job
                                                              'time) locale))
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
         `(div (@ (class ,(mk-class '(p-3))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (div (@ (class ,(mk-class '(flex flex-col gap-2 flex-1
                                                     min-w-0))))
                         (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-2 items-center))))
                              (h5 (@ (class ,h5-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'name)
                                                         locale))
                              (span "-")
                              (h5 (@ (class ,h5-strong-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'position)
                                                         locale))
                              (em (@ (class ,h5-em-face))
                                  ,(format #f "(~a)"
                                           (assq-ref-all-or-lang (assq-ref
                                                                  education
                                                                  'location)
                                                                 locale))))
                         (em (@ (class ,(mk-class '(pl-2 italic text-sm
                                                         md:text-md font-light))))
                             ,(assq-ref-all-or-lang (assq-ref education
                                                              'time) locale))
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
  (let* ((lp (assq-ref persona
                       'language-proficiency))
         (ll (assq-ref-all-or-lang lp locale)))
    (assoc-ref ll level)))

(define* (render-languages #:key locale persona)
  `(div (@ (class ,(mk-class '(w-full overflow-x-auto))))
        (table (@ (class ,table-face))
               (thead (tr (@ (class ,top-row-face))
                          (th "")
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
                                        (em ,(assq-ref-all-or-lang (assq-ref l
                                                                    'name)
                                                                   locale)))
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

(define* (fatum-main-body #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-col md:flex-row md:flex-wrap gap-6
                                     justify-between))))
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

    ,(unless (nil? (assq-ref persona
                             'driver-licenses))
       `((hr (@ (class ,hr-face)))
         (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-4
                                          items-center))))
              (i (@ (class ,(mk-class '(ph ph-car text-onyx-500 text-xl)))) "")
              (h4 (@ (class ,h4-face))
                  ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                             'titles)
                                                   'driver-license) locale))
              ,(render-driver-licenses #:locale locale
                                       #:persona persona))))

    ,(unless (nil? (assq-ref persona
                             'interests-hobbies))
       `((hr (@ (class ,hr-face)))
         (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3
                                          items-center))))
              (i (@ (class ,(mk-class '(ph ph-person-simple-ski text-onyx-500
                                           text-xl)))) "")
              (h4 (@ (class ,h4-face))
                  ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                             'titles)
                                                   'interests-hobbies) locale)))
         ,(render-interests-hobbies #:locale locale
                                    #:persona persona)))))
