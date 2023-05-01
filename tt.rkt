#lang forge/core

(require (only-in rackunit check-eq? check-not-eq?))


;(set-option! 'solver 'MiniSatProver)
;(set-option! 'logtranslation 1)
;(set-option! 'coregranularity 1)
;(set-option! 'core_minimization 'rce) ; try 'hybrid if slow

(require "sp.rkt")
(require racket/stream)

(run slnFind
     #:preds[valid]
     #:scope[])

(define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

(define a1 (slnFind-gen))

(check-eq? (length (hash-ref (first (Sat-instances a1)) 'N))
           1)

(print (hash-ref (first (Sat-instances a1)) 'n))

;need to now extract cell values and add constraints to check for no other sln, or maybe just keep hitting "next" until somehow its done

(print (length (Sat-instances a1)))

(define a2 (slnFind-gen))

(print (length (Sat-instances a2)))

(print (hash-ref (first (Sat-instances a2)) 'n))



; (stream-ref (forge:Run-result findSource) 0)
(is-sat? slnFind)
