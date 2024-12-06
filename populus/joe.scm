
(define iter-vitae-display-name `((all . "Josep Bigorra")))
(define iter-vitae-job-title `((all . "Software Engineer")))

(define iter-vitae-personal-contact
  `((emails . ("jjbigorra@gmail.com"))
    (phone-numbers . ("+31 639825138"))))

(define iter-vitae-personal-links
  `((blogs . ("jointhefreeworld.org"))
    (code . ("codeberg.org/jjba23"))
    (linkedin . ("linkedin.com/in/josepjba"))))

(define iter-vitae-address-lines
  `(((all . "1441KH Purmerend"))
    ((all . "Netherlands"))))

(define iter-vitae-driver-license
  `(((en . "B driver's license, vehicles up to 3,5t")
     (nl . "Rijbewijs B, voertuigen t/m 3,5t"))))

(define iter-vitae-interests-hobbies
  `(((en . "I love playing classical and electric guitar.")
     (nl . "Ik ben dol op klassieke en elektrische gitaar."))
    ((en . "I like building and tweaking computers, blogging about my tech opinions and discoveries and playing strategy games sometimes.")
     (nl . "Ik bouw en speel graag met computers, ik heb een blog waar ik mijn meningen over technologie en andere uit, en soms speel ik strategie spelletjes."))
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
    (ca . ((name . ((en . "Catalan")
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
      `(((entity-name . ((all . "Universidade do Algarve, Faro, Portugal")))
         (position-name . ((en . "IT Associate's degree")
                           (nl . "ICT HBO")))
         (time-worked . ((en . "September 2017 => September 2019")
                         (nl . "September 2017 => September 2019")))
         (experience-points . (((en . "Graduated with 190/200 score. Obtained maximum score for software engineering internship.")
                                (nl . "Afgestudeerd met 190/200 score. Max cijfer gehaald voor software ingenieur stage."))
                               ((all . "Java, PHP, SQL, Javascript, GNU/Linux, Excel, Alfresco BPM"))))
         
         )))

(define iter-vitae-font 'intel-one-mono)
(define iter-vitae-palette 'ef-cyprus)

(define iter-vitae-titles
  `((education . ((en . "Education") (nl . "Opledingen")))
    (driver-license . ((en . "Driving") (nl . "Rijbewijs")))
    (interests-hobbies . ((en . "My free time") (nl . "Mijn vrije tijd")))
    (language . ((en . "Languages") (nl . "Taalvardigheden")))
    (my-links . ((en . "Me on the Internet") (nl . "Ik op Internet")))
    (short-intro . ((en . "Who am I ?") (nl . "Wie ben ik ?")))
    ))
