#lang forge/core

(require (only-in rackunit check-eq? check-not-eq?))


;(set-option! 'solver 'MiniSatProver)
;(set-option! 'logtranslation 1)
;(set-option! 'coregranularity 1)
;(set-option! 'core_minimization 'rce) ; try 'hybrid if slow

(require "skyscraper.rkt")
(require racket/stream)

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
         [hint (in-range 0 4)])
    (run-constraint index hint))

;(run-constraint 0 0)