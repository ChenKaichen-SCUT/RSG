; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x115 (<= p 1)))
 (let (($x145 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x115)))
 (let (($x81 (<= p 0)))
 (let (($x38 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x81)))
 (let (($x65 (or $x38 $x145)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x65)))))))))
(check-sat)
