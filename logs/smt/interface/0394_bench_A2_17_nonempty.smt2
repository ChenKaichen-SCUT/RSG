; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x54 (<= p 0)))
 (let (($x49 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x54)))
 (let (($x95 (<= p 1)))
 (let (($x70 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x95)))
 (or $x70 $x49))))))
(check-sat)
