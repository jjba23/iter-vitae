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
  `(((en . "Passionate and driven Senior Software Engineer with Full-Stack experience and DevOps mindset. From gathering requirements to fine-tuning production optimization, I love turning complex architectural challenges into clean, maintainable, and high-impact code.")
     (nl . "Gedreven Senior Software Engineer, met Full-Stack ervaring en DevOps-mentaliteit. Van het verzamelen van requirements tot het optimaliseren van de productieomgeving, ik vind het geweldig om complexe architectuuruitdagingen om te zetten in schone, onderhoudbare en impactvolle code.")
     (es . "Ingeniero de Software Sénior apasionado y proactivo, con experiencia en desarrollo full-stack y mentalidad DevOps. Desde la recopilación de requisitos hasta los ajustes precisos de la optimización de producción, me encanta transformar desafíos arquitectónicos complejos en código limpio, mantenible y de alto impacto."))
    ((en . "I work with programming languages like Java, Kotlin, Scala, Haskell, JavaScript, TypeScript, Python, Rust, Bash, SQL, Scheme, Lisp.")
     (nl . "Ik werk graag met programmeertalen zoals Java, Kotlin, Scala, Haskell, JavaScript, TypeScript, Python, Rust, Bash, SQL, Scheme, Lisp.")
     (es . "Me gusta trabajar con lenguajes de programación como Java, Kotlin, Scala, Haskell, JavaScript, TypeScript, Python, Rust, Bash, SQL, Scheme, Lisp."))))

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
    (experience ((en . "Optimized business processes and web-shop data sync from 1 week to 4 minutes.")
                 (nl . "Geoptimaliseerde bedrijfsprocessen en synchronisatie van webshopgegevens van 1 week naar 4 minuten.")
                 (es . "Optimización de los procesos comerciales y sincronización de datos de la tienda online: de 1 semana a 4 minutos."))
                ((en . "Experience with Go (standard & Gin), Vue.js and PHP (Laravel).")
                 (nl . "Ervaring met Go (standaard & Gin), Vue.js en PHP (Laravel).")
                 (es . "Experiencia con Go (standard & Gin), Vue.js y PHP (Laravel)."))
                ((en . "Introduced Agile working methodology and Extreme Programming.")
                 (nl . "Agile-werk-methodologie en Extreme Programming geïntroduceerd.")
                 (es . "Introducción de metodologías de trabajo Agile y Extreme Programming."))
                ((en . "Database design, normalization, migration, maintenance, and backup.")
                 (nl . "Database ontwerp, normalisatie, migratie, onderhoud en back-up.")
                 (es . "Diseño, normalización, migración, mantenimiento y respaldo de bases de datos."))
                ((en . "Jenkins CI/CD pipelines, FreeBSD & Linux server experience.")
                 (nl . "Jenkins CI/CD pipelines, FreeBSD & Linux server-ervaring.")
                 (es . "Pipelines de CI/CD Jenkins, experiencia en servidores FreeBSD y Linux.")))))

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
    (experience ((en . "Led a migration from proprietary systems into the modern Google Cloud Platform for the postcode product availability system, reducing spending.")
                 (nl . "Leiderschap over de migratie van eigen systemen naar het moderne Google Cloud Platform voor het postcodesysteem voor productbeschikbaarheid, met kosten reductie.")
                 (es . "Lideré la migración del sistema de disponibilidad de productos por código postal desde sistemas propietarios a la moderna plataforma Google Cloud, reduciendo costes."))
                ((en . "Experience in Go, Java, Spring and cloud-native (Kubernetes, Docker, Terraform, Pub/Sub)")
                 (nl . "Ervaring in Go, Java, Spring en cloud-native (Kubernetes, Docker, Terraform, Pub/Sub).")
                 (es . "Experiencia en Go, Java, Spring y cloud-native (Kubernetes, Docker, Terraform, Pub/Sub)."))
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
    (experience ((en . "Introduced Event Storming methodologies to align cross-functional teams on event-driven design, accelerating feature delivery and reducing architectural debt.")
                 (nl . "Event Storming-methodologieën geïntroduceerd om multidisciplinaire teams op één lijn te brengen wat betreft event-driven design, waardoor de levering van functionaliteiten wordt versneld en de tech-debt wordt verminderd.")
                 (es . "Se introdujeron metodologías de Event Storming para alinear a los equipos multifuncionales en el diseño basado en eventos, acelerando la entrega de funcionalidades y reduciendo la tech-debt."))
                ((en . "Redesigned the platform's master search bar backend, driving a >50% increase in medical specialist satisfaction and significantly optimizing clinical discovery workflows.")
                 (nl . "Het backend-gedeelte van de hoofdzoekbalk van het platform is opnieuw ontworpen, wat heeft geleid tot een tevredenheidsstijging van meer dan 50% onder medische specialisten en een aanzienlijke optimalisatie van de workflows voor het vinden van klinische informatie.")
                 (es . "Se rediseñó el sistema de gestión de la barra de búsqueda principal de la plataforma, lo que generó un aumento de más del 50 % en la satisfacción de los especialistas médicos y optimizó significativamente los flujos de trabajo de descubrimiento clínico."))
                ((en . "Experience in Scala, REST APIs, distributed microservices, using functional programming.")
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
    (position (en . "Senior Software Engineer")
              (nl . "Senior Software Engineer")
              (es . "Ingeniero de Software Sénior"))
    (time (en . "August 2024 => present")
          (nl . "Augustus 2024 => heden")
          (es . "Agosto 2024 => presente"))
    (experience ((en . "Architected and delivered a high-performance, real-time energy calculation service ('greenest moment of the day') meeting strict sub-50ms latency SLAs to optimize green energy consumption for thousands of active users.")
                 (nl . "Ik heb een hoogwaardige, realtime energieberekeningsservice ('het groenste moment van de dag') ontworpen en geïmplementeerd die voldoet aan strikte SLA's met een latentie van minder dan 50 ms om het groene energieverbruik voor duizenden actieve gebruikers te optimaliseren.")
                 (es . "Diseñé e implementé un servicio de cálculo de energía de alto rendimiento y en tiempo real ('el momento más ecológico del día') que cumple con estrictos acuerdos de nivel de servicio (SLA) de latencia inferior a 50 ms para optimizar el consumo de energía verde para miles de usuarios activos."))
                ((en . "Designed asynchronous, event-driven microservices using Scala (ZIO), Kotlin, GraphQL, and Kafka to handle high-frequency data streams.")
                 (nl . "Ik heb asynchrone, gebeurtenisgestuurde microservices ontworpen met behulp van Scala (ZIO), Kotlin, GraphQL en Kafka om datastromen met een hoge frequentie te verwerken.")
                 (es . "Diseñé microservicios asíncronos y basados \u200b\u200ben eventos utilizando Scala (ZIO), Kotlin, GraphQL y Kafka para gestionar flujos de datos de alta frecuencia."))
                ((en . "Kubernetes and Docker, ArgoCD, Helm charts")
                 (nl . "Kubernetes en Docker, ArgoCD, Helm-grafieken")
                 (es . "Kubernetes y Docker, ArgoCD, Helm charts.")))))

(define jobs
  (list joe-job-vandebron joe-job-zorgdomein joe-job-ikea
        joe-job-pro-warehouse))

(define document-theme
  'fatum)
