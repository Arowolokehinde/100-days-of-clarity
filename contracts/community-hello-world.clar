;; community-hello-world
;; contract that provides a community billboard, readable by anyone but only updateable by Admin principal


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, & Maps    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; constant that sets deployer principal as admin
(define-constant admin tx-sender)


;; Error messages
(define-constant ERR-TX-SENDER-NOT-NEXT-USER u0)
(define-constant ERR-UPDATED-USER-NAME-IS-EMPTY u1)
(define-constant ERR-TX-SENDER-NOT-ADMIN u2)
(define-constant ERR-UPDATED-PRINCIPAL-IS-ADMIN u3)
(define-constant ERR-UPDATED-USER-PRINCIPAL-IS-NEXT-USER u4)



;; Variable that keeps track of the next *next* user that will introduce themselves / write to the billboard
(define-data-var next-user principal tx-sender)

;; Variable tuple that contains new member info
(define-data-var billboard {new-user-principal: principal, new-user-name: (string-ascii 24)} {
    new-user-principal: tx-sender,
    new-user-name: ""
})


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read Functions        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get community billboard
(define-read-only (get-billboard)
    (var-get billboard)
)

(define-read-only (get-next-user)
    (var-get next-user)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Write Functions       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; update functions
;; @desc - function used by the next-user to update the community billboard
;; @param - new-user-name: (string-ascii 24)
(define-public (update-billboard (updated-user-name (string-ascii 24)))
    (begin
        ;; Assert that tx-sender is next-user (approved by admin)
        (asserts! (is-eq tx-sender (var-get next-user)) (err u0))
        ;; Assert that updated-user-name is not empty
        (asserts! (not (is-eq updated-user-name "")) (err u1))
        ;; Var-set billboard with new keys
        (ok (var-set billboard {
            new-user-principal: tx-sender,
            new-user-name: updated-user-name
        }))
    )
)

;; @Admin Set New User
;; @desc - function used by admin to set / give permission to next user
;; @param - updated-user-principal: principal
(define-public (admin-set-new-user (updated-user-principal principal))
    (begin 
        ;; Assert that tx-sender is admin
        (asserts! (is-eq tx-sender admin) (err u2))
        ;; Assert that updated-user-principal is Not admin
        (asserts! (not (is-eq tx-sender updated-user-principal)) (err u3))
        ;; Assert that updated-user-principal is Not current next-user
        (asserts! (not (is-eq updated-user-principal (var-get next-user))) (err u4))
        ;; var-set next-user with updated-user-principal
        (ok (var-set next-user updated-user-principal))
    )
)

