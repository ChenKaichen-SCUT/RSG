; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x58 (<= p 0)))
 (let (($x57 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x58)))
 (let (($x48 (<= p 1)))
 (let (($x52 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x48)))
 (or $x52 $x57))))))
(check-sat)
