;; artist-discorgraphy
;; contract that models an artist discorgraphy (discorgraphy -> albums -> tracks)
;; Written by Arowolo Kehinde

;; Discorgraphy
;; An artist discorgraphy is a list of albums
;; The artist or an admin can start a discorgraphy & can add/remove albums

;; Album
;; An album is a list of tracks, + some additional info  (such as when it was published)
;; The artist or an album can start a track & can add/remove tracks

;; Track
;; A trackis made up of a name, a duration (in seconds),  & a possible feature (optional feature)
;; The artist or an admin can start a track & can add / remove tracks


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Cons, Vars & Maps ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; variable
(define-data-var admins (list 10 principal) (list tx-sender))

;; Maps that keeps tracks of a single Track
(define-map track { artist: principal, album-id: uint , track-id: uint} {
    title: (string-ascii 24),
    duration: uint,
    featured: (optional principal)
})

;; Map that keeps track of a single album
(define-map album { artist: principal, album-id: uint } { 
    title: (string-ascii 24),
    tracks: (list 20 uint),
    height-published: uint
})

;; Map that keeps track of a discography
(define-map discography principal (list 10 uint))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Read Functions    ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get track data
(define-read-only (get-track-data (artist principal) (album-id uint) (track-id uint))
    (map-get? track { artist: artist, album-id: album-id, track-id: track-id})
)

;; Get featured artist
(define-read-only (get-featured-artist (artist principal) (album-id uint) (track-id uint))
    (get featured (map-get? track { artist: artist, album-id: album-id, track-id: track-id}))
)

;; Get album data
(define-read-only (get-album-data (artist principal) (album-id uint))
    (map-get? album { artist: artist, album-id: album-id})
)

;; Get published album height
(define-read-only (get-album-published-height (artist principal) (album-id uint))
    (get height-published (map-get? album {artist: artist, album-id: album-id}))
)

;; Get discography
(define-read-only (get-discography (artist principal))
    (map-get? discography artist)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Write functions   ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; @desc - function that allow a user or admin to add a trak
;; @param - title (string-ascii 24), duration (uint), featured-artist (optional principal), album-id (uint)
(define-public (add-a-track (artist (optional principal)) (title (string-ascii 24)) (duration uint) (featured (optional principal)) (album-id uint))
    (let
        (
            (test u0)
        )   
        ;; Assert that tx-sender is either artist or admin

        ;; Assert that album exists to discorgraphy

        ;; Assert that duration is less than 600 (10 mins)

        ;; Map-set new track

        ;; Map-set append track to album

        (ok true)
    )

)

;; Add an album
;; @desc - function that allows the artist or admin to add a new album or start a new discorgraphy
(define-public (add-album-or-create-discography-and-add-album (artist (optional principal)) (album-title (string-ascii 24)))
    (let
        (
            ;; this is where local vars go
        )

            ;; check whether discography exists / if discography is-some

                ;; Discography exists

                ;; Discography does not exist

                    ;; Map-set new discography

            ;; Map=set new album

            ;; Append new album to discography

            (ok true)

    )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Admin functions   ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add admin
;; @desc - function that an existing admin can call to add another admin
;; @param - New admin principal
(define-public (add-admin (new-admin principal))
    (let
        (
            (test u0)
        )

        ;; Assert that tx-sender is an existing admin

        ;; Assert that new admin does not exist in admin list

        ;; Append new admin to the admin list

        (ok true)
    )
)


;; Remove
;; @desc function that removes an existing admin
;; @param Removed8 admin (principal)
(define-public (remove-admin (removed-admin principal))
    (let 
        (
            (test u0)
        )

        ;; Assert that tx-sender is an existing admin

        ;; Assert that removed admin is an existing admin

        ;; Remove admin from admin list

        (ok true)
    )
)

