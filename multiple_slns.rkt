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
          #:preds[satsConstraints
               (boardSetup 4)
               (addConstraint Top ind hnt)]
          #:scope[(Cell 16 16) (Constraint 1 1)])
     (define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

     (define a1 (slnFind-gen))

     (check-eq? (length (hash-ref (first (Sat-instances a1)) 'Cell))
           16)

     (print (first (Sat-instances a1)))
     (is-sat? slnFind)
)


;need to now extract cell values and add constraints to check for no other sln, or maybe just keep hitting "next" until somehow its done

(run-constraint 1 1)


; (stream-ref (forge:Run-result findSource) 0)
