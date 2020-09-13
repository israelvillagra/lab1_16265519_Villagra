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
                          ;(append remoteRepositorylist (cdr (second lista)))
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
                                         ;(append mensaje lista)
                                          (append listaOrigen lista)
                                           )
                         )
  )

(define commit(lambda (mensaje) (lambda(lista)
                                  ;(list remoteRepositorylist (list mensaje (cdr lista)) )
                                  ((localRepository remoteRepositorylist)(list (append (list mensaje) (cdr lista))))
                                  ;(localRepository (append remoteRepositorylist mensaje)) lista)
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

(define (f1 x y)
  (+ (* 2 (expt x 2)) (* 3 y) 1))
(define (f2 x y)
  (+ (* x y) 1))

(define named-functions
  (list (cons add add)
        (cons pull pull)
        (cons "three" (lambda (x y) (/ (f1 x y) (f2 x y))))
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

(write "Se agregan elementos al Workspace")
(((git add) (list "file1.rkt" "file2.rkt" "file3.rkt" "file4.rkt")) workspace)

(write "Se agregan elementos a Workspace, que son enviados a la zona Index")
;Se agregan elementos a Workspace, que son enviados a la zona Index
(((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index)

(write "Se agregan del Index hacia Local Repository")
(((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index))

(write "Se ingresan todos los elementos dentro de la Zona de trabajo Local Repository a Remote Repository")
((git push) (((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index)))

;Ejemplo tomado de los videos campus virtual
(define suma (lambda (a) (lambda(b) (+ a b))))

(((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index))