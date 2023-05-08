#lang forge/core

(require (only-in rackunit check-eq? check-not-eq?))


;(set-option! 'solver 'MiniSatProver)
;(set-option! 'logtranslation 1)
;(set-option! 'coregranularity 1)
;(set-option! 'core_minimization 'rce) ; try 'hybrid if slow

(require "skyscraper.rkt")
(require racket/stream)

; single constraint:
#|
(define (run-constraint ind hnt)
     (run slnFind
          #:preds[
               (boardSetup 4)
               (obeysConstraint Top ind hnt)
               ]
          #:scope[(Cell 16 16)])
     (define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

     (define a1 (slnFind-gen))
     (define a2 (slnFind-gen))

     (if (and (Sat? a1) (not (Sat? a2))) (print "SUCCESS") (print "f"))
     (forge:close-run slnFind)
)

(for* ([index (in-range 0 4)]
         [hint (in-range 1 5)])
    (run-constraint index hint))
|#

; two constraints:
#|
(define (run-constraint ind hnt ind2 hnt2)
     (run slnFind
          #:preds[
               (boardSetup 4)
               (obeysConstraint Top ind hnt)
               (obeysConstraint Top ind2 hnt2)
               ]
          #:scope[(Cell 16 16)])
     (define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

     (define a1 (slnFind-gen))
     (define a2 (slnFind-gen))

     (if (and (Sat? a1) (not (Sat? a2))) (print "SUCCESS") (print "f"))
     (forge:close-run slnFind)
)

(for* ([index (in-range 0 4)]
         [hint (in-range 1 5)]
         [index2 (in-range index 4)]
         [hint2 (in-range 1 5)])
    (run-constraint index hint index2 hint2))
|#

#| 

;3 constraints

(define (run-constraint ind hnt ind2 hnt2 ind3 hnt3)
     (run slnFind
          #:preds[
               (boardSetup 4)
               (obeysConstraint Top ind hnt)
               (obeysConstraint Top ind2 hnt2)
               (obeysConstraint Top ind3 hnt3)
               ]
          #:scope[(Cell 16 16)])
     (define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

     (define a1 (slnFind-gen))
     (define a2 (slnFind-gen))

     (if (and (Sat? a1) (not (Sat? a2))) (printf "SUCCESS ~v ~v ~v ~v ~v ~v " ind hnt ind2 hnt2 ind3 hnt3) (print "f"))
     (forge:close-run slnFind)
)

(for* ([hint (in-range 1 5)]
         [hint2 (in-range 1 5)]
         [index3 (in-range 2 4)]
         [hint3 (in-range 1 5)])
    (run-constraint 0 hint 1 hint2 index3 hint3))

|#


;4 constraints:
(define (run-constraint ind hnt ind2 hnt2 ind3 hnt3 ind4 hnt4)
     (run slnFind
          #:preds[
               (boardSetup 4)
               (obeysConstraint Top ind hnt)
               (obeysConstraint Top ind2 hnt2)
               (obeysConstraint Top ind3 hnt3)
               (obeysConstraint Top ind4 hnt4)

               ]
          #:scope[(Cell 16 16)])
     (define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

     (define a1 (slnFind-gen))
     (define a2 (slnFind-gen))

     (if (and (Sat? a1) (not (Sat? a2))) (printf "SUCCESS ~v ~v ~v ~v ~v ~v ~v ~v" ind hnt ind2 hnt2 ind3 hnt3 ind4 hnt4) (printf "f ~v" hnt))
     (forge:close-run slnFind)
)

(for* (
         [hint (in-range 1 5)]
         [hint2 (in-range 1 5)]
         [hint3 (in-range 1 5)]
         [hint4 (in-range 1 5)])
    (run-constraint 0 hint 1 hint2 2 hint3 3 hint4))

;(run-constraint 0 0)
