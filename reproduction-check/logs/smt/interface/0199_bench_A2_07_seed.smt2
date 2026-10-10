; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x110 (<= p 0)))
 (let (($x108 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x110)))
 (let (($x127 (<= p 1)))
 (let (($x49 (and (and (and (<= x 4) (<= (- p) (- 1))) (<= (- x) (- 4))) $x127)))
 (let (($x41 (or $x49 $x108)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x41)))))))))
(check-sat)
