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

(use-modules (web server)
             (web request)
             (web response)
             (web uri)
             (sxml simple)
             (ice-9 popen)
             (ice-9 textual-ports)
             (ice-9 time)
             (ice-9 format)
             (ice-9 string-fun)
             (ice-9 iconv)
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
   (meta (@(name "viewport")
          (content "width=device-width, initial-scale=1.0")))
   (script (@(src "https://cdn.tailwindcss.com")) "")
   (script (@(src "js/tailwind.config.js")) ()))
  (body (@(class ""))
        (div (@(class "container mx-auto my-4"))
             ,@body
             ,(page-footer)))))

(define (page-footer)
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

(define* (iter-vitae-curriculum-page #:key locale)
  (define addre (map (lambda (al) `(span (@(class "mr-4")) ,(assq-ref-all-or-lang al locale))) iter-vitae-address-lines))  
  (with-output-to-string
    (lambda ()
      (sxml->xml
       (iter-vitae-html-template
        "Iter Vitae"
        `((h2 (@(class "font-mono text-2xl text-stone-900")) ,(assq-ref-all-or-lang iter-vitae-display-name locale))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref-all-or-lang iter-vitae-job-title locale))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-contact 'emails))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-contact 'phone-numbers))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-links 'blogs))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-links 'code))
          (p (@(class "font-mono text-stone-900")) ,(assq-ref iter-vitae-personal-links 'linkedin))
          (p (@(class "font-mono text-stone-900")) ,addre)
          )))))
  )
