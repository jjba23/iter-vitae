;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (iter-vitae defaults)
  #:declarative? #t
  #:export (display-name job-title job-title-link
                         profile-picture
                         personal-contact
                         personal-links
                         address-lines
                         driver-licenses
                         interests-hobbies
                         languages
                         education
                         titles
                         skills
                         short-intro
                         jobs
                         document-theme))

;; Full name of persona
;;
;; example:
;;
;; `((all . "Josep Bigorra"))
;;
(define display-name
  `())

;; Optional profile picture.  Use a path relative to this persona file, an
;; absolute path, an http(s) URL or a data:image URI.  Local PNG, JPEG, WebP,
;; GIF, AVIF and SVG images are embedded as data URIs, so the generated CV
;; stays self-contained.  The `ats' theme deliberately omits pictures because
;; resume parsers cannot use them.
;;
;; example:
;;
;; (define profile-picture "../assets/portrait.jpg")
;;
(define profile-picture
  #f)

;; Primary job title of persona
;;
;; example:
;;
;; `((en . "Software Engineer") (nl . "..."))
;;
(define job-title
  `())

;; Optional link that turns the job title into an anchor.
;;
;; example:
;;
;; `((all . "https://en.wikipedia.org/wiki/Software_engineering"))
;;
(define job-title-link
  `())

;; Contact details of persona
;;
;; example:
;;
;; `((emails . ("someone@example.com"))
;;   (phone-numbers . ("+351 123 456 789")))
;;
(define personal-contact
  `())

;; Personal links of persona
;;
;; example:
;;
;; `((blog . "jointhefreeworld.org")
;;   (code . "codeberg.org/jjba23")
;;   (linked-in . "linkedin.com/in/josepjba"))
;;
(define personal-links
  `())

;; Address lines of persona
;;
;; note: it's not recommended to be too explicit about your
;; address and other details in your curriculum vitae, only include it if
;; you are aware of the risks this entails
;;
;; example:
;;
;; `(((all . "1441KH Purmerend"))
;;   ((all . "Netherlands")))
;;
(define address-lines
  `())

;; Driver license details of persona
;;
;; example:
;;
;; `(((all . "B driver's license, vehicles up to 3,5t")))
;;
(define driver-licenses
  `())

;; Interests and hobbies of persona
;;
;; example:
;;
;; `(((en . "I love playing classical and electric guitar.")
;;    (nl . "...")))
;;
(define interests-hobbies
  `())

;; Language skills of persona.  Each proficiency is measured from 1 to 5,
;; following the scale used by LinkedIn and most CV guides:
;;
;;   1 Elementary           2 Limited working      3 Professional working
;;   4 Full professional    5 Native or bilingual
;;
;; Scores may differ per skill; the visual themes show them as a compact
;; reading / speaking / writing table, while the ATS and text output spell
;; every level out in words.
;;
;; example:
;;
;; `((en . ((name . ((en . "English")
;;                   (nl . "Engels")))
;;          (proficiency . ((reading . 5)
;;                          (speaking . 5)
;;                          (writing . 5)))))
;;   (nl . ((name . ((en . "Dutch")
;;                   (nl . "Nederlands")))
;;          (proficiency . ((reading . 4)
;;                          (speaking . 4)
;;                          (writing . 3))))))
;;
(define languages
  `())

;; Language proficiency labels, keyed by document locale.  The default covers
;; English, Dutch and Spanish; define this field only to use another scale or
;; wording.  Keep the values short: the visual themes show them inside a table.
(define language-proficiency
  '((en (1 . "Elementary")
        (2 . "Limited working")
        (3 . "Professional")
        (4 . "Full professional")
        (5 . "Native / bilingual"))
    (nl (1 . "Elementair")
        (2 . "Beperkt werkzaam")
        (3 . "Professioneel")
        (4 . "Volledig professioneel")
        (5 . "Moedertaal / tweetalig"))
    (es (1 . "Elemental")
        (2 . "Laboral limitado")
        (3 . "Profesional")
        (4 . "Profesional pleno")
        (5 . "Nativo / bilingüe"))))

;; Education and certifications of persona
;;
;; example:
;;
;; `(((name . ((all . "Universidade do Algarve")))
;;    (location . ((all . "Faro, Portugal")))
;;    (position . ((en . "IT Associate's degree")
;;                 (nl . "...")))
;;    (time . ((en . "September 2017 => September 2019")
;;             (nl . "...")))
;;    (experience . (((en . "Graduated with 190/200 score. Obtained maximum score for software engineering internship.")
;;                    (nl . "..."))
;;                   ((all . "Java, PHP, SQL, Javascript, GNU/Linux, Excel, Alfresco BPM"))))

;;    )))
;;
(define education
  `())

;; Document titles of the curriculum vitae
;;
(define titles
  `((education (en . "Education")
               (nl . "Opleiding")
               (es . "Educación"))
    (driver-license (en . "Driving licence")
                    (nl . "Rijbewijs")
                    (es . "Permiso de conducir"))
    (interests-hobbies (en . "Interests & Hobbies")
                       (nl . "Interesses en hobby's")
                       (es . "Intereses y aficiones"))
    (language (en . "Languages")
              (nl . "Talen")
              (es . "Idiomas"))
    (language-name (en . "Language")
                   (nl . "Taal")
                   (es . "Idioma"))
    (my-links (en . "Me on the Internet")
              (nl . "Mijn links")
              (es . "Enlaces"))
    (speaking (en . "Speaking")
              (nl . "Spreken")
              (es . "Expresión oral"))
    (reading (en . "Reading")
             (nl . "Lezen")
             (es . "Lectura"))
    (writing (en . "Writing")
             (nl . "Schrijven")
             (es . "Expresión escrita"))
    (short-intro (en . "Who am I?")
                 (nl . "Wie ben ik?")
                 (es . "¿Quién soy?"))
    (professional-summary (en . "Professional Summary")
                          (nl . "Professioneel profiel")
                          (es . "Resumen profesional"))
    (skills (en . "Skills")
            (nl . "Vaardigheden")
            (es . "Habilidades"))
    (additional-information (en . "Additional Information")
                            (nl . "Aanvullende informatie")
                            (es . "Información adicional"))
    (work-experience (en . "Work Experience")
                     (nl . "Werkervaring")
                     (es . "Experiencia profesional"))))

;; Skills that should be easy for an ATS to find.  The `ats' theme renders
;; these as one comma-separated line, so spell out the terms a recruiter or a
;; job posting is likely to use.
;;
;; example:
;;
;; `(((all . "Scala"))
;;   ((all . "Kubernetes"))
;;   ((all . "PostgreSQL")))
;;
(define skills
  `())

;; Short introduction about persona
;;
;; example:
;;
;; `(((en . "I am a Software Engineer and love what I do. I have a DevOps mindset and I'm always eager to learn, solve problems, perfect my skills and take on challenges.")
;;    (nl . "...")))
;;
(define short-intro
  `())

;; Jobs and internships of persona
;;
;; `(((name . ((all . "Some Company B.V.")))
;;    (location . ((en . "New York City, United States") (nl . "...")))
;;    (position . ((en . "Software Engineer")
;;                 (nl . "...")))
;;    (time . ((en . "August 2023 => present")
;;             (nl . "...")))
;;    (experience .
;;                (((en . "Back-end, asynchronous and event-driven services with Scala, REST APIs")
;;                  (nl . "..."))
;;                 ((en . "Distributed micro-services, Kafka, PostgreSQL, Elasticsearch")
;;                  (nl . "..."))
;;                 ))))
;;
(define jobs
  `())

;; document-theme is a symbol that represents the Curriculum Vitae type/theme you want to use.
;; supported values are:
;; - ef-cyprus: a light colored and green accent theme
;; - fundamental: a no-frills vanilla HTML, simple, effective
;; - fatum: a hacker inspired visual for engineers, computer scientists and techies
;; - ats: a single-column, plain-text-first theme for US applicant tracking systems
(define document-theme
  'ef-cyprus)
