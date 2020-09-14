#lang racket
;(define git (lambda (comando)
;   (comandoGit comando)
;  )
;)
(define workspacelist(list "WorkSpace"));
(define indexlist(list "Index"))
(define localRepositorylist(list "Local Repository"))
(define remoteRepositorylist(list "Remote Repository"))

workspacelist
indexlist
localRepositorylist
remoteRepositorylist

(define workspace(lambda (lista)
              (append workspacelist lista))
 )
(define index(lambda (lista)
              (append indexlist (cdr lista)))
 )


(define remoteRepository(lambda (lista)
                          (append remoteRepositorylist (cdr (second lista)))
                          )
 )

(define add(lambda (lista) (lambda (zona)
                                (if (null? lista)
                                    "Lista Nula"
                                    (if (list? lista)
                                        (if (null? zona)
                                            "Zona Nula"
                                            ((AddZone zona) lista) ;
                                        )
                                        null
                                    )
                                )
                            )
             )
)

(define localRepository(lambda (listaOrigen) (lambda (lista)
                                          (append listaOrigen lista)
                                           )
                         )
  )

(define commit(lambda (mensaje) (lambda(lista)
                                  ((localRepository localRepositorylist)(list (append (list mensaje) (cdr lista))))
                                  )
                )
  )

(define push(lambda(lista)
               ((AddZone remoteRepository) lista)                
              )
)

(define pull(lambda(lista)
               ((AddZone remoteRepository) lista)                
              )
)

(define named-functions
  (list (cons add add)
        (cons pull pull)
        (cons commit commit)
        (cons push push)
        
  )
)

(define (git name)
  (let ((p (assoc name named-functions)))
    (if p
        (cdr p)
        (error "Función no encontrada"))))


(define ZoneNamed-functions
  (list (cons workspace workspace)
        (cons index  index)
        (cons localRepository localRepository)
        (cons remoteRepository remoteRepository)
  )
)

(define (AddZone name)
  (let ((p (assoc name ZoneNamed-functions)))
    (if p
        (cdr p)
        (error "Función no encontrada"))))


(define (workspace->string lista)
              ;(list "\n" lista "\n")
  (list (list "Achivos en" (car lista)) ":\n" (string-join (cdr lista) "\n") "\n")
)

(define (index->string lista)
               (list (list "Achivos en" (car lista)) ":\n" (string-join (cdr lista) "\n") "\n")
)



;****************************************************************************************************
(define (localRepsitory->String zona)
   (list "Archivos en" (car zona) ":\n" (map firstFile (rest zona)));(firstFile (rest zona)); (last zona))
)

(define (firstFile lista)
  (if (empty? lista) "123"
      (if (list? lista) (string-join lista "\n") "\n")
   )
  )
  
 ;****************************************************************************************************


(define (remoteRepository->String zona)
               (list (list "Achivos en" (car zona)) ":\n" (string-join (cdr zona) "\n"))
              ;(list (list "Achivos en" (car zona)) ":\n" (string-join (cdr zona) "\n"))
)

(define zonasString
  (list (cons workspace workspace->string)
        (cons index  index->string)
        (cons localRepository localRepsitory->String)
        (cons remoteRepository remoteRepository->String)
  )
)

(define (zonas->string name)
  (let ((p (assoc name zonasString)))
    (if p
        (cdr p)
        (error "Función no encontrada")))
)
(define (Anotherlist->string slst)
  (cond ((empty? slst) "")
        ((empty? (rest slst))
         (symbol->string (first slst))
         )
        (else (string-append (symbol->string (first slst))
                             " "
                             (Anotherlist->string (rest slst))))))

(define (slist->string slst)
  (cond ((empty? slst) "")
        ((empty? (rest slst)) (symbol->string (first slst)))
        (else (string-append (symbol->string (first slst))
                             " "
                             (slist->string (rest slst))))))

;((name->function "three") 4 5)
;((git add) 4)
;(((git add) (list “file1.rkt” “file2.rkt”)) zonas)
;((git add) (list "file1.rkt" "file2.rkt"))
;(((git add) (list "file1.rkt" "file2.rkt")) 0)

;Validaciones
;(((git add1) (list "file1.rkt" "file2.rkt")) null) ; Función no encontrada
;(((git add) null) 0) ; Lista Nula
;(((git add) (list "file1.rkt" "file2.rkt")) null) ; Zona Nula

;(((git add) (list "file1.rkt" "file2.rkt")) workspace) ; Ingresa elementos a Workspace
;(((git add) (list "file1.rkt" "file2.rkt")) index) ; Ingresa elementos a Index
;(((git add) (list "file1.rkt" "file2.rkt")) localRepository) ; Ingresa elementos a LocalRepository
;(((git add) (list "file1.rkt" "file2.rkt")) remoteRepository) ; Ingresa elementos a RemoteRepository

; Se agregan elementos en workSpace
(((git add) (list "file1.rkt" "file2.rkt" "file3.rkt" "file4.rkt")) workspace)

;Se agregan elementos a Workspace, que son enviados a la zona Index
(((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index)

;Se agregan del Index hacia Local Repository
(((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index))

;Se ingresan todos los elementos dentro de la Zona de trabajo Local Repository a Remote Repository
((git push) (((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index)))

;Ejemplo tomado de los videos campus virtual
(define suma (lambda (a) (lambda(b) (+ a b))))

(display "***********Resumen Workspace***********\n")
(display (
           (zonas->string workspace)
(((git add) (list "file1.rkt" "file2.rkt" "file3.rkt" "file4.rkt")) workspace)))

(display "\n***********Resumen Index***********\n")
(display (
           (zonas->string index)
           (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index)
           )
         )

(display "\n***********Resumen Local Repository***********\n")
(display (
           (zonas->string localRepository)
;           (((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index))
(append
(((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index))
(((git commit) "Segundo Commit") (((git add) (((git add) (list "file3.rkt" "file4.rkt")) workspace) ) index))
)
         )
)

(display "\n***********Resumen Remote Repository***********\n")
;"Elementos Dentro de Remote Repository"
(display (
           (zonas->string remoteRepository)
           ((git push) (((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index)))
           )
)


;(define strlist (list "red" "yellow" "blue" "green"))
;(display (string-join strlist "\n "))
;(slist->string '(red yellow blue green))


;(define my-list '(a big dog))

;; the easy way (has parens):
;(~a my-list)

;; slightly harder
;(display (string-join (map ~a my-list) "'\n' "))


;(define s (string-append "exa " "\n" " mple"))
;(display s)

