;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae html)
  #:declarative? #t
  #:use-module (web server)
  #:use-module (web request)
  #:use-module (web response)
  #:use-module (web uri)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (sxml ssax input-parse)
  #:use-module (sxml ssax)
  #:use-module (sxml transform)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 time)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (iter-vitae prelude)
  #:use-module (iter-vitae theme ef-cyprus)
  #:use-module (iter-vitae theme fatum)
  #:use-module (iter-vitae theme fundamental)
  #:use-module (iter-vitae theme ats)
  #:use-module (ice-9 threads)
  #:export (iter-vitae-curriculum-page sxml->xml))

;; ====== Serialize (SXML) ======

(define check-name
  (let ((*good-cache* (make-hash-table)))
    (lambda (name)
      (if (not (hashq-ref *good-cache* name))
          (let* ((str (symbol->string name))
                 (i (string-index str #\:))
                 (head (or (and i
                                (substring str 0 i)) str))
                 (tail (and i
                            (substring str
                                       (1+ i)))))
            (and i
                 (string-index (substring str
                                          (1+ i)) #\:)
                 (error "Invalid QName: more than one colon" name))
            (for-each (lambda (s)
                        (and s
                             (or (char-alphabetic? (string-ref s 0))
                                 (eq? (string-ref s 0) #\_)
                                 (error "Invalid name starting character" s
                                        name))
                             (string-for-each (lambda (c)
                                                (or (char-alphabetic? c)
                                                    (string-index
                                                     "0123456789.-_" c)
                                                    (error
                                                     "Invalid name character"
                                                     c s name))) s)))
                      (list head tail))
            (hashq-set! *good-cache* name #t))))))

;; The following two functions serialize tags and attributes. They are
;; being used in the node handlers for the post-order function, see
;; below.

(define (attribute-value->xml value port)
  (cond
    ((pair? value)
     (attribute-value->xml (car value) port)
     (attribute-value->xml (cdr value) port))
    ((null? value)
     *unspecified*)
    ((string? value)
     (string->escaped-xml value port))
    ((procedure? value)
     (with-output-to-port port value))
    (else (string->escaped-xml (call-with-output-string (lambda (port)
                                                          (display value port)))
                               port))))

(define (attribute->xml attr value port)
  (check-name attr)
  (display attr port)
  (display "=\"" port)
  (attribute-value->xml value port)
  (display #\" port))

(define (element->xml tag attrs body port escape?)
  (check-name tag)
  (display #\< port)
  (display tag port)
  (if attrs
      (let lp
        ((attrs attrs))
        (if (pair? attrs)
            (let ((attr (car attrs)))
              (display #\space port)
              (if (pair? attr)
                  (attribute->xml (car attr)
                                  (cdr attr) port)
                  (error "bad attribute" tag attr))
              (lp (cdr attrs)))
            (if (not (null? attrs))
                (error "bad attributes" tag attrs)))))
  (if (pair? body)
      (begin
        (display #\> port)
        ;; Text is escaped so persona content can contain &, < and >.  `style'
        ;; and `script' are raw-text elements in HTML: escaping their contents
        ;; would turn CSS child selectors such as `a > b' into `a &gt; b'.
        (let ((text-escape? (if (memq tag '(style script))
                                #f
                                escape?)))
          (let lp
            ((body body))
            (cond
              ((pair? body)
               (sxml->xml (car body) port text-escape?)
               (lp (cdr body)))
              ((null? body)
               (display "</" port)
               (display tag port)
               (display ">" port))
              (else (error "bad element body" tag body))))))
      (display " />" port)))

;; FIXME: ensure name is valid
(define (entity->xml name port)
  (display #\& port)
  (display name port)
  (display #\; port))

;; FIXME: ensure tag and str are valid
(define (pi->xml tag str port)
  (display "<?" port)
  (display tag port)
  (display #\space port)
  (display str port)
  (display "?>" port))

;; Persona fields may contain the small amount of inline HTML documented in
;; the README.  This mode escapes ordinary text (including stray ampersands)
;; while keeping well-formed tags intact: `<em class="italic">x & y</em>' is
;; written as `<em class="italic">x &amp; y</em>'.  It is deliberately a
;; tokenizer rather than a full parser; anything that does not look like a tag
;; is treated as text.
(define (tag-start? str index)
  (let ((length (string-length str)))
    (and (< (+ index 1) length)
         (let ((next (string-ref str (+ index 1))))
           (or (char-alphabetic? next)
               (and (char=? next #\/)
                    (< (+ index 2) length)
                    (char-alphabetic? (string-ref str (+ index 2)))))))))

(define (find-tag-end str start)
  (let ((length (string-length str)))
    (let loop ((index (+ start 1)) (quote #f))
      (if (>= index length)
          #f
          (let ((char (string-ref str index)))
            (cond
              (quote (loop (1+ index) (if (char=? char quote) #f quote)))
              ((or (char=? char #\") (char=? char #\'))
               (loop (1+ index) char))
              ((char=? char #\>) index)
              (else (loop (1+ index) #f))))))))

(define (write-inline-text text port)
  (string->escaped-xml (decode-html-entities text) port))

(define (string->inline-html str port)
  (let ((length (string-length str)))
    (let loop ((start 0))
      (let ((lt (string-index str #\< start)))
        (cond
          ((not lt) (write-inline-text (substring str start length) port))
          ((tag-start? str lt)
           (let ((end (find-tag-end str lt)))
             (if end
                 (begin
                   (write-inline-text (substring str start lt) port)
                   (display (substring str lt (+ end 1)) port)
                   (loop (+ end 1)))
                 (begin
                   (write-inline-text (substring str start (+ lt 1)) port)
                   (loop (+ lt 1))))))
          (else
           (write-inline-text (substring str start (+ lt 1)) port)
           (loop (+ lt 1))))))))

(define* (sxml->xml tree
                    #:optional (port (current-output-port))
                    (escape? #t))
  "Serialize the sxml tree @var{tree} as XML. The output will be written
to the current output port, unless the optional argument @var{port} is
present."
  (cond
    ((pair? tree)
     (if (symbol? (car tree))
         ;; An element.
         (let ((tag (car tree)))
           (case tag
             ((*TOP*)
              (sxml->xml (cdr tree) port escape?))
             ((*ENTITY*)
              (if (and (list? (cdr tree))
                       (= (length (cdr tree)) 1))
                  (entity->xml (cadr tree) port)
                  (error "bad *ENTITY* args"
                         (cdr tree))))
             ((*PI*)
              (if (and (list? (cdr tree))
                       (= (length (cdr tree)) 2))
                  (pi->xml (cadr tree)
                           (caddr tree) port)
                  (error "bad *PI* args"
                         (cdr tree))))
             (else (let* ((elems (cdr tree))
                          (attrs (and (pair? elems)
                                      (pair? (car elems))
                                      (eq? '@
                                           (caar elems))
                                      (cdar elems))))
                     (element->xml tag attrs
                                   (if attrs
                                       (cdr elems) elems) port escape?)))))
         ;; A nodelist.
         (for-each (lambda (x)
                     (sxml->xml x port escape?)) tree)))
    ((string? tree)
     (cond
       ;; The doctype is deliberately a raw top-level string in every template.
       ;; Escaping it would turn the document into text when a theme asks for
       ;; escaped element content (as the plain-text ATS theme does).
       ((string-prefix? "<!DOCTYPE" tree) (display tree port))
       ((eq? escape? 'inline-html) (string->inline-html tree port))
       (escape? (string->escaped-xml tree port))
       (else (display tree port))))
    ((null? tree)
     *unspecified*)
    ((not tree)
     *unspecified*)
    ((eqv? tree #t)
     *unspecified*)
    ((procedure? tree)
     (with-output-to-port port tree))
    (else (when escape?
            (string->escaped-xml (call-with-output-string (lambda (port)
                                                            (display tree port)))
                                 port)))))

(define (sxml->string sxml)
  "Detag an sxml tree @var{sxml} into a string. Does not perform any
formatting."
  (string-concatenate-reverse (foldts (lambda (seed tree)
                                        ;; fdown
                                        '())
                                      (lambda (seed kid-seed tree)
                                        ;; fup
                                        (append! kid-seed seed))
                                      (lambda (seed tree)
                                        ;; fhere
                                        (if (string? tree)
                                            (cons tree seed) seed))
                                      '() sxml)))

(define (make-char-quotator char-encoding)
  (let ((bad-chars (list->char-set (map car char-encoding))))
    
    ;; Check to see if str contains one of the characters in charset,
    ;; from the position i onward. If so, return that character's index.
    ;; otherwise, return #f
    (define (index-cset str i charset)
      (string-index str charset i))

    ;; The body of the function
    (lambda (str port)
      (let ((bad-pos (index-cset str 0 bad-chars)))
        (if (not bad-pos)
            (display str port) ;str had all good chars
            (let loop
              ((from 0)
               (to bad-pos))
              (cond
                ((>= from
                     (string-length str))
                 *unspecified*)
                ((not to)
                 (display (substring str from
                                     (string-length str)) port))
                (else (let ((quoted-char (cdr (assv (string-ref str to)
                                                    char-encoding)))
                            (new-to (index-cset str
                                                (+ 1 to) bad-chars)))
                        (if (< from to)
                            (display (substring str from to) port))
                        (display quoted-char port)
                        (loop (1+ to) new-to))))))))))

;; Given a string, check to make sure it does not contain characters
;; such as '<' or '&' that require encoding. Return either the original
;; string, or a list of string fragments with special characters
;; replaced by appropriate character entities.

(define string->escaped-xml
  (make-char-quotator '((#\< . "&lt;") (#\> . "&gt;")
                        (#\& . "&amp;")
                        (#\" . "&quot;"))))

;; ================================

(define* (iter-vitae-curriculum-page #:key locale persona (resources "resources"))
  (let* ((requested-theme (assq-ref persona
                                    'document-theme))
         ;; 1. Resolve unknown themes to the default before deciding how the
         ;; page is serialized.  Almost every theme keeps the documented inline
         ;; HTML support, so only the plain-text ATS theme escapes persona text.
         (theme (case requested-theme
                  ((fundamental) 'fundamental)
                  ((fatum) 'fatum)
                  ((ats) 'ats)
                  (else 'ef-cyprus)))
         (escape? (if (eq? theme 'ats) #t 'inline-html))
         (title (assq-ref-all-or-lang (assq-ref persona
                                                'display-name) locale))
         ;; 2. Determine the correct template and body procedures based on the theme
         (procs (case theme
                  ((fundamental)
                   (cons fundamental-html-template fundamental-main-body))
                  ((fatum)
                   (cons fatum-html-template fatum-main-body))
                  ((ats)
                   (cons ats-html-template ats-main-body))
                  (else (cons ef-cyprus-html-template ef-cyprus-main-body))))
         (template-fn (car procs))
         (body-fn (cdr procs)))
    
    ;; 3. Execute the SXML generation and string conversion once
    (with-output-to-string
     (lambda ()
       (sxml->xml (template-fn #:title title
                               #:persona persona
                               #:locale locale
                               #:resources resources
                               #:body (body-fn #:locale
                                               locale
                                               #:persona
                                               persona))
                  (current-output-port)
                  escape?)))))
