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

(define hr/class
  (string-join
   '("my-6" "border-t-2" "border-t-stone-300") " "))


(define p/class
  (string-join
   '("my-4" "font-mono" "text-md" "text-black-800")))

(define small/class
  (string-join
   '("my-2" "font-mono" "text-sm" "text-black-700")))

(define small-a/class
  (string-join
   '("my-2" "font-mono" "text-sm" "text-green-900")))

(define h1/class
  (string-join
   '("my-2" "font-mono" "text-3xl" "text-black-800")))

(define h2/class
  (string-join
   '("my-2" "font-mono" "text-xl" "uppercase" "text-green-800")))
