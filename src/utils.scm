;; for translatable fields, behave like assq-ref
;; but by ensuring if 'all is specified, it is
;; highest priority
(define (assq-ref-all-or-lang al key)
  (cond
   ((not (equal? #f (assq 'all al)))
    (assq-ref al 'all)
    )
   ((not (equal? #f (assq key al)))
    (assq-ref al key)
    )
   (else #f)
   )
  )
