; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x22 (or (and (= p 0) (>= x 0) (<= x 2)) $x21)))
 (let (($x39 (= x 3)))
 (let (($x10 (= p 0)))
 (and $x10 $x39 $x22)))))))
(check-sat)
