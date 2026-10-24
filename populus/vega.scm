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

;; A second, fictional persona.  Every name, employer, address and detail
;; below is invented: use this file as a template when you write your own CV,
;; and as the source of the screenshots in the README and assets/.
;;
;; To reproduce those images, change ~document-theme~ to each supported theme
;; and render once per theme, for example:
;;
;;   iter-vitae --file "$PWD/populus/vega.scm" --destination ./dist
;;
;; See populus/joe.scm for a real, multilingual CV with three locales.

(define-module (iter-vitae persona)
  #:declarative? #t)

(define document-theme
  'fatum)

(define display-name
  `((all . "Robin Vega")))

(define job-title
  `((en . "Platform Engineer 🛠️") (nl . "Platform Engineer 🛠️")
    (es . "Ingeniera de Plataforma 🛠️")))

(define job-title-link
  `((all . "https://en.wikipedia.org/wiki/Platform_engineering")))

(define personal-contact
  `((emails . "robin@example.org") (phone-numbers . "+31 612 345 678")))

(define personal-links
  `((blog . "example.org/blog") (code . "codeberg.org/robinvega")
    (linked-in . "linkedin.com/in/robinvega")))

(define address-lines
  `(((all . "2311 AB Leiden"))
    ((en . "The Netherlands") (nl . "Nederland")
     (es . "Países Bajos"))))

(define driver-licenses
  `(((en . "B driver's license, vehicles up to 3.5t")
     (nl . "Rijbewijs B, voertuigen t/m 3,5t")
     (es . "Permiso de conducir B, vehículos hasta 3,5t"))))

(define interests-hobbies
  `(((en . "Restoring old bicycles, long-distance cycling and mapping every repair in Org mode.")
     (nl . "Oude fietsen restaureren, lange fietstochten maken en elke reparatie in Org mode bijhouden.")
     (es . "Restaurar bicicletas antiguas, hacer rutas largas en bicicleta y documentar cada reparación en Org mode."))
    ((en . "Playing bass in a small jazz trio 🎻.")
     (nl . "Basspelen in een klein jazztrio 🎻.")
     (es . "Tocar el bajo en un pequeño trío de jazz 🎻."))))

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
        (2 . "Competencia Limitada")
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
        (proficiency (reading . 4)
                     (speaking . 3)
                     (writing . 3)))
    (es (name (en . "🇪🇸 Spanish")
              (nl . "🇪🇸 Spaans")
              (es . "🇪🇸 Español"))
        (proficiency (reading . 3)
                     (speaking . 3)
                     (writing . 2)))))

(define short-intro
  `(((en . "Platform engineer who likes boring infrastructure: reproducible builds, small images, declarative configuration and pipelines that fail loudly instead of silently.")
     (nl . "Platform engineer met een voorkeur voor saaie infrastructuur: reproduceerbare builds, kleine images, declaratieve configuratie en pipelines die luid falen in plaats van stil.")
     (es . "Ingeniera de plataforma a la que le gusta la infraestructura aburrida: builds reproducibles, imágenes pequeñas, configuración declarativa y pipelines que fallan con claridad."))
    ((en . "I write my CV in Scheme, version it in git, and let continuous integration publish it whenever I learn something new.")
     (nl . "Ik schrijf mijn cv in Scheme, beheer het in git en laat continuous integration het publiceren zodra ik iets nieuws leer.")
     (es . "Escribo mi cv en Scheme, lo versiono en git y dejo que la integración continua lo publique cada vez que aprendo algo nuevo."))))

(define education
  `(((name (all . "Delft University of Technology"))
     (location (en . "Delft, The Netherlands")
               (nl . "Delft, Nederland")
               (es . "Delft, Países Bajos"))
     (position (en . "MSc Computer Science")
               (nl . "MSc Computerwetenschappen")
               (es . "Máster en Informática"))
     (time (en . "September 2016 => August 2018")
           (nl . "September 2016 => Augustus 2018")
           (es . "Septiembre 2016 => Agosto 2018"))
     (experience ((en . "Specialised in distributed systems; thesis on incremental build graphs for declarative deployments.")
                  (nl . "Gespecialiseerd in gedistribueerde systemen; scriptie over incrementele build-graphs voor declaratieve deployments.")
                  (es . "Especialización en sistemas distribuidos; tesis sobre grafos de build incrementales para despliegues declarativos."))
                 ((all . "Go, Rust, distributed systems, formal verification"))))
    ((name (all . "Hogeschool Leiden"))
     (location (all . "Leiden, The Netherlands"))
     (position (en . "BSc Information Technology")
               (nl . "Bachelor Informatica")
               (es . "Grado en Informática"))
     (time (en . "September 2012 => July 2016")
           (nl . "September 2012 => Juli 2016")
           (es . "Septiembre 2012 => Julio 2016"))
     (experience ((en . "Graduated with honours; built the student association's ticketing system."))
                 ((all . "Java, SQL, GNU/Linux, networking"))))))

(define job-current
  `((name (all . "Northwind Analytics"))
    (location (en . "Amsterdam, The Netherlands")
              (nl . "Amsterdam, Nederland")
              (es . "Ámsterdam, Países Bajos"))
    (position (en . "Platform Engineer")
              (nl . "Platform Engineer")
              (es . "Ingeniera de Plataforma"))
    (time (en . "March 2022 => present")
          (nl . "Maart 2022 => heden")
          (es . "Marzo 2022 => presente"))
    (experience ((en . "Migrated 40 services from hand-managed servers to a GitOps pipeline (<code>Guix</code> + Kubernetes) with reproducible builds and instant rollbacks.")
                 (nl . "Migreerde 40 services van handmatig beheerde servers naar een GitOps-pipeline (<code>Guix</code> + Kubernetes) met reproduceerbare builds en directe rollbacks.")
                 (es . "Migré 40 servicios de servidores gestionados a mano a un pipeline GitOps (<code>Guix</code> + Kubernetes) con builds reproducibles y rollbacks instantáneos."))
                ((en . "Cut build times from 22 minutes to 4 with a content-addressed cache and remote workers."))
                ((en . "Wrote the internal runbook generator that turns incident retrospectives into executable checklists.")))))

(define job-previous
  `((name (all . "Blue Harbour Logistics"))
    (location (en . "Rotterdam, The Netherlands")
              (nl . "Rotterdam, Nederland")
              (es . "Róterdam, Países Bajos"))
    (position (en . "Site Reliability Engineer")
              (nl . "Site Reliability Engineer")
              (es . "Ingeniera de Fiabilidad"))
    (time (en . "June 2018 => February 2022")
          (nl . "Juni 2018 => Februari 2022")
          (es . "Junio 2018 => Febrero 2022"))
    (experience ((en . "Introduced service level objectives and error budgets for a fleet of 120 APIs."))
                ((en . "Automated release notes and changelogs, replacing a weekly manual meeting."))
                ((en . "Reduced cloud spend by 31% by right-sizing instances and deleting orphaned storage.")))))

(define jobs
  (list job-current job-previous))

(define skills
  `(((all . "Guile Scheme"))
    ((all . "Kubernetes"))
    ((all . "Terraform"))
    ((all . "Go"))
    ((all . "PostgreSQL"))
    ((all . "CI/CD"))))
