; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x78 (<= p 1)))
 (let (($x63 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x78)))
 (let (($x52 (<= p 0)))
 (let (($x50 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x52)))
 (let (($x126 (or $x50 $x63)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x126)))))))))
(check-sat)
