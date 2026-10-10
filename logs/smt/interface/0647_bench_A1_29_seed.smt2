; benchmark generated from python API
(set-info :status unknown)
(declare-fun p () Int)
(declare-fun x () Int)
(assert
 (let (($x48 (<= p 1)))
 (let (($x103 (and (and (and (<= (- x) (- 4)) (<= x 4)) (<= (- p) (- 1))) $x48)))
 (let (($x58 (<= p 0)))
 (let (($x57 (and (and (and (<= x 0) (<= (- p) 0)) (<= (- x) 0)) $x58)))
 (let (($x115 (or $x57 $x103)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))))
 (and $x32 (not $x115)))))))))
(check-sat)
