;; Clarity Basics 
;; Day 3 - Learning Booleans & Read-only

(define-read-only (show-true-i)
    true
)

(define-read-only (show-false-i)
    false
)

(define-read-only (show-false-ii)
    (not true)
)

(define-read-only (show-true-ii)
    (not false)
)

;; Day4 - Simple Operators

(define-read-only (add)
    (+ u1 u2 )
)

(define-read-only (subtract)
    (- 1 2)
)

(define-read-only (multiply)
    (* u2 u3)
)

(define-read-only (divide)
    (/ u6 u2)
)


(define-read-only (uint-to-int)
    (to-int u4)
)

(define-read-only (int-to-uint)
    (to-uint 2)
)

;; Day 5 - Advanced Operator
(define-read-only (exponent) 
    (pow u3 u3)
)

(define-read-only (square-root) 
    (sqrti u27)
)

(define-read-only (modulo) 
    (mod u20 u3)
)

(define-read-only (log-two) 
    (log2 (* u2 (+ u12 u4)))
)

;; Day6 - Strings
(define-read-only (say-hello) 
    "Hello"
)

(define-read-only (say-hello-world) 
    (concat "Hello" " World")
)

(define-read-only (say-hello-world-name)
    (concat
        (concat "Hello" " World,")
        " Setzeus"
    )
)

;; Day 7 - Logics
(define-read-only (and-i)
    (and true true)
)

(define-read-only (and-ii)
    (and true false)
)

(define-read-only (and-iii)
    (and
        (> u2 u1)
        (not false)
        true
    )
)

(define-read-only (or-i) 
    (or true false)
)

(define-read-only (or-ii)
    (or (not true) false)
)

(define-read-only (or-iii)
    (or
        (< u2 u1)
        (not true)
        (and (> u2 u1) true)
    )
)