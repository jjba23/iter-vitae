;;; Iter Vitae 

;; Copyright © Josep Jesus Bigorra Algaba

;; iter-vitae is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; iter-vitae is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public License
;; along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

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
  #:use-module (iter-vitae tailwind)
  #:use-module (iter-vitae prelude)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 threads))

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

(define (element->xml tag attrs body port)
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
        (let lp
          ((body body))
          (cond
            ((pair? body)
             (sxml->xml (car body) port)
             (lp (cdr body)))
            ((null? body)
             (display "</" port)
             (display tag port)
             (display ">" port))
            (else (error "bad element body" tag body)))))
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

(define* (sxml->xml tree
                    #:optional (port (current-output-port))
                    (escape? #f))
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
                                       (cdr elems) elems) port)))))
         ;; A nodelist.
         (for-each (lambda (x)
                     (sxml->xml x port)) tree)))
    ((string? tree)
     (if escape?
         (string->escaped-xml tree port)
         (display tree port)))
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

(begin
  (define* (iter-vitae-html-template #:key title body locale persona)
    `("<!DOCTYPE html>" (html (head (title ,title)
                                    (link (@ (rel preconnect)
                                             (href
                                              "https://fonts.googleapis.com")))
                                    (link (@ (rel preconnect)
                                             (href "https://fonts.gstatic.com")
                                             (crossorigin "")))
                                    (link (@ (rel stylesheet)
                                             (href
                                              "https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;1,100;1,200;1,300;1,400;1,500;1,600;1,700&family=IBM+Plex+Sans:ital,wght@0,100..700;1,100..700&family=IBM+Plex+Serif:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;1,100;1,200;1,300;1,400;1,500;1,600;1,700&display=swap")))
                                    (link (@ (rel stylesheet)
                                             (type text/css)
                                             (href
                                              "https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.1/src/regular/style.css")))
                                    (style (@ (type "text/tailwindcss"))
                                     "
@custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));

@theme {
  --font-sans: \"IBM Plex Sans\", sans-serif;
  --font-mono: \"IBM Plex Mono\", monospace;
}
")
                                    (meta (@ (name "viewport")
                                             (content
                                              "width=device-width, initial-scale=1.0")))
                                    (meta (@ (charset "UTF-8")))
                                    (script (@ (src "js/tailwind.js")) ""))
                              (body (@ (class "break-words"))
                                    (div (@ (class ,(mk-class '(container
                                                                mx-auto py-4
                                                                sm:py-6 px-3
                                                                sm:px-6))))
                                         ,@body
                                         ,(iter-vitae-page-footer #:persona
                                                                  persona
                                                                  #:locale
                                                                  locale))))))
  (export iter-vitae-html-template))

(begin
  (define* (iter-vitae-page-footer #:key locale persona)
    `((hr (@ (class ,hr-face)))
      (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-2 justify-evenly))))
           ,(render-iter-vitae-blog-link #:locale locale
                                         #:persona persona)
           ,(render-iter-vitae-code-link #:locale locale
                                         #:persona persona)
           ,(render-iter-vitae-linked-in-link #:locale locale
                                              #:persona persona))
      (div (@ (class ,(mk-class '(block text-center font-sans))))
           (div (@ (class ,(mk-class '(flex flex-row gap-3 flex-wrap
                                            justify-center))))
                (small (@ (class ,small-face))
                 "this Curriculum Vitae was rendered with Lisp (Guile Scheme) code"))
           (div (@ (class ,(mk-class '(flex flex-row gap-3 flex-wrap
                                            justify-center items-center))))
                (small (@ (class ,small-face)) "find the source code here:")
                (a (@ (class ,(mk-class '(text-green-900 text-sm font-sans)))
                      (href "https://codeberg.org/jjba23/iter-vitae"))
                   "codeberg.org/jjba23/iter-vitae")))))
  (export iter-vitae-page-footer))

(define* (render-iter-vitae-display-name #:key locale persona)
  `(h1 (@ (class ,display-name-face))
       ,(assq-ref-all-or-lang (assq-ref persona
                                        'display-name) locale)))

(define* (render-iter-vitae-job-title #:key locale persona)
  `(p (@ (class ,h2-special-face))
      ,(assq-ref-all-or-lang (assq-ref persona
                                       'job-title) locale)))

(define* (render-iter-vitae-email #:key locale persona)
  `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-envelope text-stone-600 text-xl))))
            "")
         (small (@ (class ,small-face))
                ,(assq-ref (assq-ref persona
                                     'personal-contact)
                           'emails)))))

(define* (render-iter-vitae-phone-number #:key locale persona)
  `((div (@ (class ,(mk-class '(flex gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-phone text-stone-600 text-xl)))) "")
         (small (@ (class ,small-face))
                ,(assq-ref (assq-ref persona
                                     'personal-contact)
                           'phone-numbers)))))

(define* (render-iter-vitae-blog-link #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-rss text-stone-600 xl)))) "")
         (a (@ (class ,small-a-face)
               (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'blog))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'blog)))))

(define* (render-iter-vitae-code-link #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-code text-stone-600 text-xl)))) "")
         (a (@ (class ,small-a-face)
               (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'code))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'code)))))

(define* (render-iter-vitae-linked-in-link #:key locale persona)
  `((div (@ (class ,(mk-class '(flex flex-row gap-1 items-center))))
         (i (@ (class ,(mk-class '(ph ph-link text-stone-600 text-xl)))) "")
         (a (@ (class ,small-a-face)
               (target "_blank")
               (href ,(format #f "https://~a"
                              (assq-ref (assq-ref persona
                                                  'personal-links)
                                        'linked-in))))
            ,(assq-ref (assq-ref persona
                                 'personal-links)
                       'linked-in)))))

(define* (render-iter-vitae-address-lines #:key locale persona)
  `(small (@ (class ,(mk-class '(flex flex-col gap-1))))
          ,(map (lambda (address-line)
                  `(span (@ (class ,address-face))
                         ,(assq-ref-all-or-lang address-line locale)))
                (assq-ref persona
                          'address-lines))))

(define* (render-iter-vitae-driver-licenses #:key locale persona)
  `(p (@ (class ,p-face))
      ,(map (lambda (driver-license)
              `(span (@ (class ,(mk-class '(mr-4))))
                     ,(assq-ref-all-or-lang driver-license locale)))
            (assq-ref persona
                      'driver-licenses))))

(define* (render-iter-vitae-short-intro #:key locale persona)
  (map (lambda (intro-line)
         `(p (@ (class ,p-face))
             ,(assq-ref-all-or-lang intro-line locale)))
       (assq-ref persona
                 'short-intro)))

(define* (render-iter-vitae-interests-hobbies #:key locale persona)
  (map (lambda (interest-hobby)
         `(p (@ (class ,p-face))
             ,(assq-ref-all-or-lang interest-hobby locale)))
       (assq-ref persona
                 'interests-hobbies)))

(define* (render-iter-vitae-jobs #:key locale persona)
  (map (lambda (job)
         `(div (@ (class ,(mk-class '(p-3))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (span (@ (class "")) "⤷")
                    (div (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-3 items-center))))
                              (h5 (@ (class ,h5-face))
                                  ,(assq-ref-all-or-lang (assq-ref job
                                                                   'name)
                                                         locale))
                              (span "-")
                              (h5 (@ (class ,h5-strong-face))
                                  ,(assq-ref-all-or-lang (assq-ref job
                                                                   'position)
                                                         locale)))
                         (em (@ (class ,h5-em-face))
                             ,(assq-ref-all-or-lang (assq-ref job
                                                              'location)
                                                    locale))
                         (p (@ (class ,(mk-class '(text-lg font-light mb-4))))
                            ,(assq-ref-all-or-lang (assq-ref job
                                                             'time) locale))
                         (ul ,(map (lambda (ip)
                                     `(li (@ (class ,bullet-face)
                                             (style "list-style: circle"))
                                          ,(assq-ref-all-or-lang ip locale)))
                                   (assq-ref job
                                             'experience)))))))
       (assq-ref persona
                 'jobs)))

(define* (render-iter-vitae-education #:key locale persona)
  (map (lambda (education)
         `(div (@ (class ,(mk-class '(p-3))))
               (div (@ (class ,(mk-class '(flex flex-row gap-4))))
                    (span (@ (class "")) "⤷")
                    (div (div (@ (class ,(mk-class '(flex flex-row flex-wrap
                                                          gap-3 items-center))))
                              (h5 (@ (class ,h5-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'name)
                                                         locale))
                              (span "-")
                              (h5 (@ (class ,h5-strong-face))
                                  ,(assq-ref-all-or-lang (assq-ref education
                                                                   'position)
                                                         locale)))
                         (em (@ (class ,h5-em-face))
                             ,(assq-ref-all-or-lang (assq-ref education
                                                              'location)
                                                    locale))
                         (p (@ (class ,(mk-class '(text-lg font-light mb-4))))
                            ,(assq-ref-all-or-lang (assq-ref education
                                                             'time) locale))
                         (ul ,(map (lambda (ip)
                                     `(li (@ (class ,bullet-face)
                                             (style "list-style: circle"))
                                          ,(assq-ref-all-or-lang ip locale)))
                                   (assq-ref education
                                             'experience)))))))
       (assq-ref persona
                 'education)))

(begin
  (define* (iter-vitae-main-body #:key locale persona)
    `((div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-6
                                       justify-between))))
           (div ,(render-iter-vitae-display-name #:locale locale
                                                 #:persona persona)
                ,(render-iter-vitae-job-title #:locale locale
                                              #:persona persona))
           (div (@ (class ,(mk-class '(my-3 sm:my-1 flex flex-col
                                            justify-start))))
                ,(render-iter-vitae-email #:locale locale
                                          #:persona persona)
                ,(render-iter-vitae-phone-number #:locale locale
                                                 #:persona persona)
                ,(render-iter-vitae-address-lines #:locale locale
                                                  #:persona persona)))
      
      (h4 (@ (class ,h4-face))
          ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                     'titles)
                                           'short-intro) locale))
      ,(render-iter-vitae-short-intro #:locale locale
                                      #:persona persona)

      (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3 items-center))))
           (i (@ (class ,(mk-class '(ph ph-briefcase text-stone-600 text-xl))))
              "")
           (h4 (@ (class ,h4-face))
               ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                          'titles)
                                                'work-experience) locale)))
      ,(render-iter-vitae-jobs #:locale locale
                               #:persona persona)

      (hr (@ (class ,hr-face)))
      (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3 items-center))))
           (i (@ (class ,(mk-class '(ph ph-student text-stone-600 text-xl))))
              "")
           (h4 (@ (class ,h4-face))
               ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                          'titles)
                                                'education) locale)))
      ,(render-iter-vitae-education #:locale locale
                                    #:persona persona)

      (hr (@ (class ,hr-face)))
      (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-4 items-center))))
           (i (@ (class ,(mk-class '(ph ph-car text-stone-600 text-xl)))) "")
           (h4 (@ (class ,h4-face))
               ,(string-append (assq-ref-all-or-lang (assq-ref (assq-ref
                                                                persona
                                                                'titles)
                                                               'driver-license)
                                                     locale) ":"))
           ,(render-iter-vitae-driver-licenses #:locale locale
                                               #:persona persona))

      (hr (@ (class ,hr-face)))
      (div (@ (class ,(mk-class '(flex flex-row flex-wrap gap-3 items-center))))
           (i (@ (class ,(mk-class '(ph ph-person-simple-ski text-stone-600
                                        text-xl)))) "")
           (h4 (@ (class ,h4-face))
               ,(assq-ref-all-or-lang (assq-ref (assq-ref persona
                                                          'titles)
                                                'interests-hobbies) locale)))
      ,(render-iter-vitae-interests-hobbies #:locale locale
                                            #:persona persona)))
  (export iter-vitae-main-body))

(begin
  (define* (iter-vitae-curriculum-page #:key locale persona)
    (with-output-to-string (lambda ()
                             (sxml->xml (iter-vitae-html-template #:title
                                         "Iter Vitae"
                                         #:persona persona
                                         #:body (iter-vitae-main-body #:locale
                                                                      locale
                                                                      #:persona
                                                                      persona)
                                         #:locale locale)))))

  (export iter-vitae-curriculum-page))

