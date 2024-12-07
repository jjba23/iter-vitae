;; for translatable fields, behave like assq-ref
;; but by ensuring if 'all is specified, it is
;; highest priority
;;
;; k is expected to be a symbol
(define (assq-ref-all-or-lang al k)  
  (cond
   ((not (equal? #f (assq 'all al)))
    (assq-ref al 'all)
    )
   ((not (equal? #f (assq k al)))
    (assq-ref al k)
    )
   (else #f)
   )
  )
