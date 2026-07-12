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
  `(((en . "B driver's license, vehicles up to 3.5t")
     (nl . "Rijbewijs B, voertuigen t/m 3,5t")
     (es . "Permiso de conducir B, vehículos hasta 3,5t"))))

(define interests-hobbies
  `(((en . "I build and configure custom computers, publish my technical insights on my blog, and enjoy tactical strategy games.")
     (nl . "Ik bouw en configureer computers, publiceer technische inzichten op mijn blog en speel strategische spellen.")
     (es . "Ensamblo y configuro ordenadores, publico análisis tecnológicos en mi blog y juego a videojuegos de estrategia."))
    ((en . "I play classical and electric guitar 🎸.")
     (nl . "Ik speel klassieke en elektrische gitaar 🎸.")
     (es . "Toco la guitarra clásica y eléctrica 🎸."))
    ((en . "Outside of engineering, I dedicate my time to CrossFit, furniture restoration, and home improvement projects.")
     (nl . "Naast engineering besteed ik mijn tijd aan CrossFit, meubelrestauratie en woningverbetering.")
     (es . "Fuera de la ingeniería, practico CrossFit y me dedico a la restauración de muebles y a proyectos de mejora del hogar."))))

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
    (position (en . "Back-end Developer Internship")
              (nl . "Back-end Ontwikkelaar Stage")
              (es . "Prácticas de Desarrollador Back-end"))
    (time (en . "February 2019 => July 2019")
          (nl . "Februari 2019 => Juli 2019")
          (es . "Febrero 2019 => Julio 2019"))
    (experience ((en . "I developed full-stack PHP and MySQL CRUD operations for corporate real-estate, hospitality, and HR management platforms.")
                 (nl . "Ik ontwikkelde full-stack PHP en MySQL CRUD-functionaliteiten voor systemen in vastgoed-, hotel- en personeelsbeheer.")
                 (es . "Desarrollé operaciones CRUD con PHP y MySQL en plataformas empresariales de gestión inmobiliaria, hotelera y de personal."))
                ((en . "I implemented interactive client-side scripting using JavaScript and jQuery integrated with server-side templates.")
                 (nl . "Ik implementeerde interactieve client-side scripting met JavaScript en jQuery in combinatie met server-side templates.")
                 (es . "Programé scripts interactivos en el lado del cliente con JavaScript y jQuery en integración con plantillas del lado del servidor.")))))

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
     (experience ((en . "I completed advanced training in leadership, interpersonal dynamics, and high-empathy professional collaboration.")
                  (nl . "Ik heb een leiderschapstraining afgerond gericht op interpersoonlijke dynamiek, effectieve samenwerking en werkplaatsempathie.")
                  (es . "Completé una formación en liderazgo enfocado en relaciones interpersonales, dinámicas de colaboración y empatía laboral."))))
    ,joe-internship-liderlink
    ((name (all . "Universidade do Algarve"))
     (location (all . "Faro, Portugal"))
     (position (en . "IT Associate's Degree")
               (nl . "ICT HBO")
               (es . "Grado Superior en Informática (Associate's Degree)"))
     (time (en . "September 2017 => September 2019")
           (nl . "September 2017 => September 2019")
           (es . "Septiembre 2017 => Septiembre 2019"))
     (experience ((en . "I graduated with an outstanding score of 190/200, achieving the highest possible grade for my final software engineering internship.")
                  (nl . "Ik ben afgestudeerd met een score van 190/200 en behaalde de maximale beoordeling voor mijn software-engineeringstage.")
                  (es . "Me gradué con una calificación sobresaliente de 190/200, obteniendo la nota máxima en las prácticas de ingeniería de software."))
                 ((all . "Java, PHP, SQL, Javascript, GNU/Linux, Excel, Alfresco BPM"))))))

(define short-intro
  `(((en . "I am a driven Senior Software Engineer with extensive Full-Stack experience and a deep DevOps mindset. From gathering requirements to production optimization, I transform complex architectural challenges into clean, maintainable, and high-impact code.")
     (nl . "Ik ben een gedreven Senior Software Engineer met full-stack ervaring en een DevOps-mentaliteit. Van requirements-analyse tot productie-optimalisatie transformeer ik complexe architectuuruitdagingen naar schone, onderhoudbare en impactvolle code.")
     (es . "Soy un Ingeniero de Software Sénior proactivo con experiencia Full-Stack y mentalidad DevOps. Desde la definición de requisitos hasta la optimización en producción, transformo desafíos arquitectónicos complejos en código limpio, mantenible y de alto impacto."))
    ((en . "I architect robust solutions using a diverse tech stack, including Java, Kotlin, Scala, Haskell, JavaScript, TypeScript, Python, Rust, Bash, SQL, Scheme, and Lisp.")
     (nl . "Ik ontwerp oplossingen met een diverse tech-stack, waaronder Java, Kotlin, Scala, Haskell, JavaScript, TypeScript, Python, Rust, Bash, SQL, Scheme en Lisp.")
     (es . "Construyo soluciones robustas utilizando una variedad de lenguajes como Java, Kotlin, Scala, Haskell, JavaScript, TypeScript, Python, Rust, Bash, SQL, Scheme y Lisp."))))

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
    (experience ((en . "I optimized core business processes and web-shop data synchronization, reducing execution times from 1 week to just 4 minutes.")
                 (nl . "Ik optimaliseerde de bedrijfsprocessen en de synchronisatie van webshopgegevens, wat de doorlooptijd verkortte van 1 week naar 4 minuten.")
                 (es . "Optimicé los procesos comerciales y la sincronización de datos de la tienda online, reduciendo el tiempo de procesamiento de 1 semana a solo 4 minutos."))
                ((en . "I built and deployed scalable services using Go (standard library & Gin), Vue.js, and PHP (Laravel).")
                 (nl . "Ik bouwde en implementeerde schaalbare services met Go (standaard & Gin), Vue.js en PHP (Laravel).")
                 (es . "Desarrollé y desplegué servicios escalables utilizando Go (standard y Gin), Vue.js y PHP (Laravel)."))
                ((en . "I introduced and spearheaded the adoption of Agile working methodologies and Extreme Programming (XP) practices.")
                 (nl . "Ik introduceerde en leidde Agile-werkmethodologieën en Extreme Programming (XP) binnen het team.")
                 (es . "Introduje y lideré la adopción de metodologías de trabajo Agile y prácticas de Extreme Programming (XP)."))
                ((en . "I managed full database lifecycles, executing database design, normalization, migrations, maintenance, and backup strategies.")
                 (nl . "Ik beheerde de volledige database-levenscyclus, inclusief ontwerp, normalisatie, migratie, onderhoud en back-upstrategieën.")
                 (es . "Gestioné el ciclo de vida completo de bases de datos, incluyendo el diseño, normalización, migración, mantenimiento y estrategias de respaldo."))
                ((en . "I engineered Jenkins CI/CD pipelines and managed production systems across FreeBSD and Linux environments.")
                 (nl . "Ik ontwierp Jenkins CI/CD-pipelines en beheerde infrastructurele implementaties op FreeBSD- en Linux-servers.")
                 (es . "Implementé pipelines de CI/CD en Jenkins y administré sistemas de producción en entornos FreeBSD y Linux.")))))

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
    (experience ((en . "I led the strategic migration of the postcode product availability system from legacy systems to Google Cloud Platform (GCP), significantly reducing operational infrastructure costs.")
                 (nl . "Ik leidde de strategische migratie van het postcodesysteem voor productbeschikbaarheid van legacy-software naar het Google Cloud Platform (GCP), met een aanzienlijke kostenreductie als resultaat.")
                 (es . "Lideré la migración estratégica del sistema de disponibilidad de productos por código postal desde sistemas heredados a Google Cloud Platform (GCP), reduciendo drásticamente los costes de infraestructura."))
                ((en . "I designed cloud-native services utilizing Go, Java, Spring, Kubernetes, Docker, Terraform, and Pub/Sub.")
                 (nl . "Ik ontwikkelde cloud-native diensten met behulp van Go, Java, Spring, Kubernetes, Docker, Terraform en Pub/Sub.")
                 (es . "Diseñé servicios cloud-native utilizando Go, Java, Spring, Kubernetes, Docker, Terraform y Pub/Sub."))
                ((en . "I integrated and maintained highly available data layers utilizing PostgreSQL, BigTable, Elasticsearch, Redis, and Firebase.")
                 (nl . "Ik integreerde en beheerde complexe datalagen met PostgreSQL, BigTable, Elasticsearch, Redis en Firebase.")
                 (es . "Integré y gestioné capas de datos complejas utilizando PostgreSQL, BigTable, Elasticsearch, Redis y Firebase.")))))

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
    (experience ((en . "I introduced Event Storming methodologies to align cross-functional teams around event-driven architectures, accelerating feature delivery and minimizing technical debt.")
                 (nl . "Ik introduceerde Event Storming-methodologieën om multidisciplinaire teams op één lijn te krijgen rondom event-driven ontwerpen, wat de levering versnelde en technische schuld verminderde.")
                 (es . "Introduje metodologías de Event Storming para alinear a los equipos multifuncionales en torno a arquitecturas orientadas a eventos, acelerando la entrega de funcionalidades y reduciendo la deuda técnica."))
                ((en . "I spearheaded the redesign of the platform's master search bar backend, driving a >50% increase in medical specialist satisfaction and streamlining clinical discovery workflows.")
                 (nl . "Ik leidde het herontwerp van de backend voor de hoofdzoekbalk van het platform, wat resulteerde in een stijging van >50% in de tevredenheid van medische specialisten en geoptimaliseerde klinische workflows.")
                 (es . "Lideré el rediseño del backend de la barra de búsqueda principal de la plataforma, impulsando un aumento de más del 50 % en la satisfacción de los especialistas médicos y optimizando los flujos de trabajo de descubrimiento clínico."))
                ((en . "I engineered distributed microservices and robust REST APIs utilizing Scala and functional programming principles.")
                 (nl . "Ik bouwde gedistribueerde microservices en robuuste REST-API's met behulp van Scala en functioneel programmeren.")
                 (es . "Desarrollé microservicios distribuidos y APIs REST robustas utilizando Scala y principios de programación funcional."))
                ((en . "I maintained high-throughput data layers leveraging Kafka, PostgreSQL, and Elasticsearch.")
                 (nl . "Ik beheerde high-throughput datalagen met Kafka, PostgreSQL en Elasticsearch.")
                 (es . "Administré capas de datos de alto rendimiento aprovechando Kafka, PostgreSQL y Elasticsearch."))
                ((en . "I established comprehensive quality guardrails using integration, black-box, unit, and E2E testing via Testcontainers, alongside conducting security assessments.")
                 (nl . "Ik zette kwaliteitsstandaarden op met integratie-, black-box-, unit- en E2E-testen via Testcontainers, en voerde beveiligingsbeoordelingen uit.")
                 (es . "Establecí estándares de calidad mediante pruebas de integración, blackbox, unitarias y E2E utilizando Testcontainers, además de realizar evaluaciones de seguridad."))
                ((en . "I constructed big data pipelines in Python using Apache Spark and AWS Glue to fuel an automated product tagging system.")
                 (nl . "Ik bouwde big data-pijplijnen in Python met Apache Spark en AWS Glue voor een geautomatiseerd producttagsysteem.")
                 (es . "Construí pipelines de Big Data en Python usando Apache Spark y AWS Glue para potenciar un sistema automatizado de etiquetado de productos."))
                ((en . "I provisioned and managed secure cloud infrastructure using AWS services, including EC2, CloudFront, and S3.")
                 (nl . "Ik beheerde en implementeerde cloudinfrastructuur via AWS-services, waaronder EC2, CloudFront en S3.")
                 (es . "Administré e implementé infraestructura en la nube utilizando servicios de AWS como EC2, CloudFront y S3.")))))

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
    (experience ((en . "I architected and delivered a high-performance, real-time energy calculation service ('greenest moment of the day') meeting strict sub-50ms latency SLAs to optimize green energy consumption for thousands of active users.")
                 (nl . "Ik heb een hoogwaardige, realtime energieberekeningsservice ('het groenste moment van de dag') ontworpen en geïmplementeerd die voldoet aan strikte SLA's met een latentie van minder dan 50 ms om het groene energieverbruik voor duizenden actieve gebruikers te optimaliseren.")
                 (es . "Diseñé e implementé un servicio de cálculo de energía de alto rendimiento y en tiempo real ('el momento más ecológico del día') que cumple con estrictos acuerdos de nivel de servicio (SLA) de latencia inferior a 50 ms para optimizar el consumo de energía verde para miles de usuarios activos."))
                ((en . "I designed asynchronous, event-driven microservices using Scala (ZIO), Kotlin, GraphQL, and Kafka to process high-frequency data streams.")
                 (nl . "Ik heb asynchrone, gebeurtenisgestuurde microservices ontworpen met behulp van Scala (ZIO), Kotlin, GraphQL en Kafka om datastromen met een hoge frequentie te verwerken.")
                 (es . "Diseñé microservicios asíncronos y basados en eventos utilizando Scala (ZIO), Kotlin, GraphQL y Kafka para gestionar flujos de datos de alta frecuencia."))
                ((en . "I automated orchestration and container deployments using Kubernetes, Docker, ArgoCD, and Helm charts.")
                 (nl . "Ik automatiseerde de orchestratie en container-deployments met behulp van Kubernetes, Docker, ArgoCD en Helm-charts.")
                 (es . "Automaticé la orquestación y el despliegue de contenedores utilizando Kubernetes, Docker, ArgoCD y Helm charts.")))))

(define jobs
  (list joe-job-vandebron joe-job-zorgdomein joe-job-ikea
        joe-job-pro-warehouse))

(define document-theme
  'fatum)
