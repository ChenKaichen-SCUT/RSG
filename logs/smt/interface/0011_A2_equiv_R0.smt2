; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (let (($x51 (<= p 0)))
 (let (($x52 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x51)))
 (let (($x44 (<= p 1)))
 (let (($x45 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x44)))
 (let (($x53 (or $x45 $x52)))
 (xor $x53 $x32))))))))
(check-sat)
