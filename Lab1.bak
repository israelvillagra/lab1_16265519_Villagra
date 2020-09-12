#lang racket
(define git (lambda (comando)
   (comandoGit comando)
  )
)
(define comandoGit(lambda (comando)
    (if (string? "add") "Add"
      "Another")
    )
)

(define add(lambda (comando)
  (if (list? comando) 2 ;Verdadero
             3);Falso
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
        (cons "plus"  +)))

(define (Git2 name)
  (let ((p (assoc name named-functions)))
    (if p
        (cdr p)
        (error "Function not found"))))

;((name->function "three") 4 5)
