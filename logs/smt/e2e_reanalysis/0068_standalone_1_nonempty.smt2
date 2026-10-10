; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x98 (>= 1 p)))
 (let (($x193 (and (and (and (<= (- p x) (- 2)) (<= (- p) (- 1))) $x98) (>= 3 (- (- p x))))))
 (let ((?x124 (- x)))
 (let (($x122 (>= 0 ?x124)))
 (let (($x103 (and (and (and (>= 1 x) (>= 0 p)) (>= 0 (- p))) $x122)))
 (or $x103 $x193)))))))
(check-sat)
