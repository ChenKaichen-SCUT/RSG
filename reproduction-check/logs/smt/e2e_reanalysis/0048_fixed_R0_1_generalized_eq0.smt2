; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (let (($x78 (and (and (<= (- (+ p x)) (- 4)) (>= 1 p)) (>= 3 (- (- p x))))))
 (let (($x55 (and (and (>= 1 (+ p x)) (>= 0 (- p x))) (>= 0 (- p)))))
 (let (($x103 (or $x55 $x78)))
 (xor $x103 $x32))))))
(check-sat)
