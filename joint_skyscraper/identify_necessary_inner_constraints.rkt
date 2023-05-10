#lang forge/core

; Program to find which inner constraints are necessarily true for any solution to a puzzle with the wall constraints specified below:
;(obeysWallConstraint Top 3 1)
;(obeysWallConstraint Lft 1 3)
;(obeysWallConstraint Bot 0 1)

; The long and ill-formatted statment on line 41 checks to see if it is possible to solve the above puzzle while simultaneously not solving a particular interior constraint (the interior constraints were scraped by hand from a solution to the above puzzle). See "necessary_inners.txt" for the output.


(require (only-in rackunit check-eq? check-not-eq?))

;(set-option! 'solver 'MiniSatProver)
;(set-option! 'logtranslation 1)
;(set-option! 'coregranularity 1)
;(set-option! 'core_minimization 'rce) ; try 'hybrid if slow

(require "skyscraper_alt_constraintsV2.rkt")
(require racket/stream)

; single constraint:

(define (run-constraint w h r c)
     (run slnFind
          #:preds[
               (boardSetup 4)
               (obeysWallConstraint Top 3 1)
               (obeysWallConstraint Lft 1 3)
               (obeysWallConstraint Bot 0 1)
               (notObeysInteriorConstraint w h r c)
               ]
          #:scope[(Cell 16 16)])
     (define slnFind-gen (forge:make-model-generator (forge:get-result slnFind) 'next))

     (define a1 (slnFind-gen))

     (if (Sat? a1) (print "f") (printf "SUCCESS ~v ~v ~v ~v" w h r c))
     (forge:close-run slnFind)
)

(map (lambda (x y) (apply run-constraint x y)) (list Lft
Lft
Lft
Lft
Lft
Lft
Lft
Lft
Rgt
Rgt
Rgt
Rgt
Rgt
Rgt
Rgt
Rgt
Top
Top
Top
Top
Top
Top
Top
Top
Bot
Bot
Bot
Bot
Bot
Bot
Bot
Bot) 
(list 
(list 2 0 1)
(list 1 0 2)
(list 2 1 1)
(list 2 1 2)
(list 1 2 1)
(list 2 2 2)
(list 2 3 1)
(list 1 3 2)
(list 2 0 1)
(list 1 0 2)
(list 1 1 1)
(list 2 1 2)
(list 1 2 1)
(list 2 2 2)
(list 2 3 1)
(list 1 3 2)
(list 3 1 0)
(list 2 1 1)
(list 2 1 2)
(list 1 1 3)
(list 2 2 0)
(list 1 2 1)
(list 2 2 2)
(list 1 2 3)
(list 2 1 0)
(list 1 1 1)
(list 2 1 2)
(list 1 1 3)
(list 1 2 0)
(list 1 2 1)
(list 3 2 2)
(list 2 2 3)
))

#|
    

top 1 3
left 1 3
bot 0 1

inners:
looking right
2 1
2 2
1 2
2 1

looking left
2 1
1 2
1 2
2 1

looking down
3 2 2 1
2 1 2 1

looking up
2 1 2 1
1 1 3 2





|#

