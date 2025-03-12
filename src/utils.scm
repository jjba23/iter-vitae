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

(define-module (iter-vitae utils))

;; for translatable fields, behave like assq-ref
;; but by ensuring if 'all is specified, it is
;; highest priority
;;
;; k is expected to be a symbol
(define-public (assq-ref-all-or-lang al k)
  (cond
   ((not (equal? #f
                 (assq 'all al)))
    (assq-ref al
              'all))
   ((not (equal? #f
                 (assq k al)))
    (assq-ref al k))
   (else (symbol->string k))))

