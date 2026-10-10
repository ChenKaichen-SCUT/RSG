; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (let (($x102 (and (and (< (- 1) p) (>= 1 p)) (< (- 4) (- p x)))))
 (let (($x130 (and (and (and $x102 (>= 3 x)) (>= 0 (+ p x))) (< (- 1) x))))
 (let (($x107 (or $x130 (and $x102 (< 3 x)))))
 (xor $x107 $x32))))))
(check-sat)
