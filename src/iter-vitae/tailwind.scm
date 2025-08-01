;;; Iter Vitae 

;; Copyright © Josep Jesus Bigorra Algaba

;; iter-vitae is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; iter-vitae is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public License
;; along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

(define-module (iter-vitae tailwind)
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
                    small-face
                    address-face
                    small-a-face
                    h2-special-face
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
  (mk-class '(my-4 border-t-2 border-t-stone-200)))

(define p-face
  (mk-class '(my-4 font-sans text-lg text-black-800 max-w-prose)))

(define bullet-face
  (mk-class '(my-2 ml-8 font-sans text-lg text-stone-700)))

(define small-face
  (mk-class '(my-2 font-sans text-sm text-stone-600)))

(define address-face
  (mk-class '(font-sans text-sm text-stone-700)))

(define small-a-face
  (mk-class '(my-2 font-sans font-bold text-sm text-green-800/80 hover:text-green-900 hover:underline)))

(define a-face
  (mk-class '(my-3 font-sans font-bold text-md text-green-800/80 hover:text-green-900 hover:underline)))

(define h2-special-face
  (mk-class '(my-3 font-sans text-2xl font-light uppercase text-green-800/80)))

(define h2-link-special-face
  (mk-class '(my-3 hover:underline font-sans font-light text-2xl uppercase text-green-800/80 hover:text-green-900)))

(define h4-face
  (mk-class '(my-2 text-2xl font-light uppercase text-stone-600)))

(define h5-face
  (mk-class '(text-xl font-light text-stone-800)))

(define h5-strong-face
  (mk-class '(text-xl font-medium text-stone-800)))

(define h5-em-face
  (mk-class '(text-md font-light text-stone-700)))

(define display-name-face
  (mk-class '(my-3 font-sans text-5xl text-stone-800/90 font-light)))

(define td-face
  (mk-class '(px-5 py-1 text-xs)))

(define first-td-face
  (mk-class '(px-5 py-1 text-sm)))

(define table-face
  (mk-class '(table-auto bg-stone-100 rounded-xl my-8 shadow-md text-center)))

(define top-row-face
  (mk-class '(py-2)))

(define th-face
  (mk-class '(py-1 text-sm font-light uppercase)))
