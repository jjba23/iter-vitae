;;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; Plain-text output for employers that only accept `.txt' uploads.  The
;; resume body comes from the ATS theme, so both formats share the same
;; conventional section order and the same HTML/emoji/punctuation cleanup.
;; This module only turns that SXML body into readable lines.

(define-module (iter-vitae text)
  #:declarative? #t
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (iter-vitae theme ats)
  #:export (render-plain-text))

;; Return the children of an element, skipping its attribute list.
(define (element-body node)
  (let ((rest (cdr node)))
    (if (and (pair? rest)
             (pair? (car rest))
             (eq? (caar rest) '@))
        (cdr rest)
        rest)))

;; Flatten inline markup (`a', `strong', and so on) to its visible text.
;; Attributes such as href are deliberately ignored: a text resume should
;; contain the URL the reader can see, not HTML syntax.
(define (inline-text node)
  (cond
    ((string? node) node)
    ((pair? node)
     (if (symbol? (car node))
         (inline-text (element-body node))
         (string-concatenate (map inline-text node))))
    (else "")))

;; Turn a block of the ATS body into lines.  Headings get surrounding blank
;; lines; entries keep their title, metadata and bullets together.
(define (node-lines node)
  (cond
    ((string? node) (list node))
    ((pair? node)
     (if (symbol? (car node))
         (let ((tag (car node))
               (body (element-body node)))
           (case tag
             ((h1) (list (inline-text body)))
             ((h2) (list "" (string-upcase (inline-text body)) ""))
             ((h3) (list "" (inline-text body)))
             ((p) (list (inline-text body)))
             ((ul) (append-map node-lines body))
             ((li) (list (string-append "- " (inline-text body))))
             ((div) (append-map node-lines body))
             (else (node-lines body))))
         (append-map node-lines node)))
    (else '())))

(define (blank-line? line)
  (string-null? line))

;; Several blocks introduce their own blank line.  Collapse the resulting
;; doubles so the file never contains a run of empty lines.
(define (collapse-blank-lines lines)
  (let loop ((remaining lines) (result '()) (previous-blank? #f))
    (cond
      ((null? remaining) (reverse result))
      ((blank-line? (car remaining))
       (if previous-blank?
           (loop (cdr remaining) result #t)
           (loop (cdr remaining) (cons "" result) #t)))
      (else
       (loop (cdr remaining) (cons (car remaining) result) #f)))))

(define (trim-blank-lines lines)
  (reverse (drop-while blank-line?
                       (reverse (drop-while blank-line? lines)))))

;; Text has no CSS to wrap long paragraphs.  Keep lines readable in a plain
;; editor while never splitting a word: bullets hang their continuation lines
;; under the bullet text, and ordinary paragraphs wrap at the same width.
(define text-width 100)

;; Contact and metadata lines use ` | ' between independent fields.  Wrap them
;; at those separators so a label is never separated from its URL or date.
(define (wrap-pipe-line line)
  (let ((items (filter (lambda (item) (not (string-null? item)))
                       (map string-trim-both (string-split line #\|)))))
    (if (or (null? items)
            (any (lambda (item) (> (string-length item) text-width))
                 items))
        (list line)
        (let loop ((remaining items)
                   (current #f)
                   (result '()))
          (cond
            ((null? remaining) (reverse (cons (or current "") result)))
            (else
             (let* ((item (car remaining))
                    (candidate (if current
                                   (string-append current " | " item)
                                   item)))
               (if (or (not current)
                       (<= (string-length candidate) text-width))
                   (loop (cdr remaining) candidate result)
                   (loop (cdr remaining) item (cons current result))))))))))

(define (wrap-line line)
  (cond
    ((<= (string-length line) text-width) (list line))
    ((string-contains line " | ") (wrap-pipe-line line))
    (else
     (let* ((bullet? (string-prefix? "- " line))
            (first-prefix (if bullet? "- " ""))
            (next-prefix (if bullet? "  " ""))
            (content (if bullet? (substring line 2) line))
            (words (string-tokenize content)))
       (if (or (null? words)
               (any (lambda (word)
                      (> (+ (string-length first-prefix)
                            (string-length word))
                         text-width))
                    words))
           ;; A single word is wider than the page; leave it intact.
           (list line)
           (let loop ((remaining words)
                      (current first-prefix)
                      (result '()))
             (cond
               ((null? remaining) (reverse (cons current result)))
               (else
                (let* ((word (car remaining))
                       (candidate
                        (if (string=? current first-prefix)
                            (string-append current word)
                            (string-append current " " word))))
                  (if (<= (string-length candidate) text-width)
                      (loop (cdr remaining) candidate result)
                      (loop (cdr remaining)
                            (string-append next-prefix word)
                            (cons current result))))))))))))

(define* (render-plain-text #:key locale persona)
  "Render @var{persona} as a plain-text resume for @var{locale}."
  (let* ((lines (append-map node-lines
                            (ats-main-body #:locale locale
                                           #:persona persona)))
         (lines (trim-blank-lines (collapse-blank-lines lines)))
         (lines (append-map wrap-line lines)))
    (if (null? lines)
        ""
        (string-append (string-join lines "\n") "\n"))))
