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

(define-module (iter-vitae persona)
  #:declarative? #t)

(define display-name
  `((all . "Josep Bigorra")))

(define job-title-link
  `((all . "https://en.wikipedia.org/wiki/Software_engineering")))

(define job-title
  `((en . "Software Engineer ⚙️") (nl . "Software Engineer ⚙️")
    (es . "Ingeniero de Software ⚙️")))

(define personal-contact
  `((emails . "jjbigorra@gmail.com") (phone-numbers . "+31 639825138")))

(define personal-links
  `((blog . "jointhefreeworld.org") (code . "codeberg.org/jjba23")
    (linked-in . "linkedin.com/in/josepjba")))

(define address-lines
  `(((all . "1441KH Purmerend"))
    ((en . "The Netherlands") (nl . "Nederland")
     (es . "Países Bajos"))))

(define driver-licenses
  `(((en . "B driver's license, vehicles up to 3,5t")
     (nl . "Rijbewijs B, voertuigen t/m 3,5t")
     (es . "Permiso de conducir B, vehículos hasta 3,5t"))))

(define interests-hobbies
  `(((en . "I like building and tweaking computers, blogging about my tech opinions and discoveries and playing strategy games sometimes.")
     (nl . "Ik bouw en speel graag met computers, ik heb een blog waar ik mijn meningen over technologie en andere uit, en soms speel ik strategie spelletjes.")
     (es . "Me gusta montar y configurar ordenadores, escribir en mi blog sobre mis opiniones y descubrimientos tecnológicos y, a veces, jugar a juegos de estrategia."))
    ((en . "I love playing classical and electric guitar 🎸.")
     (nl . "Ik ben dol op klassieke en elektrische gitaar 🎸.")
     (es . "Me encanta tocar la guitarra clásica y eléctrica 🎸."))
    ((en . "You might also find me doing CrossFit, sanding furniture down, removing weeds from the garden, or improving my house.")
     (nl . "Ik ben ook te vinden in de CrossFit gym, meubels aan het schuren, onkruid weg aan het halen of mijn huis aan het verbeteren.")
     (es . "También me puedes encontrar haciendo CrossFit, lijando muebles, quitando malas hierbas del jardín o mejorando mi casa."))))

(define language-proficiency
  `((en (1 . "Elementary Proficiency")
        (2 . "Limited Working Proficiency")
        (3 . "Professional Proficiency")
        (4 . "Native / Bilingual"))
    (nl (1 . "Elementaire Vaardigheid")
        (2 . "Beperkte Werkvaardigheid")
        (3 . "Professioneel Vaardig")
        (4 . "Moedertaal / Tweetalig"))
    (es (1 . "Competencia Elemental")
        (2 . "Competencia Profesional Limitada")
        (3 . "Competencia Profesional")
        (4 . "Nativo / Bilingüe"))))

(define languages
  `((en (name (en . "🇬🇧 English")
              (nl . "🇬🇧 Engels")
              (es . "🇬🇧 Inglés"))
        (proficiency (reading . 4)
                     (speaking . 4)
                     (writing . 4)))
    (nl (name (en . "🇳🇱 Dutch")
              (nl . "🇳🇱 Nederlands")
              (es . "🇳🇱 Neerlandés"))
        (proficiency (reading . 3)
                     (speaking . 3)
                     (writing . 2)))
    (cat (name (en . "🇪🇸 Catalan")
               (nl . "🇪🇸 Catalaans")
               (es . "🇪🇸 Catalán"))
         (proficiency (reading . 4)
                      (speaking . 4)
                      (writing . 3)))
    (es (name (en . "🇪🇸 Spanish")
              (nl . "🇪🇸 Spaans")
              (es . "🇪🇸 Español"))
        (proficiency (reading . 4)
                     (speaking . 4)
                     (writing . 4)))
    (pt (name (en . "🇵🇹 Portuguese")
              (nl . "🇵🇹 Portugees")
              (es . "🇵🇹 Portugués"))
        (proficiency (reading . 4)
                     (speaking . 4)
                     (writing . 4)))))

(define joe-internship-liderlink
  `((name (all . "Liderlink Business Solutions"))
    (location (all . "Parchal, Portugal"))
    (position (en . "Back-end Developer internship")
              (nl . "Back-end Ontwikkelaar stage")
              (es . "Prácticas de Desarrollador Back-end"))
    (time (en . "February 2019 => July 2019")
          (nl . "Februari 2019 => Juli 2019")
          (es . "Febrero 2019 => Julio 2019"))
    (experience ((en . "Experience with PHP and MySQL, CRUD operations, in several real-estate, hotel and personnel management software.")
                 (nl . "Ervaring met PHP en MySQL, CRUD-bewerkingen, in verschillende software voor vastgoed-, hotel- en personeelsbeheer.")
                 (es . "Experiencia con PHP y MySQL, operaciones CRUD, en diversos softwares de gestión inmobiliaria, hotelera y de personal."))
                ((en . "Client-side scripting with JavaScript and jQuery in combination with server-side templates.")
                 (nl . "Client-side scripting met JavaScript en jQuery in combinatie met server-side templates.")
                 (es . "Client-side scripting con JavaScript y jQuery en combinación con templates server-side.")))))

(define education
  `(((name (all . "Leading Self"))
     (location (en . "Maarssen, The Netherlands")
               (nl . "Maarssen, Nederland")
               (es . "Maarssen, Países Bajos"))
     (position (en . "Leadership course")
               (nl . "Leiderschap cursus")
               (es . "Curso de liderazgo"))
     (time (en . "Summer 2024")
           (nl . "Zomer 2024")
           (es . "Verano 2024"))
     (experience ((en . "Took a course on leadership, inter-personal relations and good ways of collaborating and empathizing at the workplace. ")
                  (nl . "Nam een cursus over leiderschap, relatie met collega's en goede manieren om samen te werken en meer empathie te creeren op de werkplaats.")
                  (es . "Realicé un curso sobre liderazgo, relaciones interpersonales y formas efectivas de colaborar y empatizar en el entorno laboral."))))
    ,joe-internship-liderlink
    ((name (all . "Universidade do Algarve"))
     (location (all . "Faro, Portugal"))
     (position (en . "IT Associate's degree")
               (nl . "ICT HBO")
               (es . "Grado Superior en Informática (Associate's degree)"))
     (time (en . "September 2017 => September 2019")
           (nl . "September 2017 => September 2019")
           (es . "Septiembre 2017 => Septiembre 2019"))
     (experience ((en . "Graduated with 190/200 score. Obtained maximum score for software engineering internship.")
                  (nl . "Afgestudeerd met 190/200 score. Max cijfer gehaald voor software ingenieur stage.")
                  (es . "Graduado con una puntuación de 190/200. Máxima nota obtenida en las prácticas de ingeniería de software."))
                 ((all . "Java, PHP, SQL, Javascript, GNU/Linux, Excel, Alfresco BPM")))

     )))

(define short-intro
  `(((en . "I am a Software Engineer and love what I do. I'm always ready to learn new things and solve problems, I have a DevOps mindset and I love perfecting my skills and taking on challenges.")
     (nl . "Ik ben een Software Engineer en ik hou van mijn vak. Ik ben altijd bereid om nieuwe dingen te leren en problemen oplossen, ik heb een DevOps mindset en ik verbeter mijn skills graag, en ben niet bang de uitdaging aan te gaan.")
     (es . "Soy ingeniero de software y me apasiona mi trabajo. Siempre estoy dispuesto a aprender cosas nuevas y resolver problemas; tengo una mentalidad DevOps y me encanta perfeccionar mis habilidades y aceptar nuevos retos."))
    ((en . "I live in the Netherlands since 2019, I was born in 1996 in Barcelona, Spain.")
     (nl . "Ik woon in Nederland sinds 2019, ik was in 1996 geboren in Barcelona, Spanje.")
     (es . "Vivo en los Países Bajos desde 2019, nací en 1996 en Barcelona, España."))
    ((en . "I like working with programming languages like  (λ) Scheme, Lisp, Haskell, Rust, Scala, Bash and many more. I enjoy functional programming and lambdas. Yes I am an Emacs user. Yes I have remapped my Caps to Control. I stand for Free Software, Free Society.")
     (nl . "Ik werk graag met programmeertalen zoals  (λ) Scheme, Lisp, Haskell, Rust, Scala, Bash en veel anderen. Ik hou van functioneel programmeren en lambda's. Ja, ik ben een Emacs-gebruiker. Ja, ik heb mijn Caps-toets omgebouwd naar Control. Ik sta voor Vrije Software voor een Vrije Samenleving.")
     (es . "Me gusta trabajar con lenguajes de programación como (λ) Scheme, Lisp, Haskell, Rust, Scala, Bash y muchos más. Disfruto de la programación funcional y las lambdas. Sí, soy usuario de Emacs. Sí, he remapeado mi tecla Bloq Mayús a Control. Defiendo el Software Libre y una Sociedad Libre."))))

(define joe-job-pro-warehouse
  `((name (all . "Pro Warehouse B.V."))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Full-stack Developer")
              (nl . "Full-stack Ontwikkelaar")
              (es . "Programador Full-stack"))
    (time (en . "November 2019 => December 2021")
          (nl . "November 2019 => December 2021")
          (es . "Noviembre 2019 => Diciembre 2021"))
    (experience ((en . "Experience with Go (standard & Gin), Vue.js and PHP (Laravel).")
                 (nl . "Ervaring met Go (standaard & Gin), Vue.js en PHP (Laravel).")
                 (es . "Experiencia con Go (standard & Gin), Vue.js y PHP (Laravel)."))
                ((en . "Database design, normalization, migration, maintenance, and backup.")
                 (nl . "Database ontwerp, normalisatie, migratie, onderhoud en back-up.")
                 (es . "Diseño, normalización, migración, mantenimiento y respaldo de bases de datos."))
                ((en . "Jenkins Groovy scripted pipelines with unit tests.")
                 (nl . "Jenkins Groovy scripted pipelines met unit tests.")
                 (es . "Pipelines de Jenkins con scripts en Groovy y pruebas unitarias."))
                ((en . "FreeBSD & Linux server experience, jails and pf Firewall.")
                 (nl . "FreeBSD & Linux server-ervaring, jails en pf Firewall.")
                 (es . "Experiencia en servidores FreeBSD y Linux, jails y pf Firewall."))
                ((en . "Introduced Agile working methodology and Extreme Programming.")
                 (nl . "Agile-werk-methodologie en Extreme Programming geïntroduceerd.")
                 (es . "Introducción de metodologías de trabajo Ágil y Extreme Programming.")))))
(define joe-job-ikea
  `((name (all . "IKEA, Ingka Digital"))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Software Engineer")
              (nl . "Software Engineer")
              (es . "Ingeniero de Software"))
    (time (en . "January 2022 => March 2023")
          (nl . "Januari 2022 => Maart 2023")
          (es . "Enero 2022 => Marzo 2023"))
    (experience ((en . "Experience in Go, Java, Spring Boot and Gradle, Maven.")
                 (nl . "Ervaring in Go, Java, Spring Boot en Gradle, Maven.")
                 (es . "Experiencia en Go, Java, Spring Boot y Gradle, Maven."))
                ((en . "Google Cloud Platform, Pub/Sub, Serverless computing.")
                 (nl . "Google Cloud Platform, Pub/Sub, Serverless computing.")
                 (es . "Google Cloud Platform, Pub/Sub, computación Serverless."))
                ((en . "Kubernetes and Docker, Terraform, Infrastructure-as-Code.")
                 (nl . "Kubernetes en Docker, Terraform, Infrastructure-as-Code.")
                 (es . "Kubernetes y Docker, Terraform, Infrastructure-as-Code."))
                ((en . "PostgreSQL, BigTable, ElasticSearch, Redis, Firebase.")
                 (nl . "PostgreSQL, BigTable, ElasticSearch, Redis, Firebase")
                 (es . "PostgreSQL, BigTable, ElasticSearch, Redis, Firebase.")))))

(define joe-job-zorgdomein
  `((name (all . "ZorgDomein B.V."))
    (location (en . "Breukelen, The Netherlands")
              (nl . "Breukelen, Nederland")
              (es . "Breukelen, Países Bajos"))
    (position (en . "Software Engineer")
              (nl . "Software Engineer")
              (es . "Ingeniero de Software"))
    (time (en . "April 2023 => July 2024")
          (nl . "April 2023 => Juli 2024")
          (es . "Abril 2023 => Julio 2024"))
    (experience ((en . "Experience in Scala, REST APIs, distributed microservices, using functional programming.")
                 (nl . "Ervaring met Scala, REST API's, distributed microservices, functioneel programmeren.")
                 (es . "Experiencia en Scala, APIs REST, microservicios distribuidos y programación funcional."))
                ((en . "Working with Kafka, PostgreSQL, Elasticsearch.")
                 (nl . "Werken met Kafka, PostgreSQL, Elasticsearch.")
                 (es . "Trabajo con Kafka, PostgreSQL, Elasticsearch."))
                ((en . "Integration testing, black-box testing, testcontainers, unit, E2E testing, security assessment.")
                 (nl . "Integratie-testen, black-box-testen, testcontainers, unit, E2E-testen, beveiligingsbeoordeling.")
                 (es . "Pruebas de integración, pruebas de blackbox, testcontainers, unit test, pruebas E2E y evaluación de seguridad."))
                ((en . "Python data pipelines with Spark and AWS Glue for a product tagging system.")
                 (nl . "Python-datapijplijnen met Spark en AWS Glue voor een producttagsysteem.")
                 (es . "Pipelines de datos en Python con Spark y AWS Glue para un sistema de etiquetado de productos."))
                ((en . "Amazon AWS, EC2, Cloudfront, S3 buckets.")
                 (nl . "Amazon AWS, EC2, Cloudfront, S3-buckets")
                 (es . "Amazon AWS, EC2, Cloudfront, buckets S3.")))))

(define joe-job-vandebron
  `((name (all . "Vandebron B.V."))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Software Engineer")
              (nl . "Software Engineer")
              (es . "Ingeniero de Software"))
    (time (en . "August 2024 => present")
          (nl . "Augustus 2024 => heden")
          (es . "Agosto 2024 => presente"))
    (experience ((en . "Back-end, asynchronous and event-driven services, system architecture and engineering")
                 (nl . "Back-end, asynchroon en event-driven services, system architecture and engineering ")
                 (es . "Servicios back-end asíncronos y orientados a eventos, system architecture and engineering."))
                ((all . "Kotlin, GraphQL, Scala, ZIO, REST API's, Java, Spring"))
                ((en . "Distributed micro-services, Kafka, PostgreSQL, Elasticsearch")
                 (nl . "Distributed micro-services, Kafka, PostgreSQL, Elasticsearch")
                 (es . "Microservicios distribuidos, Kafka, PostgreSQL, Elasticsearch."))
                ((en . "Kubernetes and Docker, ArgoCD, Helm charts")
                 (nl . "Kubernetes en Docker, ArgoCD, Helm-grafieken")
                 (es . "Kubernetes y Docker, ArgoCD, Helm charts.")))))

(define jobs
  (list joe-job-vandebron joe-job-zorgdomein joe-job-ikea
        joe-job-pro-warehouse))

(define document-theme
  'fatum)
