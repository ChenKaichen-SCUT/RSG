; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (or (and (= p 0) (= x 1)) (and (= p 1) (= x 3))))
(check-sat)
