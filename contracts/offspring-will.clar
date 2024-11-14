;; offspring-will
;; smart contract that allows parent to create and fund wallets unlockable only by assigned offspring
;; written by Arowolo kehinde


;; Offspring wallet
;; This is our major map that is created and funded by a parent, & only unloackable by an assigned offspring pricinpal
;; Principal -> (offspring-principal: principal,  offspring-dob: uint, balance: (uint) )
;; 1. Create Wallet
;; 2. Fund Wallet
;; 3. Cleanse Wallet
    ;; A. Offspring
    ;; B. Parent/Admin
    ;; C. Emergency



;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Con, Maps & Vars ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Deployer
(define-constant deployer tx-sender)

;; Contract
(define-constant contract (as-contract tx-sender))


;;Create Offspring wallet fee
(define-constant create-wallet-fee u5000000)

;; Add Offspring Wallet Funds fee
(define-constant add-wallet-funds-fee u2000000)

;; Min. Add Offspring Wallet Funds amount
(define-constant min-add-wallet-amount u5000000)

;; Early Withdrawal Fee (10%)
(define-constant early-withdrawal-fee u10)

;; Normal Withdrawal Fee (2%)
(define-constant normal-withdrawal-fee u2)

;; 18 years in BlockHeight (18 years + 365 days + 144 blocks / day)
(define-constant eighteen-years-in-block-height (* u18 (* u365 u144)))

;; Admin list of principals
(define-data-var admins (list 10 principal) (list tx-sender))

;; Total fees Earned
(define-data-var total-fees-earned uint u0)

;; Offspring Wallets
(define-map offspring-wallet principal { 
    offspring-principal: principal,
    offspring-dob: uint,
    balance: uint
})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Read Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get Offspring wallet
(define-read-only (get-offspring-wallet (parent principal))
    (map-get? offspring-wallet parent)
)

;; Get Offspring Principal
(define-read-only (get-offspring-wallet-principal (parent principal))
    (get offspring-principal (map-get? offspring-wallet parent))
)

;; Get Offspring wallent balance
(define-read-only (get-offspring-wallet-balance (parent principal))
    (default-to u0 (get balance (map-get? offspring-wallet parent)))
)

;; Get offspring-DOB
(define-read-only (get-offspring-wallet-dob (parent principal))
    (get offspring-dob (map-get? offspring-wallet parent))
)

;; Get offspring wallet unlock height
(define-read-only (get-offspring-wallet-unlock-height (parent principal))
    (let ((
        offspring-dob (unwrap! (get-offspring-wallet-dob parent) (err u1))
    )) 
        (ok (+ offspring-dob eighteen-years-in-block-height)))
)

;; Get Earned fees
(define-read-only (get-earned-fees)
    (var-get total-fees-earned)
)

;; Get STX in Contract
(define-read-only (get-contract-stx-balance)
    (stx-get-balance contract)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Parent Functions ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Create Wallet
;; @desc - creates a new offspring wallet with new parent (no initial deposit required)
;; @param - new-offspring-principal: principal, new-offspring-dob: uint, balance: uint
(define-public (create-wallet (new-offspring-principal principal) (new-offspring-dob uint))
    (let
        (
            ;; local vars here
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees create-wallet-fee))
        )
            ;; Assert that map-get? offspring-wallet is-none
            (asserts! (is-none (map-get? offspring-wallet tx-sender)) (err "err-wallet-already-exist"))
            
            ;; Assert that new-offspring-dob is at least higher tha block height - 18 years of blocks
            ;; (asserts! (> new-offspring-dob (- block-height eighteen-years-in-block-height)) (err "err-past-18-years"))

            ;; Assert that new-offspring-principal is NOT an admin or the tx-sender
            (asserts! (or (not (is-eq tx-sender new-offspring-principal)) (is-none (index-of (var-get admins) new-offspring-principal))) (err "err-offspring-not-admin"))

            ;; Pay create-wallet fee in stx
            (unwrap! (stx-transfer? create-wallet-fee tx-sender deployer) (err "err-stx-transfer"))
            
            ;; Var-set total-fees
            (var-set total-fees-earned new-total-fees)
            

            ;; Map set new offspring wallet
            (map-set offspring-wallet tx-sender {
                offspring-principal: new-offspring-principal,
                offspring-dob: new-offspring-dob,
                balance: u0
            })

            (ok true)
            
    )
)

;; Fund wallet
;; @desc - allows anyone to fund an existing wallet
;; @param - parent-principal: principal, amount: uint
(define-public (fund-wallet (parent principal) (amount uint))
    (let 
        (
            ;; local vars here
            (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")))
            (current-offspring-wallet-balance (get balance current-offspring-wallet))
            (new-offspring-wallet-balance (+ (- amount add-wallet-funds-fee) current-offspring-wallet-balance))
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees min-add-wallet-amount))

        )

            ;; Assert that amount is higher that min-add-wallet-amount 
            (asserts! (> amount min-add-wallet-amount) (err "err-not-enough-stx"))

            ;; Send stx (amount - fee) to contract
            (unwrap! (stx-transfer? (- amount add-wallet-funds-fee) tx-sender contract) (err "err-sending-stx-to-contract"))

            ;; Send stx (fee) to deployer
            (unwrap! (stx-transfer? add-wallet-funds-fee tx-sender deployer) (err "err-sending-stx-to-deployer"))


            ;; Var-set total-fees
            (var-set total-fees-earned new-total-fees)

            ;; Map-set current offspring-wallet by merging with old balance + amount
            (ok (map-set offspring-wallet parent
                (merge 
                    current-offspring-wallet
                    { balance: new-offspring-wallet-balance }
                )
            ))


    )
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Offspring Function ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Claim wallet
;; @desc - allows offspring to claim  wallet once & once only
;; @param - parent-principal: principal
(define-public (claim-wallet (parent principal))
    (let
        (
            (test true)
            (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")))
            (current-offspring (get offspring-principal current-offspring-wallet))
            (current-dob (get offspring-dob current-offspring-wallet))
            (current-balance (get balance current-offspring-wallet))
            (current-withdrawal-fee (/ (* current-balance u2) u100))
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees current-withdrawal-fee))

        )

            ;; Assert that tx-sender is-eq to offspring-principal
            (asserts! (is-eq tx-sender current-offspring) (err "err-not-offspring"))

            ;; Assert that block-height is 18 years in block later than offspring-dob
            (asserts! (> block-height (+ current-dob eighteen-years-in-block-height) ) (err "err-not-eighteen"))

            ;; Send STX (amount- Withdrawal fee) to offspring 
            (unwrap! (as-contract (stx-transfer? (- current-balance current-withdrawal-fee) tx-sender current-offspring)) (err "err-sending-to-offspring"))

            ;; Send STX withdrawal to deployer
            (unwrap! (as-contract (stx-transfer? current-withdrawal-fee tx-sender deployer)) (err "err-sending-to-deployer"))


            ;; Delete offspring-wallet map
            (map-delete offspring-wallet parent)

            ;; Update total-fees-earned
            (ok (var-set total-fees-earned new-total-fees))
    )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Emergency Withdrawal ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emergenccy claim
;; @desc - allows either parent or an admin to withdraw all stx (mins emergency withdrawal fee, back to admin & remove)
;; @param - parent-principal: principal
(define-public (emergency-claim (parent principal))
    (let
        (
            (test true)
            (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")))
            (current-offspring-dob (get offspring-dob current-offspring-wallet))        
            (current-balance (get balance current-offspring-wallet))
            (current-withdrawal-fee (/ (* current-balance early-withdrawal-fee) u100))
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees current-withdrawal-fee))
        
        )

            ;; Assert that tx-sender is either parent or tx-sender is one of the admins
            (asserts! (or (is-eq tx-sender parent) (is-some (index-of (var-get admins) tx-sender))) (err "err-unauthorized"))

            ;; Assert that block-height is less than 18 years from DOB
            (asserts! (< block-height (+ current-offspring-dob eighteen-years-in-block-height)) (err "err-too-late"))

            ;; Send STX (amount -emergency withdrawal fee) to offspring
            (unwrap! (as-contract (stx-transfer? (- current-balance current-withdrawal-fee) tx-sender parent)) (err "err-sending-to-parent"))

            ;; Send STX (emergency withdrawal fee) to deployer
            (unwrap! (as-contract (stx-transfer? current-withdrawal-fee tx-sender deployer)) (err "err-sending-stx-to-deployer"))

            ;; Delete offspring-wallet map
            (map-delete offspring-wallet parent)

            ;; Update total-fees-earned
            (ok (var-set total-fees-earned new-total-fees))
    )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Admin Function ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add Admin
;; @desc - function to add an admin to the existing admin list
;; @param - new-admin: principal
(define-public (add-admin (new-admin principal))
    (let
        (
            (test true)
            (current-admins (var-get admins))
        )
            ;; Assert that tx-sender is a current admin
            (asserts! (is-some (index-of current-admins tx-sender)) (err "err-not-authorized"))

            ;; Assert that new-admin does not exist in list of admins
            (asserts! (is-some (index-of current-admins new-admin)) (err "err-not-duplicate-admins"))

            ;; Append new-admin to list of admins
            (ok (var-set admins
                (unwrap! (as-max-len? (append current-admins new-admin) u10) (err "err-admin-list-overflow"))
            ))
    )
)

;; Remove Admin
;; @desc - function to remove an existing admin
;; @param - removed-admin: principal
(define-public (remove-admin (removed-admin principal))
    (let
        (
            (test true)
        )

            ;; Assert that tx-sender is a current admin

            ;; Filter remove removed-admin
            (ok test)
    )
)