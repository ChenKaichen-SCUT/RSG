; benchmark generated from python API
(set-info :status unknown)
(declare-fun x () Int)
(declare-fun p () Int)
(assert
 (let (($x16 (= p 1)))
 (let (($x21 (and $x16 (>= x 3) (<= x 4))))
 (let (($x35 (or (and (= p 0) (>= x 0) (<= x 1)) $x21)))
 (let (($x186 (or (and (and (distinct 0 p) true) (and (distinct 1 p) true)) (and (and (distinct 0 p) true) (and (distinct 4 x) true)))))
 (let (($x63 (or (or $x186 (and (and (distinct 1 p) true) (and (distinct 0 x) true))) (and (and (distinct 0 x) true) (and (distinct 4 x) true)))))
 (let (($x76 (or (or (< 1 p) (> 4 (+ p x))) (< (- p x) (- 3)))))
 (let (($x69 (and (or (or (> p x) (> 0 p)) (< 1 (+ p x))) $x76)))
 (xor (and $x69 $x63) (not $x35))))))))))
(check-sat)
