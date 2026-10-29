;; iter-vitae
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;
;; A real, multilingual persona.  It is ordinary Scheme: change values, add
;; jobs, or factor repeated entries into functions.  The visual themes use the
;; translations below; the ATS and plain-text renderers flatten them.
;;
;;; Code:

(define-module (iter-vitae persona)
  #:declarative? #t)

;; Optional: a portrait makes the visual themes feel more personal.  Use a
;; square image around 400-600 px, either a local PNG/JPEG/WebP/SVG or an
;; https:// URL.  Local paths are relative to this file; the renderer embeds
;; the image in the HTML so the CV remains a single, self-contained file.
;;
;; (define profile-picture "../assets/portrait.jpg")

(define document-theme
  'fatum)

(define display-name
  '((all . "Josep Bigorra")))

(define job-title-link
  '((all . "https://en.wikipedia.org/wiki/Software_engineering")))

(define job-title
  '((en . "Software Engineer ⚙️") (nl . "Software Engineer ⚙️")
    (es . "Ingeniero de Software ⚙️")))

(define personal-contact
  '((emails . "jjbigorra@gmail.com") (phone-numbers . "+31 639825138")))

(define personal-links
  '((blog . "jointhefreeworld.org") (code . "codeberg.org/jjba23")
    (linked-in . "linkedin.com/in/josepjba")))

(define address-lines
  '(((all . "1441KH Purmerend"))
    ((en . "The Netherlands") (nl . "Nederland")
     (es . "Países Bajos"))))

(define driver-licenses
  '(((en . "Category B (vehicles up to 3.5 t)")
     (nl . "Categorie B (voertuigen tot 3,5 t)")
     (es . "Categoría B (vehículos hasta 3,5 t)"))))

(define interests-hobbies
  '((     (en . "Building and configuring custom computers, writing about technology on my blog, and playing tactical strategy games; I also program in Lisp and live in Emacs.")
     (nl . "Bouwen en configureren van aangepaste computers, schrijven over technologie op mijn blog en strategische spellen spelen; daarnaast programmeer ik in Lisp en leef ik in Emacs.")
     (es . "Montaje y configuración de ordenadores personalizados, escritura sobre tecnología en mi blog y juegos de estrategia táctica; además programo en Lisp y vivo en Emacs."))
    ((en . "Playing classical and electric guitar 🎸.")
     (nl . "Spelen van klassieke en elektrische gitaar 🎸.")
     (es . "Interpretación de guitarra clásica y eléctrica 🎸."))
    ((en . "Staying active with CrossFit, restoring furniture, and improving my home outside of engineering.")
     (nl . "Naast engineering actief met CrossFit, meubelrestauratie en woningverbetering.")
     (es . "Práctica de CrossFit, restauración de muebles y proyectos de mejora del hogar fuera del ámbito de la ingeniería."))))

;; ====== Languages ======

(define language-proficiency
  '((en (1 . "Elementary")
        (2 . "Limited working")
        (3 . "Professional working")
        (4 . "Full professional")
        (5 . "Native or bilingual"))
    (nl (1 . "Elementair")
        (2 . "Beperkt werkzaam")
        (3 . "Professioneel werkzaam")
        (4 . "Volledig professioneel")
        (5 . "Moedertaal of tweetalig"))
    (es (1 . "Elemental")
        (2 . "Laboral limitado")
        (3 . "Profesional")
        (4 . "Profesional pleno")
        (5 . "Nativo o bilingüe"))))

(define languages
  '(    (en (name (en . "🇬🇧 English")
              (nl . "🇬🇧 Engels")
              (es . "🇬🇧 Inglés"))
        (proficiency (reading . 5)
                     (speaking . 5)
                     (writing . 5)))
    (nl (name (en . "🇳🇱 Dutch")
              (nl . "🇳🇱 Nederlands")
              (es . "🇳🇱 Neerlandés"))
        (proficiency (reading . 4)
                     (speaking . 4)
                     (writing . 3)))
    (ca (name (en . "Catalan")
              (nl . "Catalaans")
              (es . "Catalán"))
        (proficiency (reading . 5)
                     (speaking . 4)
                     (writing . 4)))
    (es (name (en . "🇪🇸 Spanish")
              (nl . "🇪🇸 Spaans")
              (es . "🇪🇸 Español"))
        (proficiency (reading . 5)
                     (speaking . 5)
                     (writing . 5)))
    (pt (name (en . "🇵🇹 Portuguese")
              (nl . "🇵🇹 Portugees")
              (es . "🇵🇹 Portugués"))
        (proficiency (reading . 4)
                     (speaking . 4)
                     (writing . 4)))))

(define short-intro
  '((     (en . "Software engineer with full-stack experience and a DevOps mindset. I turn complex architectural problems into maintainable, high-impact code, from requirements gathering to production support.")
     (nl . "Software engineer met brede full-stack ervaring en een sterke DevOps-mentaliteit. Ik vertaal complexe architectuurvraagstukken naar onderhoudbare, impactvolle code, van requirements-analyse tot productieondersteuning.")
     (es . "Ingeniero de software con experiencia full-stack y mentalidad DevOps. Convierto problemas arquitectónicos complejos en código mantenible y de alto impacto, desde la definición de requisitos hasta el soporte en producción."))
    ((en . "I deliver robust software with Scala, Kotlin, Java, Go and related technologies.")
     (nl . "Ik lever robuuste software met Scala, Kotlin, Java, Go en aanverwante technologieën.")
     (es . "Entrego software robusto con Scala, Kotlin, Java, Go y tecnologías relacionadas."))))

;; ====== Education ======

(define joe-internship-liderlink
  '((name (all . "Liderlink Business Solutions"))
    (location (all . "Parchal, Portugal"))
    (position (en . "Back-end Developer Internship")
              (nl . "Back-end Ontwikkelaar Stage")
              (es . "Prácticas de Desarrollador Back-end"))
    (time (en . "February 2019 => July 2019")
          (nl . "Februari 2019 => Juli 2019")
          (es . "Febrero 2019 => Julio 2019"))
    (experience (     (en . "Built full-stack PHP, JavaScript, jQuery and MySQL CRUD features for real-estate, hospitality and HR platforms.")
                 (nl . "Bouwde full-stack PHP-, JavaScript-, jQuery- en MySQL-CRUD-functionaliteiten voor vastgoed-, hotel- en personeelsplatformen.")
                 (es . "Desarrollo de funciones CRUD full-stack con PHP, JavaScript, jQuery y MySQL para plataformas inmobiliarias, hoteleras y de personal.")))))

(define education
  (list
   '((name (all . "Leading Self"))
     (location (en . "Maarssen, The Netherlands")
               (nl . "Maarssen, Nederland")
               (es . "Maarssen, Países Bajos"))
     (position (en . "Leadership Course")
               (nl . "Leiderschap Cursus")
               (es . "Curso de Liderazgo"))
     (time (en . "Summer 2024")
           (nl . "Zomer 2024")
           (es . "Verano 2024"))
     (experience ((en . "Leadership training focused on interpersonal dynamics, collaboration and empathy at work.")
                  (nl . "Leiderschapstraining gericht op interpersoonlijke dynamiek, samenwerking en empathie op de werkvloer.")
                  (es . "Formación en liderazgo centrada en dinámicas interpersonales, colaboración y empatía en el trabajo."))))
   joe-internship-liderlink
   '((name (all . "Universidade do Algarve"))
     (location (all . "Faro, Portugal"))
     (position (en . "Higher Vocational Degree in IT")
               (nl . "HBO-ICT")
               (es . "Grado Superior en Informática"))
     (time (en . "September 2017 => September 2019")
           (nl . "September 2017 => September 2019")
           (es . "Septiembre 2017 => Septiembre 2019"))
     (experience ((en . "Graduated with a score of 190/200, achieving the highest possible grade for the final software engineering internship.")
                  (nl . "Afgestudeerd met een score van 190/200 en de maximale beoordeling behaald voor de software-engineeringstage.")
                  (es . "Graduación con calificación sobresaliente de 190/200, obteniendo la nota máxima en las prácticas de ingeniería de software."))
                 ((en . "Coursework: Java, PHP, SQL, JavaScript, GNU/Linux, Excel, Alfresco BPM")
                  (nl . "Vakken: Java, PHP, SQL, JavaScript, GNU/Linux, Excel, Alfresco BPM")
                  (es . "Asignaturas: Java, PHP, SQL, JavaScript, GNU/Linux, Excel, Alfresco BPM"))))))

;; ====== Jobs ======

(define joe-job-pro-warehouse
  '((name (all . "Pro Warehouse B.V."))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Full-stack Developer")
              (nl . "Full-stack Ontwikkelaar")
              (es . "Programador Full-stack"))
    (time (en . "November 2019 => December 2021")
          (nl . "November 2019 => December 2021")
          (es . "Noviembre 2019 => Diciembre 2021"))
    (experience (     (en . "Optimised core business processes and web-shop data sync, cutting execution time from one week to four minutes.")
                 (nl . "Optimaliseerde bedrijfsprocessen en de synchronisatie van webshopgegevens, waardoor de doorlooptijd van een week naar vier minuten ging.")
                 (es . "Optimización de procesos comerciales y sincronización de datos de la tienda online, reduciendo el tiempo de ejecución de una semana a cuatro minutos."))
                ((en . "Built and deployed scalable services using Go (standard library & Gin), Vue.js, and PHP (Laravel).")
                 (nl . "Bouwde en implementeerde schaalbare services met Go (standaard & Gin), Vue.js en PHP (Laravel).")
                 (es . "Desarrollo y despliegue de servicios escalables utilizando Go (standard y Gin), Vue.js y PHP (Laravel)."))
                (     (en . "Managed full database lifecycles: design, normalisation, migrations, maintenance and backups.")
                 (nl . "Beheerde de volledige database-levenscyclus: ontwerp, normalisatie, migraties, onderhoud en back-ups.")
                 (es . "Gestión del ciclo de vida completo de bases de datos: diseño, normalización, migraciones, mantenimiento y copias de seguridad."))
                (     (en . "Built Jenkins CI/CD pipelines and ran production systems on FreeBSD and Linux.")
                 (nl . "Bouwde Jenkins CI/CD-pipelines en beheerde productiesystemen op FreeBSD en Linux.")
                 (es . "Implementación de pipelines de CI/CD en Jenkins y administración de sistemas de producción en FreeBSD y Linux.")))))

(define joe-job-ikea
  '((name (all . "IKEA (Ingka Digital)"))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Software Engineer")
              (nl . "Software Engineer")
              (es . "Ingeniero de Software"))
    (time (en . "January 2022 => March 2023")
          (nl . "Januari 2022 => Maart 2023")
          (es . "Enero 2022 => Marzo 2023"))
    (experience (     (en . "Led the migration of the postcode availability system from legacy servers to Google Cloud Platform, cutting infrastructure costs.")
                 (nl . "Leidde de migratie van het postcodesysteem voor productbeschikbaarheid van legacy-servers naar Google Cloud Platform, met lagere infrastructuurkosten.")
                 (es . "Liderazgo en la migración del sistema de disponibilidad por código postal desde servidores heredados a Google Cloud Platform, reduciendo los costes de infraestructura."))
                ((en . "Designed cloud-native services using Java (Spring), Go, Kubernetes, Docker, Terraform, and Pub/Sub.")
                 (nl . "Ontwikkelde cloud-native diensten met behulp van Java (Spring), Go, Kubernetes, Docker, Terraform en Pub/Sub.")
                 (es . "Diseño de servicios cloud-native utilizando Java (Spring), Go, Kubernetes, Docker, Terraform y Pub/Sub."))
                ((en . "Integrated and maintained highly available data layers using PostgreSQL, BigTable, Elasticsearch, Redis, and Firebase.")
                 (nl . "Integreerde en beheerde complexe datalagen met PostgreSQL, BigTable, Elasticsearch, Redis en Firebase.")
                 (es . "Integración y gestión de capas de datos complejas utilizando PostgreSQL, BigTable, Elasticsearch, Redis y Firebase.")))))

(define joe-job-zorgdomein
  '((name (all . "ZorgDomein B.V."))
    (location (en . "Breukelen, The Netherlands")
              (nl . "Breukelen, Nederland")
              (es . "Breukelen, Países Bajos"))
    (position (en . "Software Engineer")
              (nl . "Software Engineer")
              (es . "Ingeniero de Software"))
    (time (en . "April 2023 => July 2024")
          (nl . "April 2023 => Juli 2024")
          (es . "Abril 2023 => Julio 2024"))     (experience ((en . "Introduced Event Storming to align cross-functional teams on event-driven architecture, speeding up delivery and reducing technical debt.")
                 (nl . "Introduceerde Event Storming om multidisciplinaire teams op één lijn te krijgen rond event-driven architectuur, wat de levering versnelde en technische schuld verminderde.")
                 (es . "Introducción de Event Storming para alinear a los equipos multifuncionales en torno a la arquitectura orientada a eventos, acelerando la entrega y reduciendo la deuda técnica."))
                (     (en . "Led the redesign of the platform's main search backend, raising medical specialist satisfaction by more than 50% and simplifying clinical search.")
                 (nl . "Leidde het herontwerp van de backend voor de hoofdzoekbalk, verhoogde de tevredenheid van medisch specialisten met meer dan 50% en vereenvoudigde het klinisch zoeken.")
                 (es . "Liderazgo en el rediseño del backend de búsqueda principal, aumentando la satisfacción de los especialistas médicos más de un 50% y simplificando la búsqueda clínica."))
                (     (en . "Built distributed microservices and REST APIs with functional Scala (ZIO), Kafka, PostgreSQL and Elasticsearch.")
                 (nl . "Bouwde gedistribueerde microservices en REST-API's met functioneel Scala (ZIO), Kafka, PostgreSQL en Elasticsearch.")
                 (es . "Desarrollo de microservicios distribuidos y APIs REST con Scala funcional (ZIO), Kafka, PostgreSQL y Elasticsearch."))
                (     (en . "Set up integration, black-box, unit and end-to-end tests with Testcontainers, and ran security assessments.")
                 (nl . "Zette integratie-, black-box-, unit- en end-to-end-testen op met Testcontainers en voerde beveiligingsbeoordelingen uit.")
                 (es . "Configuración de pruebas de integración, caja negra, unitarias y de extremo a extremo con Testcontainers, además de evaluaciones de seguridad."))
                (     (en . "Built Python data pipelines with Apache Spark and AWS Glue for an automated product-tagging system.")
                 (nl . "Bouwde Python-datapijplijnen met Apache Spark en AWS Glue voor een geautomatiseerd producttagsysteem.")
                 (es . "Construcción de pipelines de datos en Python con Apache Spark y AWS Glue para un sistema automatizado de etiquetado de productos."))
                (     (en . "Provisioned and managed AWS infrastructure including EC2, CloudFront and S3.")
                 (nl . "Beheerde en implementeerde AWS-infrastructuur, waaronder EC2, CloudFront en S3.")
                 (es . "Administración e implementación de infraestructura en AWS, incluyendo EC2, CloudFront y S3.")))))

(define joe-job-vandebron
  '((name (all . "Vandebron B.V."))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Software Engineer")
              (nl . "Software Engineer")
              (es . "Ingeniero de Software"))
    (time (en . "August 2024 => September 2026")
          (nl . "Augustus 2024 => September 2026")
          (es . "Agosto 2024 => Septiembre 2026"))
    (experience (     (en . "Designed and shipped a real-time energy calculation service (<em class=\"italic\">“greenest moment of the day”</em>) with sub-50 ms SLAs for thousands of active users.")
                 (nl . "Ontwierp en leverde een realtime energieberekeningsservice (<em class=\"italic\">groenste moment van de dag</em>) met SLA's van minder dan 50 ms voor duizenden actieve gebruikers.")
                 (es . "Diseño y entrega de un servicio de cálculo de energía en tiempo real (<em class=\"italic\">el momento más ecológico del día</em>) con SLA de menos de 50 ms para miles de usuarios activos."))
                (     (en . "Rebuilt monthly customer energy reports, improving speed and usability and cutting errors to 1 in 100,000 runs.")
                 (nl . "Herbouwde de maandelijkse energierapportage voor klanten, met betere snelheid en bruikbaarheid en fouten teruggebracht tot 1 op 100.000 runs.")
                 (es . "Reconstrucción de los informes mensuales de energía para clientes, mejorando la velocidad y la usabilidad y reduciendo los errores a 1 de cada 100.000 ejecuciones."))
                ((en . "Designed asynchronous, event-driven microservices using Kotlin (Spring), Scala (ZIO), GraphQL, and Kafka to process high-frequency data streams.")
                 (nl . "Ontwierp asynchrone, gebeurtenisgestuurde microservices met behulp van Kotlin (Spring), Scala (ZIO), GraphQL en Kafka om datastromen met een hoge frequentie te verwerken.")
                 (es . "Diseño de microservicios asíncronos y basados en eventos utilizando Kotlin (Spring), Scala (ZIO), GraphQL y Kafka para gestionar flujos de datos de alta frecuencia."))
                (     (en . "Automated container orchestration and deployments with Kubernetes, Docker, Argo CD and Helm.")
                 (nl . "Automatiseerde orchestratie en container-deployments met behulp van Kubernetes, Docker, ArgoCD en Helm-charts.")
                 (es . "Automatización de la orquestación y el despliegue de contenedores utilizando Kubernetes, Docker, ArgoCD y Helm charts.")))))

(define jobs
  (list joe-job-vandebron joe-job-zorgdomein joe-job-ikea
        joe-job-pro-warehouse))

;;; Skills

(define (skill name)
  `((all . ,name)))

(define skills
  (map skill
       '("Scala" "Kotlin" "Java" "Go" "Kubernetes" "Terraform"
         "PostgreSQL" "Kafka" "GraphQL" "AWS" "CI/CD")))
