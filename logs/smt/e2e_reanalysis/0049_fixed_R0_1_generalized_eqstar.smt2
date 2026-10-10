; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x35 (or (and (= p 0) (>= x 0) (<= x 1)) $x21)))
 (let (($x78 (and (and (<= (- (+ p x)) (- 4)) (>= 1 p)) (>= 3 (- (- p x))))))
 (let (($x55 (and (and (>= 1 (+ p x)) (>= 0 (- p x))) (>= 0 (- p)))))
 (let (($x103 (or $x55 $x78)))
 (xor $x103 $x35))))))))
(check-sat)
