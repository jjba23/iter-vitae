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
    (body (@(class "bg-stone-900"))
          (div (@(class "container mx-auto my-4"))
               ,(page-top)
               ,@body
               ,(page-footer)))))

(define-public (page-top)
  `((div (@(class "flex flex-row flex-wrap gap-1 my-6"))
         (h1 (@(class "text-3xl text-green-500 font-bold p-2 m-2 font-mono"))
             (a (@(href "/")) "iter-vitae"))
         (div (@(class "flex flex-row flex-wrap items-center gap-1"))
              (a (@ (href "/")
                    (class ,nav-button-class))
                 "jobs")
              (a (@ (href "/jobs/request")
                    (class ,nav-button-class))
                 "+ new job run")
              (a (@ (href "/profiles/manage/create")
                    (class ,nav-button-class))
                 "+ new profile")))))

(define-public (page-footer)
  `((div (@(class "block text-center font-mono"))
         (hr (@(class ,hr-class)))
         (div (@(class "mt-4 flex flex-row flex-wrap gap-4 justify-center align-center"))
              (p (@(class "text-sm text-stone-300")) "find the source code here:")
              (a (@(class "text-green-400 font-bold cursor-pointer text-sm")
                  (href "https://codeberg.org/jjba23/iter-vitae"))
                 "https://codeberg.org/jjba23/iter-vitae")
              )
         (p (@(class "mt-4"))
            (span (@(class "text-sm text-stone-300"))
                  "iter-vitae-word-meaning")))))


;; Page

(define-public (iter-vitae-curriculum-page)
  (with-output-to-string
    (lambda ()
      (sxml->xml
       (iter-vitae-html-template
        "Iter Vitae"
        `((h2 (@(class ,h2-class)) "Josep Bigorra")
          )))))
  )
