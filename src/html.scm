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

;; load base iter-vitae configuration
;;(load "./iter-vitae.scm")

;; choose person to generate curriculum vitae for
(load "../populus/joe.scm")

(load "./tailwind.scm")

(define-module (iter-vitae html)
  #:use-module (iter-vitae tailwind)
  #:use-module (web server)
  #:use-module (web request)
  #:use-module (web response)
  #:use-module (web uri)
  #:use-module (sxml simple)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 time)
  #:use-module (ice-9 format)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (iter-vitae)
  #:use-module (ice-9 threads))

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
     (meta (@(name "viewport")
            (content "width=device-width, initial-scale=1.0")))
     (script (@(src "https://cdn.tailwindcss.com")) "")
     (script (@(src "js/tailwind.config.js")) ()))
    (body (@(class ""))
          (div (@(class "container mx-auto my-4"))
               ,@body
               ,(page-footer)))))

(define-public (page-footer)
  `((div (@(class "block text-center font-mono"))
         (hr (@(class ,hr-class)))
         (div (@(class ""))
              (p (@(class "text-stone-600")) "find the source code here:")
              (a (@(class "text-amber-600")
                  (href "https://codeberg.org/jjba23/iter-vitae"))
                 "codeberg.org/jjba23/iter-vitae")
              )
         (p (@(class "mt-4"))
            (span (@(class "text-sm text-stone-300"))
                  "iter-vitae-word-meaning")))))


;; Page

;; for translatable fields, behave like assq-ref
;; but by ensuring if 'all is specified, it is
;; highest priority
(define-public (assq-ref-all-or-lang al key)
  (cond
   ((not (equal? #f (assq 'all al)))
    (assq-ref al 'all)
    )
   ((not (equal? #f (assq key al)))
    (assq-ref al key)
    )
   (else #f)
   )
  )

(define-public (iter-vitae-curriculum-page)
  
  (with-output-to-string
    (lambda ()
      (sxml->xml
       (iter-vitae-html-template
        "Iter Vitae"
        `((h2 (@(class "font-mono text-2xl text-stone-900")) ,(assq-ref-all-or-lang iter-vitae-display-name 'all))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref-all-or-lang iter-vitae-job-title 'all))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-contact 'emails))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-contact 'phone-numbers))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-links 'blogs))
          )))))
  )
