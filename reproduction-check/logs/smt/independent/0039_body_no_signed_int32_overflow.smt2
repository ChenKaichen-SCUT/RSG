; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x45 (or (< (- 1 p) (- 2147483648)) (> (- 1 p) 2147483647) (< (- 4 x) (- 2147483648)) (> (- 4 x) 2147483647))))
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x22 (or (and (= p 0) (>= x 0) (<= x 2)) $x21)))
 (and $x22 $x45))))))
(check-sat)
