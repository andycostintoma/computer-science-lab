;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; ================== SPACE INVADERS ==================

;; ====================================================
;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 10)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer
(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define TANK-Y (- HEIGHT  TANK-HEIGHT/2))

(define MISSILE (ellipse 5 15 "solid" "red"))

(define MISSILE-STARTING-Y (- HEIGHT (+ (image-height TANK) (/ (image-height MISSILE) 2))))

;; ====================================================
;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loi  (game-invaders s))
       (fn-for-lom  (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))

;; ListOfInvader is one of:
;; - empty
;; - (cons (make-invader Number Number Number) ListOfInvader)
;; interp. a list of of invaders

(define LOI0 empty)
(define LOI1 (list I1 I2 I3))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (... (invader-x  (first loi))      ;Number
              (invader-y  (first loi))      ;Number
              (invader-dx (first loi))      ;Number
              (fn-for-loi (rest loi)))]
        ))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                               ;not hit I1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit I1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit I1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))

;; ListOfMissile is one of:
;; - empty
;; - (cons (make-missile Number Number) ListOfMissile)
;; interp. a list of of missiles

(define LOM0 empty)
(define LOM1 (list M1 M2 M3))

#;
(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]
        [else
         (... (missile-x  (first lom))      ;Number
              (missile-y  (first lom))      ;Number
              (fn-for-lom (rest lom)))]
        ))

(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;; ====================================================
;; Functions:

;; Game -> Game
;; start the world with (main G0)


(define (main g)
  (big-bang g              ; Game
    (on-tick   next-state) ; Game -> Game
    (to-draw       render) ; Game -> Image
    (stop-when game-over?) ; Game -> Boolean
    (on-key    handle-key) ; Game KeyEvent -> Game
    ))

;; START GAME
;(main G0)

;; ====================================================
;; Game functions:

;; Game -> Game
;; produce the next game state

(check-random (next-state G0) (make-game (next-loi empty empty) (next-lom empty empty) (next-tank T0)))

;(define (next-state s) s) ;stub

(define (next-state s)
  (make-game
   (next-loi  (game-invaders s) (game-missiles s))
   (next-lom  (game-missiles s) (game-invaders s))
   (next-tank (game-tank s))
   ))

;; Game -> Image
;; render the next game image

(check-expect (render G0)   (render-loi-on empty
                                           (render-lom-on empty
                                                          (render-tank-on T0 BACKGROUND))))

(check-random (render (next-state G0))   (render-loi-on (next-loi empty empty)
                                                        (render-lom-on (next-lom empty empty)
                                                                       (render-tank-on (next-tank T0) BACKGROUND))))


;(define (render s) BACKGROUND) ;stub


(define (render s)
  (render-loi-on (game-invaders s)
                 (render-lom-on  (game-missiles s)
                                 (render-tank-on (game-tank s) BACKGROUND)))
  )

;; Game -> Boolean
;; produce true if game is over
(check-expect (game-over? G0) false)
(check-expect (game-over? G3) true)

;(define (game-over? s) false) ;stub

(define (game-over? s)
  (inv-in-loi-landed? (game-invaders s)))

;; Game KeyEvent -> Game
;; handle key event
(check-expect (handle-key G0 "left") (make-game empty empty (change-dir T0 "left")))
(check-expect (handle-key G0    " ") (make-game empty (shoot empty T0 " ") T0))
(check-expect (handle-key G0    "a") G0)

;(define (handle-key s ke) s) ;stub

(define (handle-key s ke)
  (cond
    [(or (key=? ke "left") (key=? ke "right"))
     (make-game (game-invaders s) (game-missiles s) (change-dir (game-tank s) ke))]
    [(key=? ke " ") 
     (make-game (game-invaders s) (shoot (game-missiles s) (game-tank s) ke) (game-tank s))]
    [else s]
    ))

;; ====================================================
;; Functions On 2 One-Of Data


;; ListOfInvaders ListOfMissile -> ListOfInvaders
;; produces the next list of invaders (destroy invaders if hit, move invaders, spawn invaders)
;; !!!
(check-random (next-loi empty empty) (move-loi(spawn-invaders empty)))
(check-random (next-loi (list I1 I2) (list M1 M2)) (move-loi(spawn-invaders (list I2))))

;(define (next-loi loi lom) loi) ;stub

(define (next-loi loi lom)
  (move-loi(spawn-invaders(destroy-invaders loi lom))))

;; ListOfInvaders ListOfMissile -> ListOfInvaders
;; remove invader from ListOfInvaders if it's hit by missile from ListOfMissile
;; !!!
(check-expect (destroy-invaders (list I1) (list M1 M2)) empty)
(check-expect (destroy-invaders (list I1 I2) (list M1 M2)) (list I2))

;(define (destroy-invaders loi lom) loi) ;stub

;; CROSS PRODUCT OF TYPE COMMENTS TABLE
;;
;;                                        lom
;;                           empty           (cons Missile LOM)                
;;                                         |
;; l   empty                     empty     |      empty
;; o                         --------------------------------
;; i   (cons Invader LOI)         loi      |      ...
;;                                         |

(define (destroy-invaders loi lom)
  (cond [(empty? loi) empty]
        [(empty? lom) loi]
        [else (if (inv-hit-from-lom? (first loi) lom)
                  (rest loi)
                  (cons (first loi)(destroy-invaders (rest loi)  lom)))
              ]
        ))

;; ListOfMissile ListOfInvaders  -> ListOfMissile
;; produces the next list of missiles (move missiles, destroy missile when it hits an invader)
;; !!!

;(define (next-lom lom loi) lom) ;stub

(define (next-lom lom loi)
  (move-lom (destroy-missiles lom loi)))

;; ListOfMissile ListOfInvaders  -> ListOfMissile
;; remove missile from ListOfMissile if it hits an invader from ListOfInvaders
;; !!!

;(define (destroy-missiles lom loi) lom) ;stub

(define (destroy-missiles lom loi)
  (cond [(empty? lom) empty]
        [(empty? loi) lom]
        [else (if (missile-hit-from-loi? (first lom) loi)
                  (rest lom)
                  (cons (first lom) (destroy-missiles (rest lom)  loi)))
              ]
        ))


;; ====================================================
;; Combined Invader and Missile


;; Invader ListOfMissile -> Boolean
;; return true if missile from ListOfMissile hit invader
(check-expect (inv-hit-from-lom? I1 (list M1 M2 M3)) true)

;(define (inv-hit-from-lom? i lom) false) ;stub

(define (inv-hit-from-lom? i lom)
  (cond [(empty? lom) false]
        [else
         (or (hit? i (first lom))
             (inv-hit-from-lom?  i (rest lom)))]
        ))

;; Missile ListOfInvader -> Boolean
;; return true if invader from ListOfInvader is hit by missile

;(define (missile-hit-from-loi? m loi) false) ;stub


(define (missile-hit-from-loi? m loi)
    (cond [(empty? loi) false]
        [else
         (or (hit? (first loi) m)
             (missile-hit-from-loi? m (rest loi)))]
        ))


;; Invader Missile -> Boolean
;; return true if missile hit invader
(check-expect (hit? I1 M1) false)
(check-expect (hit? I1 M2) true)
(check-expect (hit? I1 M3) true)

;(define (hit? i m) false)  ;stub

(define (hit? i m)
  (and (<= (abs (- (invader-x i) (missile-x m))) HIT-RANGE)
       (<= (abs (- (invader-y i) (missile-y m))) HIT-RANGE)))

;; ====================================================
;; Invader functions:

;; ListOfInvaders -> ListOfInvaders
;; produces the next list of invaders at the appropiate possitions

(check-expect (move-loi (list (make-invader 150 100  1.5) (make-invader 150 100  -1.5)))
              (list (move-invader (make-invader 150 100  1.5)) (move-invader (make-invader 150 100  -1.5))))

;(define (move-loi loi) loi) ;stub
              
(define (move-loi loi)
  (cond [(empty? loi) empty]
        [else
         (cons (move-invader (first loi)) (move-loi (rest loi)))]
        ))

;; Invader -> Invader
;; produce the next Invader and if it hits the wall reverse direction

(check-expect (move-invader (make-invader 150 100  1.5)) (make-invader (+ 150  1.5) (+ 100 INVADER-Y-SPEED)  1.5)) ;invader moving right
(check-expect (move-invader (make-invader 150 100 -1.5)) (make-invader (+ 150 -1.5) (+ 100 INVADER-Y-SPEED) -1.5)) ;invader moving left

(check-expect (move-invader (make-invader (- WIDTH 1) 100  1.5)) (make-invader WIDTH 100 -1.5)) ;tries to pass right edge
(check-expect (move-invader (make-invader (+ 0     1) 100 -1.5)) (make-invader 0     100  1.5)) ;tries to pass left  edge 

;(define (move-invader i) i) ;stub

(define (move-invader i)
  (cond [(> (+ (invader-x i) (invader-dx i)) WIDTH) (make-invader WIDTH   (invader-y i) (- (invader-dx i)))]
        [(< (+ (invader-x i) (invader-dx i))     0) (make-invader     0   (invader-y i) (- (invader-dx i)))]
        [else
         (make-invader (+ (invader-x i) (invader-dx i)) (+ (invader-y i) INVADER-Y-SPEED)  (invader-dx i))]
        ))

;; ListOfInvaders -> ListOfInvaders
;; spawn invaders randomly along the top of the screen if length of ListOfInvaders is less than INVADE-RATE

;(define (spawn-invaders loi) loi) ;stub

(define (spawn-invaders loi)
  (cond [(or (empty? loi) (and (< (length loi) INVADE-RATE) (> (invader-y (first loi)) (+ 0 (/ HEIGHT 5)))))
         (cons (make-invader (random WIDTH) 0 INVADER-X-SPEED) loi)]
        [else loi]))


;; ListOfInvaders Image -> Image
;; render ListOfInvaders on the given image
(check-expect (render-loi-on empty BACKGROUND) BACKGROUND)
(check-expect (render-loi-on (list I1 I2 I3) BACKGROUND) (render-invader-on I1 (render-invader-on I2 (render-invader-on I3 BACKGROUND))))


;(define (render-loi-on loi img) img) ;stub

(define (render-loi-on loi img)
  (cond [(empty? loi) img]
        [else
         (render-invader-on (first loi) (render-loi-on (rest loi) img))]
        ))

;; Invader Image -> Image
;; render Invader on the given image
(check-expect (render-invader-on I1 BACKGROUND) (place-image INVADER 150 100    BACKGROUND))
(check-expect (render-invader-on I2 BACKGROUND) (place-image INVADER 150 HEIGHT BACKGROUND))

;(define (render-invader-on  i img) img) ;stub

(define (render-invader-on  i img)
  (place-image INVADER (invader-x i) (invader-y i) img))

;; ListOfInvaders -> Boolean
;; produce true if any invader of ListOfInvaders have reached bottom
(check-expect (inv-in-loi-landed? empty) false)
(check-expect (inv-in-loi-landed? (list I1)) false)
(check-expect (inv-in-loi-landed? (list I1 I2)) true)

;(define (inv-in-loi-landed? loi) false) ;stub

(define (inv-in-loi-landed? loi)
  (cond [(empty? loi) false]
        [else
         (or (landed? (first loi)) (inv-in-loi-landed? (rest loi)))]
        ))

;; Invader -> Boolean
;; produce true if invader has landed (invader-y >= HEIGHT)
(check-expect (landed? I1) false)
(check-expect (landed? I2)  true)
(check-expect (landed? I3)  true)

;define (landed? i) false) ;stub

(define (landed? i)
  (>= (invader-y i) HEIGHT))


;; ====================================================
;; Missile functions:

;; ListOfMissile -> ListOfMissile
;; produces the next list of missiles at the appropiate possitions
(check-expect (move-lom (list (make-missile 150 300) (make-missile 170 250)))
              (list (move-missile (make-missile 150 300)) (move-missile (make-missile 170 250))))

;(define (move-lom lom) lom) ;stub

(define (move-lom lom)
  (cond [(empty? lom) empty]
        [else
         (cons (move-missile (first lom)) (move-lom (rest lom)))]
        ))

;; Missile -> Missile
;; produce the next missile at the appropiate location
(check-expect (move-missile (make-missile 150 300)) (make-missile 150 (- 300  MISSILE-SPEED))) 

;(define (move-missile m) m) ;stub

(define (move-missile m)
  (make-missile (missile-x m) (- (missile-y m) MISSILE-SPEED)))


;; ListOfMissile Image -> Image
;; render ListOfMissile on the given image
(check-expect (render-lom-on (list (make-missile 150 300) (make-missile 170 250)) BACKGROUND)
              (render-missile-on (make-missile 150 300) (render-missile-on (make-missile 170 250) BACKGROUND)))

;(define (render-lom-on lom img) img) ;stub

(define (render-lom-on lom img)
  (cond [(empty? lom) img]
        [else
         (render-missile-on (first lom) (render-lom-on (rest lom) img))]
        ))

;; Missile Image -> Image
;; render missile on the given image
(check-expect (render-missile-on M1 BACKGROUND) (place-image MISSILE 150 300 BACKGROUND))

;(define (render-missile-on m img) img) ;stub

(define (render-missile-on m img)
  (place-image MISSILE (missile-x m) (missile-y m) img))

;; ListOfMissile Tank KeyEvent -> ListOfMissile
;; shot a new missile when SPACE is pressed, add it to ListOfMissile

(check-expect (shoot empty T0 " ") (list (make-missile (tank-x T0) MISSILE-STARTING-Y))) 

;(define (shoot lom tank ke) lom) ;stub

(define (shoot lom t ke)
  (cond [(and (key=? ke " ") (or (empty? lom)
                                 (< (missile-y (first lom)) (* 4 (/ HEIGHT 5)))))
         (cons (make-missile (tank-x t) MISSILE-STARTING-Y) lom)]  
        [else lom]))

;; ====================================================
;; Tank functions:

;; Tank -> Tank
;; produce the next Tank at appropiate possition

(check-expect (next-tank T0) (make-tank (+ (/ WIDTH 2) (* TANK-SPEED  1))  1)) ;going right 
(check-expect (next-tank T2) (make-tank (+ 50          (* TANK-SPEED -1)) -1)) ;going left

;(define (next-tank t) t) ;stub

(define (next-tank t)
  (make-tank (+ (tank-x t) (* TANK-SPEED (tank-dir t))) (tank-dir t)))

;; Tank -> Image
;; render tank image on given img at (tank-x t) and TANK-Y

(check-expect (render-tank-on T0 BACKGROUND) (place-image TANK (/ WIDTH 2) TANK-Y BACKGROUND))
(check-expect (render-tank-on T2 BACKGROUND) (place-image TANK 50          TANK-Y BACKGROUND))

;(define (render-tank-on tank img) img) ;stub 

(define (render-tank-on t img)
  (place-image TANK (tank-x t) TANK-Y img))

;; Tank KeyEvent -> Tank
;; change direction to right when right arrow is pressed or to left when left arrow is pressed

(check-expect (change-dir T0 "right") T0) ;already moving right
(check-expect (change-dir T2  "left") T2) ;already moving left
(check-expect (change-dir T0  "left") (make-tank (/ WIDTH 2)  -1)) ;change direction to left
(check-expect (change-dir T2 "right") (make-tank  50           1)) ;change direction to right

;(define (change-dir t ke) t) ;stub

(define (change-dir t ke)
  (cond
    [(key=? ke "left" ) (make-tank (tank-x t) -1)] 
    [(key=? ke "right") (make-tank (tank-x t)  1)]
    [else t]
    ))