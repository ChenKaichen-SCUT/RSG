; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x95 (<= p 1)))
 (let (($x59 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x95)))
 (let (($x54 (<= p 0)))
 (let (($x49 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x54)))
 (or $x49 $x59))))))
(check-sat)
