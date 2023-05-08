# skyscraper
Skyscraper Puzzle Solver

We were most curious about the relationship between skyscraper puzzle constraints and the kinds of boards that can be created to solve those constraints. 

initially thought "unique board" would be unfeasible -> found it would be possible w forge as rkt lib

tradeoffs -> constraint as a sig was cool bc could have forge generate constraints for us, but was bad for unqiueness of solutions (would sometimes make identical board situatiosn but with constraint sig renamed)
-> size of board was a huge limiting factor and search space -> for searchign for unique boards we had to use math to narrow down the space such that it was feasible to work with (still room for improvement here)

limits -> size of board is constraint, can handle 6x6 but for testing etc gets extreme, settled on 4x4 as it is large enough to be interesting but still small

instance -> you can use our setup to input your own constraints, use the viz script to view the board and hints, can click next to find other valid solutions if any

You should write a one page README describing how you structured your model and what your model proved. You can assume that anyone reading it will be familiar with your project proposal. Here are some examples of points you might cover:

What tradeoffs did you make in choosing your representation? What else did you try that didn’t work as well?
What assumptions did you make about scope? What are the limits of your model?
Did your goals change at all from your proposal? Did you realize anything you planned was unrealistic, or that anything you thought was unrealistic was doable?
How should we understand an instance of your model and what your custom visualization shows?
