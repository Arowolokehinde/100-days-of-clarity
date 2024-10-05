;; community-hello-world
;; contract that provides a community billboard, readable by anyone but only updateable by Admin principal


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, & Maps    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; constant that sets deployer principal as admin
(define-constant admin tx-sender)

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

        ;; Assert that updated-user-name is not empty

        ;; Var-set billboard with new keys
        (ok true)
    )
)

;; @Admin Set New User
;; @desc - function used by admin to set / give permission to next user
;; @param - updated-user-principal: principal
(define-public (admin-set-new-user (updated-user-pricipal principal))
    (begin 
        ;; Assert that tx-sender is admin

        ;; Assert that updated-user-principal is Not admin

        ;; Assert that updated-user-principal is Not current next-user

        ;; var-set next-user with updated-user-principal
        (ok true)
    )
)

