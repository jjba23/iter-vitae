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

(define-module (iter-vitae defaults)
  #:declarative? #t
  #:export (display-name job-title job-title-link
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

;; Language skills of persona
;;
;; proficiency is measure from 0 to 4,
;; 0 being basic, 4 being native
;;
;; example:
;;
;; `((en . ((name . ((en . "English")
;;                   (nl . "Engels")))
;;          (proficiency . ((reading . 4)
;;                          (speaking . 3)
;;                          (writing . 4)))))
;;   (nl . ((name . ((en . "Dutch")
;;                   (nl . "Nederlands")))
;;          (proficiency . ((reading . 3)
;;                          (speaking . 3)
;;                          (writing . 2))))))
;;
(define languages
  `())

;; Language proficiency levels
;;
;; `((en (1 . "Elementary Proficiency")
;;       (2 . "Limited Working Proficiency")
;;       (3 . "Professional Proficiency")
;;       (4 . "Native / Bilingual"))
;;   (nl (1 . "Elementaire Vaardigheid")
;;       (2 . "Beperkte Werkvaardigheid")
;;       (3 . "Professioneel Vaardig")
;;       (4 . "Moedertaal / Tweetalig")))
(define language-proficiency
  `())

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
    (driver-license (en . "Driving")
                    (nl . "Rijbewijs")
                    (es . "Conducción"))
    (interests-hobbies (en . "Interests & Hobbies")
                       (nl . "Interesses & Hobbies")
                       (es . "Intereses & Hobbies"))
    (language (en . "Languages")
              (nl . "Taalvaardigheid")
              (es . "Idiomas"))
    (my-links (en . "Me on the Internet")
              (nl . "Ik op Internet")
              (es . "Yo en Internet"))
    (speaking (en . "Speaking")
              (nl . "Spreken")
              (es . "Hablar"))
    (reading (en . "Reading")
             (nl . "Lezen")
             (es . "Leer"))
    (writing (en . "Writing")
             (nl . "Schrijven")
             (es . "Escribir"))
    (short-intro (en . "Who am I ?")
                 (nl . "Wie ben ik ?")
                 (es . "¿Quién soy yo?"))
    (professional-summary (en . "Professional Summary")
                          (nl . "Professioneel Profiel")
                          (es . "Resumen Profesional"))
    (skills (en . "Skills")
            (nl . "Vaardigheden")
            (es . "Habilidades"))
    (additional-information (en . "Additional Information")
                            (nl . "Aanvullende Informatie")
                            (es . "Información Adicional"))
    (work-experience (en . "Work Experience")
                     (nl . "Werkervaring")
                     (es . "Experiencia Laboral"))))

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
