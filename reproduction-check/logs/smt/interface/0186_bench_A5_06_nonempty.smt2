; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x130 (<= p 1)))
 (let (($x110 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x130)))
 (let (($x77 (<= p 0)))
 (let (($x139 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x77)))
 (or $x139 $x110))))))
(check-sat)
