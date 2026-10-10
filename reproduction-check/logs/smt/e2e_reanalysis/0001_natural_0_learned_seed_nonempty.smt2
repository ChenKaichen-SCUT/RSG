; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x102 (and (and (< (- 1) p) (>= 1 p)) (< (- 4) (- p x)))))
 (let (($x130 (and (and (and $x102 (>= 3 x)) (>= 0 (+ p x))) (< (- 1) x))))
 (or $x130 (and $x102 (< 3 x))))))
(check-sat)
