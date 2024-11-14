;; clarity-basics-iii
(define-read-only (list-bool)
    (list true false true)
)

(define-read-only (list-num)
    (list 1  2 3)
)

(define-read-only (list-string)
    (list "hello" "world" "clarity")
)

(define-read-only (list-principal)
    (list tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC)
)

(define-data-var num-list (list 10 uint) (list u1 u2 u3 u4))
(define-data-var principal-list  (list 5 principal)
    (list tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC)
)

;; Element of (index -> value)
(define-read-only (element-at-num-list (index uint))
    (element-at (var-get num-list) index)
)

(define-read-only (element-at-principal-list (index uint))
    (element-at (var-get principal-list) index)
)

;; Index-of (value -> index)
(define-read-only (index-of-num-list (item uint))
    (index-of (var-get num-list) item)
)

(define-read-only (index-of-principal-list (item principal))
    (index-of (var-get principal-list) item)
)

;; Day 21 - Lists cont & Intro to unwrapping
(define-data-var list-day-21 (list 5 uint) (list u1 u2 u3 u4))
(define-read-only (list-length)
    (len (var-get list-day-21))
)

(define-public (add-to-list (new-num uint))
    (ok (var-set list-day-21
        (unwrap!
            (as-max-len? (append (var-get list-day-21) new-num) u5)
        (err u0))
    ))
)

;; Day 22 - Unwrapping
;; unwrap! - accepts optionals or response
;; unwrap-err! - response
;; unwrap-panic - optional & response
;; unwrap-err-panic - optional & response
;; try! - optionals & response


(define-public (unwrap-example (new-num uint))
    (ok (var-set list-day-21
        (unwrap!
            (as-max-len? (append (var-get list-day-21) new-num) u5)
        (err "error list at max-len"))
    ))
)


(define-public (unwrap-panic-example (new-num uint))
    (ok (var-set list-day-21
        (unwrap-panic (as-max-len? (append (var-get list-day-21) new-num) u5))
    ))
)

(define-public (unwrap-err-example (input (response uint uint)))
    (ok (unwrap-err! input (err u10)))
)

(define-public (try-example (input (response uint uint)))
    (ok (try! input))
)

;; Day 23 - Get & Default-to


(define-constant example-tuple (some {
    example-bool: true,
    example-num: u11,
    example-string: "expale",
    example-principal: tx-sender
}))

(define-read-only (read-example-bool)
    (get example-bool example-tuple)
)

(define-read-only (read-example-string)
    (default-to "example" (get example-string example-tuple))
)

(define-read-only (read-example-num)
    (default-to u10 (get example-num example-tuple))
)

(define-read-only (read-example-principal)
    (get example-principal example-tuple)
)

;; Day 24 - Conditionals Const -Match & if
(define-read-only (if-example (test-bool bool))
    (if test-bool
        ;; Evaluates to true
        "evaluated to true"
        ;; Evaluayes to false
        "evaluated to false"
    )
)

(define-read-only (if-example-num (num uint))
    (if (and (> num u0) (< num u10))
        ;; Evaluates to true
        num
        ;; Evaluates to false
        u10
    )
)
;; Match
(define-read-only (match-optional-some)
    (match (some u1) 
        ;; some value / there was some optional
        match-value (+ u1 match-value)
        ;; none / there was no value
        u0
    )
)

(define-read-only (match-optional (test-value (optional uint)))
    (match test-value
        match-value (+ u2 match-value)
        u0
    )
)

(define-read-only (match-response (test-value (response uint uint)))
    (match test-value 
        ok-value ok-value
        err-value u0
    )
)

;; Day 25 
(define-map first-map principal (string-ascii 24))
(define-public (set-first-map (username (string-ascii 24)))
    (ok (map-set first-map tx-sender username))
)

(define-read-only (get-first-map (key principal))
    (map-get? first-map key)
)

(define-map second-map principal {
    username: (string-ascii 24),
    balance: uint,
    referral: (optional principal)
})

(define-public (set-second-map (new-username (string-ascii 24)) (new-balance uint) (new-referral (optional principal)))
    (ok (map-set second-map tx-sender {
        username: new-username,
        balance: new-balance,
        referral: new-referral
    }))
)

(define-read-only (get-second-map (key principal))
    (map-get? second-map key)
)

;; Day 26 - Maps Cont'd
(define-public (insert-first-map (username (string-ascii 24)))
    (ok (map-insert first-map tx-sender username))
)

(define-map third-map { user: principal, cohort: uint } {
    username: (string-ascii 24),
    balance: uint,
    referral: (optional principal)
})

(define-public (set-third-map (new-username (string-ascii 24)) (new-balance uint) (new-referral (optional principal)))
    (ok (map-set third-map { user: tx-sender, cohort: u1 } {
        username: new-username,
        balance: new-balance,
        referral: new-referral
    }))
)

(define-public (delete-third-map)
    (ok (map-delete third-map { user: tx-sender, cohort: u1 }))
)

(define-read-only (read-third-map)
    (map-get? third-map { user: tx-sender, cohort: u1 })
)