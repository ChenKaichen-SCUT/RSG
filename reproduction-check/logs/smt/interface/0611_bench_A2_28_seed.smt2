; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x134 (<= p 0)))
 (let (($x104 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x134)))
 (let (($x40 (<= p 1)))
 (let (($x127 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x40)))
 (let (($x58 (or $x127 $x104)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x58)))))))))
(check-sat)
