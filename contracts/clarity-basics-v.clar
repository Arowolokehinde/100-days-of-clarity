
;; clarity-basics-v
;; <add a description here>

;; Day 45 - Private Functions
(define-read-only (say-hello-read)
    (say-hello-world)
)

(define-public (say-hello-public)
    (ok (say-hello-world))
)

(define-private (say-hello-world)
    "hello world"
)

;; Day 46 - Filter

(define-constant test-list (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10))
(define-read-only (test-filter-remove-smaller-than-5)
    (filter filter-smaller-than-5 test-list)
)
(define-read-only (test-remove-odds)
    (filter remove-odds test-list)
)

(define-private (remove-odds (item uint))
    (is-eq (mod item u2) u0)
)


(define-private (filter-smaller-than-5 (item uint))
    (> item u5)
)

;; Day 47 - Map
(define-constant test-list-string (list "kate" "Annie" "Karl"))
(define-read-only (test-map-increase-by-one)
    (map add-by-one test-list)
)
(define-read-only (test-map-string)
    (map hello-name test-list-string)
)

(define-read-only (test-map-double)
    (map double test-list)
)

(define-private (hello-name (item (string-ascii 24)))
    (concat "hello " item)
)
(define-private (add-by-one (item uint))
    (+ item u1)
)
(define-private (double (item uint))
    (* item u2)
)

;; ;; Day 48 - Map cont'd
(define-constant test-list-principals (list 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG))
(define-constant test-list-tuple (list {user: "Annie", balance: u10} {user: "Kate", balance: u12} {user: "Alice", balance: u13}))
(define-public (test-send-multiple-stx)
    (ok (map send-multiple-stx test-list-principals))
)
(define-read-only (test-get-users)
    (map get-user test-list-tuple)
)
(define-read-only (test-get-balance)
    (map get-balance test-list-tuple)
)

(define-private (get-user (item {user: (string-ascii 24), balance: uint}))
    (get user item)
)

(define-private (get-balance (item {user: (string-ascii 24), balance: uint}))
    (get balance item)
)


(define-private (send-multiple-stx (item principal))
    (stx-transfer? u10000000 tx-sender item)
)

;; Day 49 - Fold
(define-constant test-list-ones (list u1 u1 u1 u1 u1))
(define-constant test-list-two (list u1 u2 u3 u4 u5))
(define-constant test-alphabets (list "a" "b" "c" "d" "e"))

(define-read-only (fold-add-start-zero)
    (fold + test-list-ones u0)
)

(define-read-only (fold-multiple-one)
    (fold * test-list-two u2)
)

(define-read-only (fold-alphabets)
    (fold concat-string test-alphabets "a")
)

(define-private (concat-string (a (string-ascii 10)) (b (string-ascii 10)))
    (unwrap-panic (as-max-len? (concat b a) u10))
)

;; Day 50 - Contract call
(define-read-only (call-basics-i-multiply)
    (contract-call? .clarity-basics-i multiply)
)
