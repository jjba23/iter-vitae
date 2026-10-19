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

(define document-theme
  'fatum)

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
  `(((en . "B driver's license, vehicles up to 3.5t")
     (nl . "Rijbewijs B, voertuigen t/m 3,5t")
     (es . "Permiso de conducir B, vehículos hasta 3,5t"))))

(define interests-hobbies
  `(((en . "Building and configuring custom computers, publishing technical insights via a personal blog, and playing tactical strategy games. Programming Lisp, and using Emacs.")
     (nl . "Bouwen en configureren van computers, publiceren van technische inzichten op een blog en het spelen van strategische spellen. Lisp programmeren, en Emacs gebruiken.")
     (es . "Montaje y configuración de ordenadores personalizados, publicación de análisis tecnológicos en blog propio y juegos de estrategia táctica. Programando Lisp, y usando Emacs."))
    ((en . "Playing classical and electric guitar 🎸.")
     (nl . "Spelen van klassieke en elektrische gitaar 🎸.")
     (es . "Interpretación de guitarra clásica y eléctrica 🎸."))
    ((en . "Active in CrossFit, furniture restoration, and home improvement projects outside of engineering.")
     (nl . "Naast engineering actief met CrossFit, meubelrestauratie en woningverbetering.")
     (es . "Práctica de CrossFit, restauración de muebles y proyectos de mejora del hogar fuera del ámbito de la ingeniería."))))

;; ====== Languages ======

(define language-proficiency
  `((en (1 . "Elementary Proficiency")
        (2 . "Basic Proficiency")
        (3 . "Professional Proficiency")
        (4 . "Native / Bilingual"))
    (nl (1 . "Elementaire Vaardigheid")
        (2 . "Basis Vaardigheid")
        (3 . "Professioneel Vaardig")
        (4 . "Moedertaal / Tweetalig"))
    (es (1 . "Competencia Elemental")
        (2 . "Competencia Básica")
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
                     (writing . 3)))
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

(define short-intro
  `(((en . "Software Engineer with extensive Full-Stack experience and a deep DevOps mindset. Proven track record of transforming complex architectural challenges into clean, maintainable, and high-impact code from requirements gathering to production optimization.")
     (nl . "Software Engineer met brede full-stack ervaring en een sterke DevOps-mentaliteit. Ervaren in het transformeren van complexe architectuuruitdagingen naar schone, onderhoudbare en impactvolle code, van requirements-analyse tot productie-optimalisatie.")
     (es . "Ingeniero de Software con experiencia Full-Stack y mentalidad DevOps. Capaz de transformar desafíos arquitectónicos complejos en código limpio, mantenible y de alto impacto, desde la definición de requisitos hasta la optimización en producción."))
    ((en . "Delivering robust software solutions using diverse technologies, including Scala, Kotlin, Java, Go and more.")
     (nl . "Ontwerper van robuuste software oplossingen met diverse tech-stacks, waaronder Scala, Kotlin, Java, Go en meer.")
     (es . "Diseño y construcción de soluciones robustas utilizando una variedad de lenguajes como Scala, Kotlin, Java, Go y mas."))))

;; ====== Education ======

(define joe-internship-liderlink
  `((name (all . "Liderlink Business Solutions"))
    (location (all . "Parchal, Portugal"))
    (position (en . "Back-end Developer Internship")
              (nl . "Back-end Ontwikkelaar Stage")
              (es . "Prácticas de Desarrollador Back-end"))
    (time (en . "February 2019 => July 2019")
          (nl . "Februari 2019 => Juli 2019")
          (es . "Febrero 2019 => Julio 2019"))
    (experience ((en . "Developed full-stack PHP, JavaScript, jQuery and MySQL CRUD operations for corporate real-estate, hospitality, and HR management platforms.")
                 (nl . "Ontwikkelde full-stack PHP, JavaScript, jQuery en MySQL CRUD-functionaliteiten voor systemen in vastgoed-, hotel- en personeelsbeheer.")
                 (es . "Desarrollo de operaciones CRUD con PHP, JavaScript, jQuery y MySQL en plataformas empresariales de gestión inmobiliaria, hotelera y de personal.")))))

(define education
  `(((name (all . "Leading Self"))
     (location (en . "Maarssen, The Netherlands")
               (nl . "Maarssen, Nederland")
               (es . "Maarssen, Países Bajos"))
     (position (en . "Leadership Course")
               (nl . "Leiderschap Cursus")
               (es . "Curso de Liderazgo"))
     (time (en . "Summer 2024")
           (nl . "Zomer 2024")
           (es . "Verano 2024"))
     (experience ((en . "Training in leadership, interpersonal dynamics, and high-empathy professional collaboration.")
                  (nl . "Leiderschapstraining afgerond gericht op interpersoonlijke dynamiek, effectieve samenwerking en werkplaatsempathie.")
                  (es . "Formación en liderazgo enfocado en relaciones interpersonales, dinámicas de colaboración y empatía laboral."))))
    ,joe-internship-liderlink
    ((name (all . "Universidade do Algarve"))
     (location (all . "Faro, Portugal"))
     (position (en . "IT Associate's Degree")
               (nl . "ICT HBO")
               (es . "Grado Superior en Informática (Associate's Degree)"))
     (time (en . "September 2017 => September 2019")
           (nl . "September 2017 => September 2019")
           (es . "Septiembre 2017 => Septiembre 2019"))
     (experience ((en . "Graduated with a score of 190/200, achieving the highest possible grade for the final software engineering internship.")
                  (nl . "Afgestudeerd met een score van 190/200 en de maximale beoordeling behaald voor de software-engineeringstage.")
                  (es . "Graduación con calificación sobresaliente de 190/200, obteniendo la nota máxima en las prácticas de ingeniería de software."))
                 ((all . "Java, PHP, SQL, Javascript, GNU/Linux, Excel, Alfresco BPM"))))))

;; ====== Jobs ======

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
    (experience ((en . "Optimized core business processes and web-shop data synchronization, reducing execution times from 1 week to just 4 minutes.")
                 (nl . "Optimaliseerde bedrijfsprocessen en de synchronisatie van webshopgegevens, wat de doorlooptijd verkortte van 1 week naar 4 minuten.")
                 (es . "Optimización de procesos comerciales y sincronización de datos de la tienda online, reduciendo el tiempo de procesamiento de 1 semana a solo 4 minutos."))
                ((en . "Built and deployed scalable services using Go (standard library & Gin), Vue.js, and PHP (Laravel).")
                 (nl . "Bouwde en implementeerde schaalbare services met Go (standaard & Gin), Vue.js en PHP (Laravel).")
                 (es . "Desarrollo y despliegue de servicios escalables utilizando Go (standard y Gin), Vue.js y PHP (Laravel)."))
                ((en . "Managed full database lifecycles, executing database design, normalization, migrations, maintenance, and backup strategies.")
                 (nl . "Beheerde de volledige database-levenscyclus, inclusief ontwerp, normalisatie, migratie, onderhoud en back-upstrategieën.")
                 (es . "Gestión del ciclo de vida completo de bases de datos, incluyendo el diseño, normalización, migración, mantenimiento y estrategias de respaldo."))
                ((en . "Engineered Jenkins CI/CD pipelines and managed production systems across FreeBSD and Linux environments.")
                 (nl . "Ontwierp Jenkins CI/CD-pipelines en beheerde infrastructurele implementaties op FreeBSD- en Linux-servers.")
                 (es . "Implementación de pipelines de CI/CD en Jenkins y administración de sistemas de producción en entornos FreeBSD y Linux.")))))

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
    (experience ((en . "Led the strategic migration of the postcode product availability system from legacy systems to Google Cloud Platform (GCP), significantly reducing operational infrastructure costs.")
                 (nl . "Leidde de strategische migratie van het postcodesysteem voor productbeschikbaarheid van legacy-software naar het Google Cloud Platform (GCP), met een aanzienlijke kostenreductie als resultaat.")
                 (es . "Liderazgo en la migración estratégica del sistema de disponibilidad de productos por código postal desde sistemas heredados a Google Cloud Platform (GCP), reduciendo drásticamente los costes de infraestructura."))
                ((en . "Designed cloud-native services using Java (Spring), Go, Kubernetes, Docker, Terraform, and Pub/Sub.")
                 (nl . "Ontwikkelde cloud-native diensten met behulp van Java (Spring), Go, Kubernetes, Docker, Terraform en Pub/Sub.")
                 (es . "Diseño de servicios cloud-native utilizando Java (Spring), Go, Kubernetes, Docker, Terraform y Pub/Sub."))
                ((en . "Integrated and maintained highly available data layers using PostgreSQL, BigTable, Elasticsearch, Redis, and Firebase.")
                 (nl . "Integreerde en beheerde complexe datalagen met PostgreSQL, BigTable, Elasticsearch, Redis en Firebase.")
                 (es . "Integración y gestión de capas de datos complejas utilizando PostgreSQL, BigTable, Elasticsearch, Redis y Firebase.")))))

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
    (experience ((en . "Introduced Event Storming methodologies to align cross-functional teams around event-driven architectures, accelerating feature delivery and minimizing technical debt.")
                 (nl . "Introduceerde Event Storming-methodologieën om multidisciplinaire teams op één lijn te krijgen rondom event-driven ontwerpen, wat de levering versnelde en technische schuld verminderde.")
                 (es . "Introducción de metodologías de Event Storming para alinear a los equipos multifuncionales en torno a arquitecturas orientadas a eventos, acelerando la entrega de funcionalidades y reduciendo la deuda técnica."))
                ((en . "Spearheaded the redesign of the platform's master search bar backend, driving a >50% increase in medical specialist satisfaction and streamlining clinical discovery workflows.")
                 (nl . "Leidde het herontwerp van de backend voor de hoofdzoekbalk van het platform, wat resulteerde in een stijging van >50% in de tevredenheid van medische specialisten en geoptimaliseerde klinische workflows.")
                 (es . "Liderazgo en el rediseño del backend de la barra de búsqueda principal de la plataforma, impulsando un aumento de más del 50 % en la satisfacción de los especialistas médicos y optimizando los flujos de trabajo de descubrimiento clínico."))
                ((en . "Engineered distributed microservices and robust REST APIs using Scala (ZIO), functional programming, Kafka, PostgreSQL, and Elasticsearch.")
                 (nl . "Bouwde gedistribueerde microservices en robuuste REST-API's met behulp van Scala (ZIO), functioneel programmeren, Kafka, PostgreSQL, en Elasticsearch.")
                 (es . "Desarrollo de microservicios distribuidos y APIs REST robustas utilizando Scala (ZIO), programación funcional, Kafka, PostgreSQL, y Elasticsearch."))
                ((en . "Established comprehensive quality guardrails using integration, black-box, unit, and E2E testing via Testcontainers, alongside conducting security assessments.")
                 (nl . "Zette kwaliteitsstandaarden op met integratie-, black-box-, unit- en E2E-testen via Testcontainers, en voerde beveiligingsbeoordelingen uit.")
                 (es . "Establecimiento de estándares de calidad mediante pruebas de integración, blackbox, unitarias y E2E utilizando Testcontainers, además de realizar evaluaciones de seguridad."))
                ((en . "Constructed big data pipelines in Python using Apache Spark and AWS Glue to fuel an automated product tagging system.")
                 (nl . "Bouwde big data-pijplijnen in Python met Apache Spark en AWS Glue voor een geautomatiseerd producttagsysteem.")
                 (es . "Construcción de pipelines de Big Data en Python usando Apache Spark y AWS Glue para potenciar un sistema automatizado de etiquetado de productos."))
                ((en . "Provisioned and managed secure cloud infrastructure using AWS services, including EC2, CloudFront, and S3.")
                 (nl . "Beheerde en implementeerde cloudinfrastructuur via AWS-services, waaronder EC2, CloudFront en S3.")
                 (es . "Administración e implementación de infraestructura en la nube utilizando servicios de AWS como EC2, CloudFront y S3.")))))

(define joe-job-vandebron
  `((name (all . "Vandebron B.V."))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Software Engineer")
              (nl . "Software Engineer")
              (es . "Ingeniero de Software Sénior"))
    (time (en . "August 2024 => September 2026")
          (nl . "Augustus 2024 => September 2026")
          (es . "Agosto 2024 => Septiembre 2026"))
    (experience ((en . "Architected and delivered a high-performance, real-time energy calculation service (<em class=\"italic\">“greenest moment of the day”</em>) meeting strict sub-50ms latency SLAs to optimize green energy consumption for thousands of active users.")
                 (nl . "Ontwierp en implementeerde een hoogwaardige, realtime energieberekeningsservice (<em class=\"italic\">groenste moment van de dag</em>) die voldoet aan strikte SLA's met een latentie van minder dan 50 ms om het groene energieverbruik voor duizenden actieve gebruikers te optimaliseren.")
                 (es . "Diseño e implementación de un servicio de cálculo de energía de alto rendimiento y en tiempo real (<em class=\"italic\">el momento más ecológico del día</em>) que cumple con estrictos acuerdos de nivel de servicio (SLA) de latencia inferior a 50 ms para optimizar el consumo de energía verde para miles de usuarios activos."))
                ((en . "Improved monthly customer energy reporting, boosting speed, UI/UX and reducing error rate to 1 in 100k processes.")
                 (nl . "Verbeterde maandelijkse rapportage over het energieverbruik van klanten, hogere snelheid, betere gebruikersinterface en -ervaring, en een foutpercentage van 1 op 100.000 processen.")
                 (es . "Mejora de los informes mensuales de consumo energético de los clientes, aumentando la velocidad, la UI/UX, y reduciendo la tasa de errores hasta 1 en cada 100.000 procesos."))
                ((en . "Designed asynchronous, event-driven microservices using Kotlin (Spring), Scala (ZIO), GraphQL, and Kafka to process high-frequency data streams.")
                 (nl . "Ontwierp asynchrone, gebeurtenisgestuurde microservices met behulp van Kotlin (Spring), Scala (ZIO), GraphQL en Kafka om datastromen met een hoge frequentie te verwerken.")
                 (es . "Diseño de microservicios asíncronos y basados en eventos utilizando Kotlin (Spring), Scala (ZIO), GraphQL y Kafka para gestionar flujos de datos de alta frecuencia."))
                ((en . "Automated orchestration and container deployments using Kubernetes, Docker, ArgoCD, and Helm charts.")
                 (nl . "Automatiseerde orchestratie en container-deployments met behulp van Kubernetes, Docker, ArgoCD en Helm-charts.")
                 (es . "Automatización de la orquestación y el despliegue de contenedores utilizando Kubernetes, Docker, ArgoCD y Helm charts.")))))

(define jobs
  (list joe-job-vandebron joe-job-zorgdomein joe-job-ikea
        joe-job-pro-warehouse))
