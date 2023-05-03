#lang racket

(define (permutations-no-reversed-copies lst)
  (cond
    [(null? lst) empty]
    [(null? (cdr lst)) lst]
    [else
     (let ([head (car lst)]
           [tail (cdr lst)])
       (append (map (lambda (x) (cons head x))
                    (filter (lambda (x) (not (equal? (reverse x) x)))
                            (permutations-no-reversed-copies tail)))
               (permutations-no-reversed-copies tail)))]))

(print (permutations-no-reversed-copies '(0 1 2 3)))
