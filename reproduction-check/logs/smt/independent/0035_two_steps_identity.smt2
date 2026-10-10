; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (or (and (distinct (- 1 (- 1 p)) p) true) (and (distinct (- 4 (- 4 x)) x) true)))
(check-sat)
