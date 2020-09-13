#lang racket
;(define git (lambda (comando)
;   (comandoGit comando)
;  )
;)
(define workspacelist(list "WorkSpace"));
(define indexlist(list "Index"))
(define localRepositorylist(list "Local Repository"))
(define remoteRepositorylist(list "Remote Repository"))

;workspacelist
;indexlist
;localRepositorylist
;remoteRepositorylist

(define workspace(lambda (lista)
              (append workspacelist lista))
 )
(define index(lambda (lista)
              (append indexlist (cdr lista)))
 )
;((((git commit) "miCommit") localRepository) (list "1" "2" "3"))
(define localRepository(lambda (mensaje) (lambda (lista)
                                         (append (list mensaje) (cdr lista))
                                           )
                         )
  )
 

(define remoteRepository(lambda (lista)
              (append remoteRepositorylist lista))
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


;(define commit (lambda (mensaje) (lambda(lista)
(define commit (lambda (mensaje) (lambda(lista)
                                 ((localRepository (append remoteRepositorylist mensaje)) lista)
                                   ;(append remoteRepositorylist lista)
                                 )
               )
)

(define (f1 x y)
  (+ (* 2 (expt x 2)) (* 3 y) 1))
(define (f2 x y)
  (+ (* x y) 1))

(define named-functions
  (list (cons add add)
        (cons "two"  f2)
        (cons "three" (lambda (x y) (/ (f1 x y) (f2 x y))))
        (cons commit commit)
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

(write "Se agregan elementos al Workspace\n")
(((git add) (list "file1.rkt" "file2.rkt")) workspace)

(write "Se agregan elementos a Workspace, que son enviados a la zona Index")
;Se agregan elementos a Workspace, que son enviados a la zona Index
(((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index)

(write "Se agregan del Index hacia Local Repository")
(((git commit) "Primer Commit") (((git add) (((git add) (list "file1.rkt" "file2.rkt")) workspace) ) index))

;Ejemplo tomado de los videos campus virtual
(define suma (lambda (a) (lambda(b) (+ a b))))

;(((git commit) "miCommit") localRepository)
;(((git commit) "miCommit") (list "1" "2" "3"))
;