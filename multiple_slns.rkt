#lang forge/core

(require (only-in rackunit check-eq? check-not-eq?))


;(set-option! 'solver 'MiniSatProver)
;(set-option! 'logtranslation 1)
;(set-option! 'coregranularity 1)
;(set-option! 'core_minimization 'rce) ; try 'hybrid if slow

(require "skyscraper.rkt")
(require racket/stream)

(run slnFind
     #:preds[(all ([c Constraint])
                   (obeysConstraint c))
             boardConstraints
             boardSetup]
     #:scope[(Cell 16 16) (Constraint 2 2)])

(define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

(define a1 (slnFind-gen))

(check-eq? (length (hash-ref (first (Sat-instances a1)) 'Cell))
           16)
;need to now extract cell values and add constraints to check for no other sln 




; (stream-ref (forge:Run-result findSource) 0)
(is-sat? slnFind)
