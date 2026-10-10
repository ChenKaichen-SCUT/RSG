; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x22 (or (and (= p 0) (>= x 0) (<= x 2)) $x21)))
 (let (($x46 (or (and (and (= 0 p) (<= 0 x)) (>= 2 x)) (and (and (= 1 p) (<= 3 x)) (>= 4 x)))))
 (xor $x46 $x22))))))
(check-sat)
