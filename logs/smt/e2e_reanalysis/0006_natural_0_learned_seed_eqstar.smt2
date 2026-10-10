; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x35 (or (and (= p 0) (>= x 0) (<= x 1)) $x21)))
 (let (($x102 (and (and (< (- 1) p) (>= 1 p)) (< (- 4) (- p x)))))
 (let (($x130 (and (and (and $x102 (>= 3 x)) (>= 0 (+ p x))) (< (- 1) x))))
 (let (($x107 (or $x130 (and $x102 (< 3 x)))))
 (xor $x107 $x35))))))))
(check-sat)
