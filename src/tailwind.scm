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

(define button-class
(string-join
 '("bg-green-500/75"
   "text-stone-300"
   "rounded-xl"
   "cursor-pointer"
   "p-2"
   "border"
   "w-fit"
   "m-2"
   "text-lg"
   "font-mono"
   "font-bold") " "))

(define nav-button-class
  (string-join
   '(
     "text-green-500/75"
     "cursor-pointer"
     "p-2"
     "m-2"
     "border-b-2"
     "font-mono"
     "border-b-green-500/25"
     "text-xl"
     "font-bold") " "))

(define danger-button-class
  (string-join
   '("rounded-xl"
     "bg-red-700"
     "text-stone-300"
     "font-bold"
     "w-fit"
     "border"
     "text-lg"
     "cursor-pointer"
     "p-2"
     "font-mono"
     "m-2") " "))

(define input-class
  (string-join
   '("rounded-xl"
     "border"
     "border-stone-500"
     "p-2"
     "ml-6"
     "text-lg"
     "bg-stone-800"
     "text-stone-300"
     "font-mono"
     ) " "))

(define hr-class
  (string-join
   '("my-6" "border-t-2" "border-t-stone-600") " "))

(define h2-class
  (string-join
   '("text-3xl" "text-stone-300" "my-4" "font-bold" "font-mono") " "))



(define textarea-class
  (string-join
   '("rounded-xl"
     "border"
     "border-stone-500"
     "p-2"
     "ml-6"
     "w-full"
     "text-lg"
     "bg-stone-800"
     "font-mono"
     "text-stone-300"
     "min-h-64"
     ) " "))

(define dash-link-face
  "text-stone-300 font-bold cursor-pointer text-xl font-mono")
