;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; One list of themes shared by the renderer, the HTML dispatcher and the
;; `--all-themes' mode.  Keeping the order here means a new theme is added in
;; one place instead of three.

(define-module (iter-vitae theme registry)
  #:declarative? #t
  #:use-module (iter-vitae theme ats)
  #:use-module (iter-vitae theme ef-cyprus)
  #:use-module (iter-vitae theme fatum)
  #:use-module (iter-vitae theme fundamental)
  #:export (document-themes normalize-theme theme-procedures))

;; ATS comes first because it is the version to inspect before sending a CV to
;; an automated application system.  The other themes follow in visual order.
(define document-themes
  '(ats fatum ef-cyprus fundamental))

(define (normalize-theme theme)
  "Return @var{theme} when it is known, otherwise the default theme."
  (if (memq theme document-themes)
      theme
      'ef-cyprus))

(define (theme-procedures theme)
  "Return a pair of the HTML template and body procedures for @var{theme}."
  (case (normalize-theme theme)
    ((ats)
     (cons ats-html-template ats-main-body))
    ((fatum)
     (cons fatum-html-template fatum-main-body))
    ((fundamental)
     (cons fundamental-html-template fundamental-main-body))
    (else
     (cons ef-cyprus-html-template ef-cyprus-main-body))))
