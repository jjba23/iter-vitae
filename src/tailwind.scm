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

(define-module (iter-vitae tailwind)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 time)
  #:use-module (ice-9 format)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 futures))

(define-public hr/tailwind
  (string-join '("my-4" "border-t-2" "border-t-stone-200") " "))

(define-public p/tailwind
  (string-join '("my-4" "font-sans" "text-lg" "text-black-800" "max-w-prose")
               " "))

(define-public bullet/tailwind
  (string-join '("my-2" "ml-4" "font-sans" "text-lg" "text-black-700"
                 "max-w-prose") " "))

(define-public small/tailwind
  (string-join '("my-2" "font-sans" "text-sm" "text-black-600") " "))

(define-public address/tailwind
  (string-join '("font-sans" "text-lg" "text-black-800") " "))

(define-public small-a/tailwind
  (string-join '("my-2" "font-sans" "text-base" "text-green-900") " "))

(define-public h1/tailwind
  (string-join '("my-3" "font-sans" "text-3xl" "text-stone-800") " "))

(define-public h2/tailwind
  (string-join '("my-3" "font-sans" "font-bold" "text-2xl" "uppercase"
                 "text-green-800") " "))

(define-public h4/tailwind
  (string-join '("my-2" "text-2xl" "font-bold uppercase") " "))

(define-public iter-vitae-display-name/tailwind
  (string-join '("my-3" "font-sans" "text-4xl" "text-black-800" "font-bold")
               " "))
