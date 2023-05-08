#lang forge/core

(require (only-in rackunit check-eq? check-not-eq?))


;(set-option! 'solver 'MiniSatProver)
;(set-option! 'logtranslation 1)
;(set-option! 'coregranularity 1)
;(set-option! 'core_minimization 'rce) ; try 'hybrid if slow

(require "skyscraper_alt_constraintsV2.rkt")
(require racket/stream)

; single constraint:

(define (run-constraint rw cl h1 h2 h3 h4)
     (run slnFind
          #:preds[
               (boardSetup 4)
               (obeysInteriorConstraint Top h1 rw cl)
               (obeysInteriorConstraint Bot h2 rw cl)
               (obeysInteriorConstraint Lft h3 rw cl)
               (obeysInteriorConstraint Rgt h4 rw cl)
               ]
          #:scope[(Cell 16 16)])
     (define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

     (define a1 (slnFind-gen))
     (define a2 (slnFind-gen))

     (if (and (Sat? a1) (not (Sat? a2))) (print "SUCCESS ~v ~v ~v ~v ~v ~v" rw cl h1 h2 h3 h4) (print "f"))
     (forge:close-run slnFind)
)

(for* ([r (in-range 0 2)]
          [c (in-range 0 2)]
         [h1 (in-range 1 5)]
         [h2 (in-range h1 5)]
         [h3 (in-range 1 5)]
         [h4 (in-range h3 5)])
    (run-constraint r c h1 h2 h3 h4))

;(run-constraint 1 1 1 1 1 1)
