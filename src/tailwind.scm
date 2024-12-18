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

(use-modules (ice-9 popen)
             (ice-9 textual-ports)
             (ice-9 time)
             (ice-9 format)
             (ice-9 string-fun)
             (ice-9 iconv)
             (ice-9 futures))

(define hr/tailwind
  (string-join '("my-4" "border-t-2" "border-t-stone-200") " "))

(define p/tailwind
  (string-join '("my-4" "font-mono" "text-lg" "text-black-800" "max-w-prose")
               " "))

(define bullet/tailwind
  (string-join '("my-2" "ml-4" "font-mono" "text-lg" "text-black-700"
                 "max-w-prose") " "))

(define small/tailwind
  (string-join '("my-2" "font-mono" "text-sm" "text-black-600") " "))

(define address/tailwind
  (string-join '("font-mono" "text-lg" "text-black-800") " "))

(define small-a/tailwind
  (string-join '("my-2" "font-mono" "text-base" "text-green-900") " "))

(define h1/tailwind
  (string-join '("my-3" "font-mono" "text-3xl" "text-black-800") " "))

(define h2/tailwind
  (string-join '("my-3" "font-mono" "text-2xl" "uppercase" "text-green-800")
               " "))

(define h4/tailwind
  (string-join '("my-2" "text-2xl" "font-bold uppercase") " "))

(define iter-vitae-display-name/tailwind
  (string-join '("my-3" "font-mono" "text-4xl" "text-black-800" "font-bold")
               " "))
