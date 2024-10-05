;; clarity-basics-ii

;; Day 8 - Optionals & parameters

(define-read-only (show-some)
    (some u2 )
)

(define-read-only (show-none)
    none
)

(define-read-only (params (num uint) (string (string-ascii 48)) (boolean bool))
    num
)

(define-read-only (params-optional (num (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)))
    num
)

(define-read-only (is-some-example (num (optional uint)))
    (is-some num)
)

(define-read-only (is-none-example (num (optional uint)))
    (is-none num)
)

(define-read-only (params-optional-and (num (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)))
    (and
        (is-some num)
        (is-some string)
        (is-some boolean)
    )
)

;; Day 10 - Constants & Intro to variables
(define-constant fav-num u10)
(define-constant fav-string "Hi")
(define-data-var fav-num-var uint u11)
(define-data-var your-name (string-ascii 24) " Arowolo kehinde")

(define-read-only (show-constant) 
    fav-string
)

(define-read-only (show-constant-double)
    (* fav-num u2)
)

(define-read-only (show-fav-num-var)
    (var-get fav-num-var)
)

(define-read-only (show-var-double)
    (* u2 (var-get fav-num-var))
)

(define-read-only (say-hi)
    (concat fav-string (var-get your-name))
)

;; Day 11 - Public functions
(define-read-only (response-example)
    (ok u10)
)

(define-public (change-name (new-name (string-ascii 24)))
    (ok (var-set your-name new-name))
)

(define-public (change-fav-num (new-num uint))
    (ok (var-set fav-num-var new-num))
)

(define-read-only (read-tuple)
    {
        user-principal: 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5,
        user-name: "Kehinde",
        user-balance: u10
    }
)

(define-public (write-tuple-i (new-user-principal principal) (new-user-name (string-ascii 24)) (new-user-balance uint))
    (ok {
        user-principal: new-user-principal,
        user-name: new-user-name,
        user-balance: new-user-balance
    })
)

(define-read-only (read-original)
    (var-get original)
)

(define-data-var original {user-principal: principal, user-name: (string-ascii 24), user-balance: uint}
    {
        user-principal: 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5,
        user-name: "Kehinde",
        user-balance: u10
    }
)

(define-public (merge-principal (new-user-principal principal))
    (ok (merge
        (var-get original)
        {user-principal: new-user-principal}
    ))
)

(define-public (merge-user-name (new-user-name (string-ascii 24)))
    (ok (merge
        (var-get original)
        {user-name: new-user-name}
    ))
)

(define-public (merge-all (new-user-principal principal) (new-user-name (string-ascii 24)) (new-user-balance uint))
    (ok (merge
        (var-get original)
        {
            user-principal: new-user-principal,
            user-name: new-user-name,
            user-balance: new-user-balance
        }
    ))
)

;; Day 13 - Tx sender & Is-Eq
(define-read-only (show-tx-sender)
    tx-sender
)

(define-constant admin 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-read-only (check-admin)
    (is-eq admin tx-sender)
)

;; Day 14 -  Conditional 1 
(define-read-only (show-asserts (num uint))
    (ok (asserts! (> num u2) (err u2)))
)

(define-constant err-too-large (err u1))
(define-constant err-too-small (err u2))
(define-constant err-not-auth (err u3))
(define-constant admin-one tx-sender)

(define-read-only (assert-admin)
    (ok (asserts! (is-eq tx-sender admin-one) err-not-auth))
)

;; Day 15 - Begin
;; Set & say hello
;; counter by even

(define-data-var hello-name (string-ascii 48) "Hello")
;; @desc - This functions allows a user to provide a name, which if different, changes a name variable & returns
;; @param - new-name: (strin-ascii 48) that represents the new name

;; (define-public (set-and-say-hello (new-name (string-ascii 48)))
;;     (begin

(define-public (set-and-say-hello (new-name (string-ascii 48)))
    (begin
        ;; Asserts that name is not empty
        (asserts! (not (is-eq "" new-name)) (err u1)) 
        ;; Asserts that name is not equal to the current one
        (asserts! (not (is-eq (var-get hello-name) new-name)) (err u2))
        ;; var-set new-name
        (var-set hello-name new-name)
        ;; say hello new-name
        (ok (concat "Hello " (var-get hello-name))))
)

(define-read-only (read-hello-name)
    (var-get hello-name)
)

(define-data-var counter uint u0)
(define-read-only (read-counter)
    (var-get counter)
)

;; @desc - this function allows a user to increase the counter by only an even amount
;; @param - add-num: uint that user submits to add to counter

(define-public (increment-counter-even (add-num uint))
    (begin
        ;; Asserts that add-num is even
        (asserts! (is-eq u0 (mod add-num u2)) (err u3))

        ;; Increment & var-set counter
        (ok (var-set counter (+ (var-get counter) add-num)))
    )
)