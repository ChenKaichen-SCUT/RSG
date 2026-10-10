; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x10 (= p 0)))
 (let (($x29 (and $x10 (= x 0))))
 (let (($x20 (<= x 4)))
 (let (($x104 (<= p 1)))
 (let (($x97 (and $x104 (<= (- p) (- 1)) $x20 (<= (- x) (- 4)))))
 (or $x97 $x29)))))))
(check-sat)
