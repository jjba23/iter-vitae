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

(define iter-vitae-display-name `((all . "Josep Bigorra")))

(define iter-vitae-job-title `((all . "Software Engineer")))

(define iter-vitae-personal-contact
  `((emails . "jjbigorra@gmail.com")
    (phone-numbers . "+31 639825138")))

(define iter-vitae-personal-links
  `((blog . "jointhefreeworld.org")
    (code . "codeberg.org/jjba23")
    (linked-in . "linkedin.com/in/josepjba")))

(define iter-vitae-address-lines
  `(((all . "1441KH Purmerend"))
    ((en . "The Netherlands") (nl . "Nederland"))))

(define iter-vitae-driver-licenses
  `(((en . "B driver's license, vehicles up to 3,5t")
     (nl . "Rijbewijs B, voertuigen t/m 3,5t"))))

(define iter-vitae-interests-hobbies
  `(((en . "I like building and tweaking computers, blogging about my tech opinions and discoveries and playing strategy games sometimes.")
     (nl . "Ik bouw en speel graag met computers, ik heb een blog waar ik mijn meningen over technologie en andere uit, en soms speel ik strategie spelletjes."))
    ((en . "I love playing classical and electric guitar.")
     (nl . "Ik ben dol op klassieke en elektrische gitaar."))
    ((en . "You might also find me doing CrossFit, sanding furniture down, removing weeds from the garden, or improving my house.")
     (nl . "Ik ben ook te vinden in de CrossFit gym, meubels aan het schuren, onkruid weg aan het halen of mijn huis aan het verbeteren."))))

(define iter-vitae-languages
  `((en . ((name . ((en . "English")
                    (nl . "Engels")))
           (proficiency . ((reading . 4)
                           (speaking . 3)
                           (writing . 4)))))
    (nl . ((name . ((en . "Dutch")
                    (nl . "Nederlands")))
           (proficiency . ((reading . 3)
                           (speaking . 3)
                           (writing . 2)))))
    (call . ((name . ((en . "Catalan")
                      (nl . "Catalaans")))
             (proficiency . ((reading . 4)
                             (speaking . 4)
                             (writing . 3)))))
    (es . ((name . ((en . "Spanish")
                    (nl . "Spaans")))
           (proficiency . ((reading . 4)
                           (speaking . 4)
                           (writing . 4)))))
    (pt . ((name . ((en . "Portuguese")
                    (nl . "Portugees")))
           (proficiency . ((reading . 4)
                           (speaking . 4)
                           (writing . 4)))))
    ))

(define iter-vitae-education
  `(((name . ((all . "Leading Self")))
     (location . ((en . "Maarssen, The Netherlands") (nl . "Maarssen, Nederland")))
     (position . ((en . "Leadership course")
                  (nl . "Leiderschap cursus")))
     (time . ((en . "Summer 2024")
              (nl . "Zomer 2024")))
     (experience . (((en . "Took a course on leadership, inter-personal relations and good ways of collaborating and empathizing at the workplace. ")
                     (nl . "Nam een cursus over leiderschap, relatie met collega's en goede manieren om samen te werken en meer empathie te creeren op de werkplaats."))))
     
     )
    ((name . ((all . "Universidade do Algarve")))
     (location . ((all . "Faro, Portugal")))
     (position . ((en . "IT Associate's degree")
                  (nl . "ICT HBO")))
     (time . ((en . "September 2017 => September 2019")
              (nl . "September 2017 => September 2019")))
     (experience . (((en . "Graduated with 190/200 score. Obtained maximum score for software engineering internship.")
                     (nl . "Afgestudeerd met 190/200 score. Max cijfer gehaald voor software ingenieur stage."))
                    ((all . "Java, PHP, SQL, Javascript, GNU/Linux, Excel, Alfresco BPM"))))
     
     )))


(define iter-vitae-short-intro
  `(((en . "I am a Software Engineer and love what I do. I have a DevOps mindset and I'm always eager to learn, solve problems, perfect my skills and take on challenges.")
     (nl . "Ik ben een Software Engineer en ik hou van mijn vak. Ik heb een DevOps mindset en ik ben altijd klaar om te leren, problemen op te lossen, mijn skills verbeteren en de uitdaging aan gaan."))
    ((en . "I moved to the Netherlands in 2019, and I was born in 1996 in Barcelona, Spain.")
     (nl . "Ik ben in 2019 naar Nederland verhuisd, en ik was in 1996 geboren in Barcelona, Spanje."))
    ((en . "You could also describe me as a Free Software Advocate, an Emacs user, Guix and Nix enthusiast, Haskell, Lisp, Scala enjoyer, functional programmer, and perfectionist.")
     (nl . "Je zou mij ook kunnen omschrijven met: Free Software Advocate, GNU Emacs gebruiker, Guix en Nix enthusiast, Haskell, Lisp, Scala genieter, functioneel programmeur, en perfectionistisch."))
    ))

(define joe-job-liderlink
  `((name . ((all . "Liderlink Business Solutions")))
    (location . ((all . "Parchal, Portugal")))
    (position . ((en . "Back-end Developer internship")
                 (nl . "Back-end Ontwikkelaar stage")))
    (time . ((en . "February 2019 => July 2019")
             (nl . "Februari 2019 => Juli 2019")))
    (experience .
                (((en . "Experience with PHP and MySQL, CRUD operations, in several real-estate, hotel and personnel management software.")
                  (nl . "Ervaring met PHP en MySQL, CRUD-bewerkingen, in verschillende software voor vastgoed-, hotel- en personeelsbeheer."))
                 ((en . "Client-side scripting with JavaScript and jQuery in combination with server-side templates.")
                  (nl . "Client-side scripting met JavaScript en jQuery in combinatie met server-side templates."))
                 ((en . "Android development, Ubuntu server maintenance.")
                  (nl . "Android-ontwikkeling, Ubuntu-server onderhoud."))
                 ))))


(define joe-job-pro-warehouse
  `((name . ((all . "Pro Warehouse B.V.")))
    (location . ((en . "Amsterdam, The Netherlands")
                 (nl . "Amsterdam, Nederland")))
    (position . ((en . "Full-stack Developer, Site Reliability Engineer")
                 (nl . "Full-stack Ontwikkelaar, Site Reliability Engineer")))
    (time . ((en . "November 2019 => December 2021")
             (nl . "November 2019 => December 2021")))
    (experience . (((en . "Experience with Go (standard & Gin) and PHP (Laravel).")
                    (nl . "Ervaring met Go (standaard & Gin) en PHP (Laravel)."))
                   ((en . "Relational MySQL-based applications, with complex queries and multiple joins.")
                    (nl . "Relationele MySQL-gebaseerde applicaties, met complexe query's en meerdere joins."))
                   ((en . "Database design, normalization, migration, maintenance, and backup.")
                    (nl . "Database ontwerp, normalisatie, migratie, onderhoud en back-up."))
                   ((en . "REST API design, implementation and documentation generation. Secure-by-design practices.")
                    (nl . "REST API-ontwerp, implementatie en documentatie generatie. Secure-by-design-praktijken."))
                   ((en . "Server-side rendering front-end applications, communicating with several APIs.")
                    (nl . "Server-side rendering frontend-applicaties, communicatie met meerdere API's."))
                   ((en . "Jenkins Groovy scripted pipelines with unit tests.")
                    (nl . "Jenkins Groovy scripted pipelines met unit tests."))
                   ((en . "FreeBSD & Linux server experience, jails and pf Firewall.")
                    (nl . "FreeBSD & Linux server-ervaring, jails en pf Firewall."))
                   ((en . "Introduced Agile working methodology and Extreme Programming.")
                    (nl . "Agile-werk-methodologie en Extreme Programming geïntroduceerd."))
                   ))))

(define joe-job-ikea
  `((name . ((all . "IKEA - Ingka Digital")))
    (location . ((en . "Amsterdam, The Netherlands")
                 (nl . "Amsterdam, Nederland")))
    (position . ((en . "Software Engineer")
                 (nl . "Software Engineer")))
    (time . ((en . "January 2022 => March 2023")
             (nl . "Januari 2022 => Maart 2023")))
    (experience .
                (((en . "Experience in Go, REST APIs, event-driven micro-services.")
                  (nl . "Ervaring in Go, REST API's, event-driven micro-services."))
                 ((en . "Experience in Java, Spring Boot and Gradle, Maven.")
                  (nl . "Ervaring in Java, Spring Boot en Gradle, Maven."))
                 ((en . "Apache Beam, Dataflow, data-pipelines.")
                  (nl . "Apache Beam, Dataflow, data-pipelines."))
                 ((en . "Google Cloud Platform, Pub/Sub, Serverless computing.")
                  (nl . "Google Cloud Platform, Pub/Sub, Serverless computing."))
                 ((en . "Kubernetes and Docker, Terraform, Infrastructure-as-Code.")
                  (nl . "Kubernetes en Docker, Terraform, Infrastructure-as-Code."))
                 ((en . "Testing: Integration, Unit, Mock, E2E, Property-based, Testcontainers.")
                  (nl . "Testen: Integratie, Unit, Mock, E2E, Property-based, Testcontainers"))
                 ((en . "PostgreSQL, BigTable, ElasticSearch, Redis, Firebase.")
                  (nl . "PostgreSQL, BigTable, ElasticSearch, Redis, Firebase"))
                 ))))


(define joe-job-zorgdomein
  `((name . ((all . "ZorgDomein B.V.")))
    (location . ((en . "Breukelen, The Netherlands") (nl . "Breukelen, Nederland")))
    (position . ((en . "Software Engineer")
                 (nl . "Software Engineer")))
    (time . ((en . "April 2023 => July 2024")
             (nl . "April 2023 => Juli 2024")))
    (experience .
                (((en . "Experience in Scala, REST APIs, distributed microservices, using functional programming.")
                  (nl . "Ervaring met Scala, REST API's, distributed microservices, functioneel programmeren."))
                 ((en . "Working with Kafka, PostgreSQL, Elasticsearch.")
                  (nl . "Werken met Kafka, PostgreSQL, Elasticsearch."))
                 ((en . "Integration testing, black-box testing, testcontainers, unit, E2E testing, security assessment.")
                  (nl . "Integratie-testen, black-box-testen, testcontainers, unit, E2E-testen, beveiligingsbeoordeling."))
                 ((en . "Python data pipelines with Spark and AWS Glue for a product tagging system.")
                  (nl . "Python-datapijplijnen met Spark en AWS Glue voor een producttagsysteem."))
                 ((en . "Amazon AWS, EC2, Cloudfront, S3 buckets.")
                  (nl . "Amazon AWS, EC2, Cloudfront, S3-buckets"))
                 ((en . "Introducing Nix development shells and flakes along with teaching and mentoring in reproducible builds.")
                  (nl . "Introductie van Nix-ontwikkelingshells en -flakes, samen met lesgeven en mentoring in reproduceerbare builds"))                 
                 ))))

(define joe-job-vandebron
  `((name . ((all . "Vandebron B.V.")))
    (location . ((en . "Amsterdam, The Netherlands") (nl . "Amsterdam, Nederland")))
    (position . ((en . "Software Engineer")
                 (nl . "Software Engineer")))
    (time . ((en . "August 2024 => present")
             (nl . "Augustus 2024 => heden")))
    (experience .
                (((en . "Back-end, asynchronous and event-driven services with Scala, REST APIs")
                  (nl . "Back-end, asynchroon en event-driven services met Scala, REST API's"))
                 ((en . "Distributed micro-services, Kafka, PostgreSQL, Elasticsearch")
                  (nl . "Distributed micro-services, Kafka, PostgreSQL, Elasticsearch"))
                 ((en . "Functional programming, domain modeling")
                  (nl . "Functioneel programmeren, domein-modellering"))
                 ((en . "Kubernetes and Docker, ArgoCD, Helm charts")
                  (nl . "Kubernetes en Docker, ArgoCD, Helm-grafieken"))
                 ))))

(define iter-vitae-jobs
  (list
   joe-job-vandebron
   joe-job-zorgdomein
   joe-job-ikea
   joe-job-pro-warehouse
   joe-job-liderlink))

(define iter-vitae-font 'monaspace-neon)

(define iter-vitae-palette 'ef-cyprus)
