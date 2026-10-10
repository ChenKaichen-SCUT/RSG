; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x129 (<= p 0)))
 (let (($x54 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x129)))
 (let (($x101 (<= p 1)))
 (let (($x107 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x101)))
 (let (($x102 (or $x107 $x54)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x102)))))))))
(check-sat)
