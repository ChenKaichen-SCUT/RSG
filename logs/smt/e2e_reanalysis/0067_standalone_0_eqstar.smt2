; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x35 (or (and (= p 0) (>= x 0) (<= x 1)) $x21)))
 (let (($x204 (and (and (and (>= 1 p) (< (- 1) p)) (< 0 p)) (<= (- p x) (- 2)))))
 (let (($x95 (>= 1 x)))
 (let (($x39 (and (and (and (>= 1 p) (< (- 1) p)) (>= 0 p)) $x95)))
 (let (($x135 (or (and $x39 (< (- 1) x)) (and $x204 (< (- 4) (- p x))))))
 (xor $x135 $x35)))))))))
(check-sat)
