#lang racket
;Lista de Zonas de Trabajo
(define workspacelist(list "WorkSpace"));
(define indexlist(list "Index"))
(define localRepositorylist(list "Local Repository"))
(define remoteRepositorylist(list "Remote Repository"))

;Despliegue de las Zonas de Trabajo
workspacelist
indexlist
localRepositorylist
remoteRepositorylist

;Descripción: Agrega a la lista los nuevos archivos a la zona de trabajo workspace
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define workspace(lambda (lista)
              (append workspacelist lista))
 )

;Descripción: Agrega a la lista los nuevos archivos a la zona de trabajo index
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define index(lambda (lista)
              (append indexlist (cdr lista)))
 )

;Descripción: Agrega a la lista los nuevos archivos a la zona de trabajo remoteRepository
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define remoteRepository(lambda (lista)
                          (append remoteRepositorylist (cdr (second lista)))
                          )
 )

;Descripción: Agrega a la lista los nuevos archivos a la zona de trabajo localRepository
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define localRepository(lambda (listaOrigen) (lambda (lista)
                                          (append listaOrigen lista)
                                           )
                         )
  )

;Descripción: Función donde se filtran los tipos de operaciones a ejecutar, recibiendo como parametro al función
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
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


;Descripción: Agrega a la lista los nuevos archivos a la zona de trabajo localRepository informano un mensaje
;Recursión: Sin recursión
;Dominio :  Lista X Lista | Mensaje
;Recorrido : Lista
(define commit(lambda (mensaje) (lambda(lista)
                                  ((localRepository localRepositorylist)(list (append (list mensaje) (cdr lista)))); crea una lista con los archivos, ademas de incluir un mensaje.
                                  )
                )
  )

;Descripción: Agrega a la lista los nuevos archivos a la zona de trabajo Remote Repository
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define push(lambda(lista)
               ((AddZone remoteRepository) lista)                
              )
)

;Descripción: Copia los archivos de la zona de trabajo Remote Repository hacia workSpace: No implementado
;Recursión: Sin recursión
;Dominio :  Lista X Lista | Mensaje
;Recorrido : Lista
(define pull(lambda(lista)
               ((AddZone remoteRepository) lista)                
              )
)

;Descripción: Registra los tipos de operación y las ejecuta segpun sea requerido, en este caso de trabaja sobre las operaciones básicas de movimiento de archivos
;Recursión: Sin recursión
;Dominio :  Lista X Lista | Mensaje
;Recorrido : Lista
(define named-functions
  (list (cons add add); Registro de las operaciones de movimiento de archivos.
        (cons pull pull)
        (cons commit commit)
        (cons push push)
        
  )
)

;Descripción: Obtiene el tipo de comando, lo interpreta y envía la eecución al listado que se encuentra arriba mencionado
;Recursión: Sin recursión
;Dominio :  Lista X Lista | Mensaje
;Recorrido : Lista
(define (git name)
  (let ((p (assoc name named-functions)))
    (if p
        (cdr p)
        (error "Función no encontrada"))))

;Descripción: Se registra las tipo de funciones para realizar el trabajo de copia de archivos que son utilizados en la siguiente función declarada
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define ZoneNamed-functions
  (list (cons workspace workspace)
        (cons index  index)
        (cons localRepository localRepository)
        (cons remoteRepository remoteRepository)
  )
)

;Descripción: Función donde se registran las operaciones que realizarán en la función siguiente declarada anteriormente
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define (AddZone name)
  (let ((p (assoc name ZoneNamed-functions)))
    (if p
        (cdr p)
        (error "Función no encontrada"))))

;Descripción: Función que retorna la lista de elementos que se contiene en la zona de trabajo workspace
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define (workspace->string lista)
              ;(list "\n" lista "\n")
  (list (list "Achivos en" (car lista)) ":\n" (string-join (cdr lista) "\n") "\n")
)

(define (index->string lista)
               (list (list "Achivos en" (car lista)) ":\n" (string-join (cdr lista) "\n") "\n")
)

;****************************************************************************************************
;Descripción: Función que retorna la lista de elementos que se contiene en la zona de trabajo localRepsitory para ser desplegados
;Recursión: recursión de cola.
;Dominio :  Lista X Lista
;Recorrido : Lista
(define (localRepsitory->String zona)
   (list "Archivos en" (car zona) ":\n" (map firstFile (rest zona)))
)

;Descripción: Función especial para recorrer las lista de archvos que se encuentra que son enviados en la zona de trabajo localRepository
;Recursión: recursión de cola.
;Dominio :  Lista X Lista
;Recorrido : Lista
(define (firstFile lista)
  (if (empty? lista) ""
      (if (list? lista) (string-join lista "\n") "\n");Procesa la el primer elemento de la lista y concatena los siguientes.
   )
  )
 ;****************************************************************************************************

;Descripción: Función que recibe los elementos de la zona de trabajo y los concatena para ser desplegados al usuario
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define (remoteRepository->String zona)
               (list (list "Achivos en" (car zona)) ":\n" (string-join (cdr zona) "\n"))
)

;Descripción: Función donde se definen las funcionalidades para entregar información que sea visible comodamente por el usuario
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define zonasString
  (list (cons workspace workspace->string)
        (cons index  index->string)
        (cons localRepository localRepsitory->String)
        (cons remoteRepository remoteRepository->String)
  )
)

;Descripción: Función que ocupa la lista declarada arriba para identificar la funcionalidad a desplegar
;Recursión: Sin recursión
;Dominio :  Lista X Lista
;Recorrido : Lista
(define (zonas->string name)
  (let ((p (assoc name zonasString)))
    (if p
        (cdr p)
        (error "Función no encontrada")))
)

;Descripción: Función permite agregar el valor de separación ocupada para mostrar al usuario los saltos de linea
;Recursión: recursión natural
;Dominio :  Lista X Lista
;Recorrido : Lista
(define (slist->string slst)
  (cond ((empty? slst) "")
        ((empty? (rest slst)) (symbol->string (first slst)))
        (else (string-append (symbol->string (first slst))
                             " "
                             (slist->string (rest slst))))))

;****************************Ejemplos de Uso****************************

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

;Se agregan dos commits para probar que despliega todos los elementos.
(display "\n***********Resumen Local Repository***********\n")
(display (
           (zonas->string localRepository)
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
