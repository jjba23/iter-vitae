;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; The lapis faces: prose is set in Source Serif 4, and everything that reads
;; as data - role, section labels, dates, skill tags, table headers - in
;; JuliaMono.  That pairing is the visible difference from fatum, which sets
;; its prose in Work Sans.
;;
;; The palette is greys and blues only: `onyx' for text, `stone' for surfaces,
;; `prussian-blue' for labels and `jeans-blue' for links.  The two blue hues
;; (254 and 256 degrees) stay next to the neutral greys of the Olive tokens.
;;
;; No face names `font-sans': lapis wants the serif and mono faces everywhere.
(define-module (iter-vitae theme lapis-faces)
  #:declarative? #t
  #:use-module (iter-vitae prelude)
  #:export (hr-face p-face
                    bullet-face
                    address-face
                    small-a-face
                    h2-special-face
                    a-face
                    h4-face
                    h5-face
                    h5-strong-face
                    h5-em-face
                    td-face
                    first-td-face
                    table-face
                    th-face
                    top-row-face
                    display-name-face))

(define hr-face
  (mk-class '(my-2 md:my-4 border-t-2)))

(define bullet-face
  (mk-class '(ml-2 md:ml-4
                   mb-2
                   leading-6
                   md:leading-7
                   font-serif
                   text-md
                   md:text-lg
                   text-onyx-500)))

(define address-face
  (mk-class '(my-1 md:my-2 font-mono text-xs md:text-sm text-onyx-500)))

(define small-a-face
  (mk-class '(my-1 md:my-2
                   font-serif
                   font-bold
                   text-sm
                   md:text-md
                   cursor-pointer
                   no-underline
                   text-jeans-blue-700
                   hover:text-prussian-blue-300
                   hover:underline)))

(define a-face
  (mk-class '(my-2 md:my-3
                   font-serif
                   font-bold
                   text-md
                   md:text-lg
                   cursor-pointer
                   text-jeans-blue-700
                   hover:text-prussian-blue-300
                   hover:underline)))

(define h2-special-face
  (mk-class '(my-1 font-mono
                   text-sm
                   md:text-md
                   no-underline
                   hover:underline
                   font-normal
                   uppercase
                   tracking-wide
                   text-prussian-blue-300)))

(define h4-face
  (mk-class '(my-1 md:my-2
                   text-sm
                   md:text-md
                   font-mono
                   font-normal
                   uppercase
                   tracking-wide
                   text-onyx-500)))

(define h5-face
  (mk-class '(font-serif text-md md:text-lg font-semibold text-onyx-700)))

(define h5-strong-face
  (mk-class '(font-serif text-md md:text-lg font-semibold text-onyx-900)))

(define h5-em-face
  (mk-class '(font-serif text-sm md:text-md font-light italic text-onyx-300)))

(define td-face
  (mk-class '(px-3 md:px-5
                   py-1
                   md:py-2
                   font-serif
                   text-sm
                   md:text-md
                   text-onyx-500)))

(define first-td-face
  (mk-class '(px-3 md:px-5
                   py-1
                   md:py-2
                   font-serif
                   text-sm
                   md:text-md
                   font-bold
                   text-onyx-700)))

(define table-face
  (mk-class '(w-full table-auto
                     bg-stone-300
                     rounded-lg
                     md:rounded-xl
                     my-4
                     md:my-8
                     shadow-md
                     text-center)))

(define top-row-face
  (mk-class '(py-1 md:py-2)))

(define display-name-face
  (mk-class '(my-3 font-serif
                   font-light
                   text-4xl
                   md:text-5xl
                   lg:text-6xl
                   text-onyx-700)))

(define p-face
  (mk-class '(my-4 font-serif
                   text-md
                   md:text-lg
                   text-onyx-500
                   w-full
                   max-w-prose
                   leading-7)))

(define th-face
  (mk-class '(py-1 px-2
                   md:px-4
                   font-mono
                   text-xs
                   md:text-sm
                   font-normal
                   uppercase
                   tracking-wide
                   whitespace-nowrap
                   text-onyx-300)))
