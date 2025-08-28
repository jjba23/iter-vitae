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
  #:export (display-name job-title
                         personal-contact
                         personal-links
                         address-lines
                         driver-licenses
                         interests-hobbies
                         languages
                         education
                         titles
                         short-intro
                         jobs
                         palette))

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
;; `((blogs . ("jointhefreeworld.org"))
;;   (code . ("codeberg.org/jjba23"))
;;   (linkedin . ("linkedin.com/in/josepjba")))
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
               (nl . "Opleiding"))
    (driver-license (en . "Driving")
                    (nl . "Rijbewijs"))
    (interests-hobbies (en . "My free time")
                       (nl . "Mijn vrije tijd"))
    (language (en . "Languages")
              (nl . "Taalvaardigheid"))
    (my-links (en . "Me on the Internet")
              (nl . "Ik op Internet"))
    (speaking (en . "Speaking")
              (nl . "Spreken"))
    (reading (en . "Reading")
             (nl . "Lezen"))
    (writing (en . "Writing")
             (nl . "Schrijven"))
    (short-intro (en . "Who am I ?")
                 (nl . "Wie ben ik ?"))
    (work-experience (en . "Work experience")
                     (nl . "Werkervaring"))))

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

;; Palette to be used for the curriculum vitae
;; choose between:
;;
;; ef-cyprus
;;
(define palette
  'ef-cyprus)
