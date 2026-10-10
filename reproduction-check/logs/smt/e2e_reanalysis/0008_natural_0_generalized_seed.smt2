; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x126 (and (and (>= 3 (- (- p x))) (>= 1 p)) (<= (- x) (- 4)))))
 (let (($x118 (and (and (>= 0 (- x)) (>= 0 (+ p x))) (>= 0 (- p)))))
 (let (($x127 (or $x118 $x126)))
 (let (($x102 (and (and (< (- 1) p) (>= 1 p)) (< (- 4) (- p x)))))
 (let (($x130 (and (and (and $x102 (>= 3 x)) (>= 0 (+ p x))) (< (- 1) x))))
 (let (($x107 (or $x130 (and $x102 (< 3 x)))))
 (and $x107 (not $x127)))))))))
(check-sat)
