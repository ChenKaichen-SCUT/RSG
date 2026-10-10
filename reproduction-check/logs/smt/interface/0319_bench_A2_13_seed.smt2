; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x143 (<= p 0)))
 (let (($x129 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x143)))
 (let (($x116 (<= p 1)))
 (let (($x113 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x116)))
 (let (($x54 (or $x113 $x129)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x54)))))))))
(check-sat)
