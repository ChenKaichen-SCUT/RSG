; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x20 (<= x 4)))
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) $x20)))
 (let (($x35 (or (and (= p 0) (>= x 0) (<= x 1)) $x21)))
 (let (($x32 (or (and (= p 0) (= x 0)) (and $x16 (= x 4)))))
 (xor $x32 $x35)))))))
(check-sat)
