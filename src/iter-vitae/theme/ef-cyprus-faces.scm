;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae theme ef-cyprus-faces)
  #:declarative? #t
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 time)
  #:use-module (ice-9 format)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 futures)
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
  (mk-class '(my-2 md:my-4 border-t-2 border-t-onyx-200)))

(define bullet-face
  (mk-class '(ml-2 md:ml-4
                   leading-6
                   md:leading-7
                   font-sans
                   text-md
                   md:text-lg
                   text-onyx-500)))

(define address-face
  (mk-class '(my-1 md:my-2 font-sans text-sm md:text-md text-onyx-500)))

(define small-a-face
  (mk-class '(my-1 md:my-2
                   font-sans
                   font-bold
                   text-sm
                   md:text-md
                   cursor-pointer
                   no-underline
                   text-asparagus-700
                   hover:text-asparagus-300
                   hover:underline)))

(define a-face
  (mk-class '(my-2 md:my-3
                   font-sans
                   font-bold
                   text-md
                   md:text-lg
                   cursor-pointer
                   text-asparagus-700
                   hover:text-asparagus-300
                   hover:underline)))

(define h2-special-face
  (mk-class '(my-1 font-sans
                   text-xl
                   md:text-2xl
                   no-underline
                   hover:underline
                   font-light
                   uppercase
                   text-asparagus-700)))

(define h2-link-special-face
  (mk-class '(my-2 md:my-3
                   hover:underline
                   font-sans
                   no-underline
                   font-light
                   text-xl
                   md:text-2xl
                   uppercase
                   text-asparagus-700
                   hover:text-asparagus-300)))

(define h4-face
  (mk-class '(my-1 md:my-2
                   text-xl
                   md:text-2xl
                   font-light
                   uppercase
                   text-onyx-500)))

(define h5-face
  (mk-class '(text-md md:text-lg font-light text-onyx-700)))

(define h5-strong-face
  (mk-class '(text-md md:text-lg font-medium text-onyx-700)))

(define h5-em-face
  (mk-class '(text-sm md:text-md font-light text-onyx-300)))

(define td-face
  (mk-class '(px-3 md:px-5
                   py-1
                   md:py-2
                   text-sm
                   md:text-md
                   text-onyx-100)))

(define first-td-face
  (mk-class '(px-3 md:px-5
                   py-1
                   md:py-2
                   text-sm
                   md:text-md
                   text-onyx-100
                   font-bold)))

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
  (mk-class '(my-3 text-4xl
                   md:text-5xl
                   lg:text-6xl
                   font-serif
                   text-onyx-300
                   font-light)))

(define p-face
  (mk-class '(my-4 font-sans
                   text-md
                   md:text-lg
                   text-onyx-500
                   w-full
                   max-w-prose
                   leading-7)))

(define th-face
  (mk-class '(py-1 px-2
                   md:px-4
                   text-sm
                   md:text-md
                   font-light
                   uppercase
                   whitespace-nowrap)))
