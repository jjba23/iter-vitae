;;; Iter Vitae 

;; Copyright (C) 2024 Josep Jesus Bigorra Algaba

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

(use-modules (web server)       (web request)
             (web response)     (web uri)
             (sxml simple)
             (ice-9 popen)      (ice-9 textual-ports)
             (ice-9 time)       (ice-9 format)
             (ice-9 string-fun) (ice-9 iconv)
             (ice-9 threads))

(define (iter-vitae-html-template title body)
  `(html
    (head
     (title ,title)
     (link (@(rel "preconnect")
            (href "https://fonts.googleapis.com")))
     (link (@(rel "preconnect")
            (href "https://fonts.gstatic.com")(crossorigin "")))
     (link (@(rel "stylesheet")
            (href "https://fonts.cdnfonts.com/css/liberation-sans")))
     (link (@(rel "stylesheet")
            (href "css/fonts.css")))
     (link (@(rel "stylesheet")
            (href "https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css")))
     (meta (@(name "viewport")
            (content "width=device-width, initial-scale=1.0")))
     (script (@(src "https://cdn.tailwindcss.com")) "")
     (script (@(src "js/tailwind.config.js")) ()))
    (body (@(class "break-words"))
          (div (@(class "container mx-auto my-4"))
               ,@body
               ,(page-footer)))))

(define (page-footer)
  `((div (@(class "block text-center font-mono"))
         (div (@(class "flex flex-row gap-3 flex-wrap justify-center"))
              (small (@(class ,small/class)) "this Curriculum Vitae was rendered with Guile Scheme code"))
         (div (@(class "flex flex-row gap-3 flex-wrap justify-center items-center"))
              (small (@(class ,small/class)) "find the source code here:")
              (a (@(class "text-green-900 text-sm font-mono")
                  (href "https://codeberg.org/jjba23/iter-vitae"))
                 "codeberg.org/jjba23/iter-vitae")
              ))))


(define* (render-iter-vitae-display-name #:key locale)
  `(h1 (@(class ,h1/class))
       ,(assq-ref-all-or-lang iter-vitae-display-name locale)))

(define* (render-iter-vitae-job-title #:key locale)
  `(p (@(class ,h2/class))
      ,(assq-ref-all-or-lang iter-vitae-job-title locale)))

(define* (render-iter-vitae-email #:key locale)
  `((div (@(class "flex gap-1 items-center"))
         (i (@(class "bx bxs-envelope text-stone-600 text-xl")) "")
         (small (@(class ,small/class))
                ,(assq-ref iter-vitae-personal-contact 'emails)))))

(define* (render-iter-vitae-phone-number #:key locale)
  `((div (@(class "flex gap-1 items-center"))
         (i (@(class "bx bxs-phone text-stone-600 text-xl")) "")
         (small (@(class ,small/class))
                ,(assq-ref iter-vitae-personal-contact 'phone-numbers)))))

(define* (render-iter-vitae-blog-link #:key locale)
  `((div (@(class "flex flex-row gap-1 items-center"))
         (i (@(class "bx bx-link text-stone-600 xl")) "")
         (a (@(class ,small-a/class)
             (target "_blank")
             (href ,(format #f "https://~a" (assq-ref iter-vitae-personal-links 'blog))))
            ,(assq-ref iter-vitae-personal-links 'blog)))))

(define* (render-iter-vitae-code-link #:key locale)
  `((div (@(class "flex flex-row gap-1 items-center"))
         (i (@(class "bx bx-link text-stone-600 text-xl")) "")
         (a (@(class ,small-a/class)
             (target "_blank")
             (href ,(format #f "https://~a" (assq-ref iter-vitae-personal-links 'code))))
            ,(assq-ref iter-vitae-personal-links 'code)))))

(define* (render-iter-vitae-linked-in-link #:key locale)
  `((div (@(class "flex flex-row gap-1 items-center"))
         (i (@(class "bx bx-link text-stone-600 text-xl")) "")
         (a (@(class ,small-a/class)
             (target "_blank")
             (href ,(format #f "https://~a" (assq-ref iter-vitae-personal-links 'linked-in))))
            ,(assq-ref iter-vitae-personal-links 'linked-in)))))

(define* (render-iter-vitae-address-lines #:key locale)
  `(small (@(class ,(string-append small/class " flex flex-col gap-1")))
          ,(map
            (lambda (address-line)
              `(span
                ,(assq-ref-all-or-lang address-line locale)))
            iter-vitae-address-lines)))

(define* (render-iter-vitae-driver-licenses #:key locale)
  `(p (@(class ,p/class))
      ,(map
        (lambda(driver-license)
          `(span (@(class "mr-4"))
                 ,(assq-ref-all-or-lang driver-license locale)))
        iter-vitae-driver-licenses)))

(define* (render-iter-vitae-short-intro #:key locale)
  (map
   (lambda(intro-line)
     `(p (@(class ,p/class))
         ,(assq-ref-all-or-lang intro-line locale)))
   iter-vitae-short-intro))

(define* (render-iter-vitae-interests-hobbies #:key locale)
  (map
   (lambda(interest-hobby)
     `(p (@(class ,p/class))
         ,(assq-ref-all-or-lang interest-hobby locale)))
   iter-vitae-interests-hobbies))

(define* (render-iter-vitae-jobs #:key locale)
  (map
   (lambda(job)
     `(div (@(class "p-3"))
           (div (@(class "flex flex-row flex-wrap gap-3 items-center"))
                (h5 (@(class "text-lg font-bold"))
                    ,(assq-ref-all-or-lang (assq-ref job 'name) locale))
                (span "-")
                (h5 (@(class "text-lg font-bold text-stone-600"))
                    ,(assq-ref-all-or-lang (assq-ref job 'position) locale)))
           (h5 (@(class "text-md font-bold text-stone-600"))
               ,(assq-ref-all-or-lang (assq-ref job 'location) locale))
           (p (@(class "text-md font-light mb-4"))
              ,(assq-ref-all-or-lang (assq-ref job 'time) locale))
           ,(map (lambda(ip)
                   `(p (@(class ,bullet/class))
                       ,(assq-ref-all-or-lang ip locale)))
                 (assq-ref job 'experience))
           ))
   iter-vitae-jobs))

(define* (render-iter-vitae-education #:key locale)
  (map
   (lambda(education)
     `(div (@(class "p-3"))
           (div (@(class "flex flex-row flex-wrap gap-3 items-center"))
                (h5 (@(class "text-lg font-bold"))
                    ,(assq-ref-all-or-lang (assq-ref education 'name) locale))
                (span "-")
                (h5 (@(class "text-lg font-bold text-stone-800"))
                    ,(assq-ref-all-or-lang (assq-ref education 'position) locale)))
           (h5 (@(class "text-md font-bold text-stone-600"))
               ,(assq-ref-all-or-lang (assq-ref education 'location) locale))
           (p (@(class "text-md font-light mb-4"))
              ,(assq-ref-all-or-lang (assq-ref education 'time) locale))
           ,(map (lambda(ip)
                   `(p (@(class ,bullet/class))
                       ,(assq-ref-all-or-lang ip locale)))
                 (assq-ref education 'experience))
           ))
   iter-vitae-education))

(define* (iter-vitae-main-body #:key locale)
  `((div (@(class "flex flex-row flex-wrap gap-6 justify-between"))
         (div
          ,(render-iter-vitae-display-name #:locale locale)
          ,(render-iter-vitae-job-title #:locale locale))
         (div (@(class "flex flex-col flex-wrap gap-1 justify-evenly"))
              ,(render-iter-vitae-email #:locale locale)
              ,(render-iter-vitae-phone-number #:locale locale)
              ,(render-iter-vitae-address-lines #:locale locale)
              ))

    (h4 (@(class ,h4/class)) ,(assq-ref-all-or-lang (assq-ref iter-vitae-titles 'short-intro) locale))
    ,(render-iter-vitae-short-intro #:locale locale)

    (hr (@(class ,hr/class)))
    (div (@(class "flex flex-row flex-wrap gap-3 items-center"))
         (i (@(class "bx bxs-briefcase text-stone-600 text-xl")) "")
         (h4 (@(class ,h4/class))
             ,(assq-ref-all-or-lang (assq-ref iter-vitae-titles 'work-experience) locale)))
    ,(render-iter-vitae-jobs #:locale locale)

    (hr (@(class ,hr/class)))
    (div (@(class "flex flex-row flex-wrap gap-3 items-center"))
         (i (@(class "bx bxs-book-open text-stone-600 text-xl")) "")
         (h4 (@(class ,h4/class))
             ,(assq-ref-all-or-lang (assq-ref iter-vitae-titles 'education) locale)))
    ,(render-iter-vitae-education #:locale locale)

    (div (@(class "flex flex-row flex-wrap gap-4 items-center"))
         (h4 (@(class ,h4/class))
             ,(string-append
               (assq-ref-all-or-lang (assq-ref iter-vitae-titles 'driver-license) locale)
               ":"))
         ,(render-iter-vitae-driver-licenses #:locale locale))
    
    (hr (@(class ,hr/class)))
    (div (@(class "flex flex-row flex-wrap gap-3 items-center"))
         (i (@(class "bx bxs-music text-stone-600 text-xl")) "")
         (h4 (@(class ,h4/class))
             ,(assq-ref-all-or-lang (assq-ref iter-vitae-titles 'interests-hobbies) locale)))
    ,(render-iter-vitae-interests-hobbies #:locale locale)
    (hr (@(class ,hr/class)))
    (div (@(class "flex flex-row flex-wrap gap-2 justify-evenly"))
         ,(render-iter-vitae-blog-link #:locale locale)
         ,(render-iter-vitae-code-link #:locale locale)
         ,(render-iter-vitae-linked-in-link #:locale locale))
    ))


(define* (iter-vitae-curriculum-page #:key locale)
  (with-output-to-string
    (lambda ()
      (sxml->xml
       (iter-vitae-html-template
        "Iter Vitae"
        (iter-vitae-main-body #:locale locale)
        ))))
  )
