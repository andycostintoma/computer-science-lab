;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 03_module_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; ========================================================
; ========================================================
(define-struct node (key val l r))

;; BST is one of:
;; - false
;; - (make-node Integer String BST BST)
;; interp. false means no BST, or empty BST
;;         key is the node key
;;         val is the node val
;;         l and r are left and right subtrees
;; INVARIANT: for a given node:
;;     key is > all keys in its l(eft)  child
;;     key is < all keys in its r(ight) child
;;     the same key never appears twice in the tree

(define BSTA (make-node 6 "a" false false))

(define BSTC (make-node 6 "a"
                        (make-node 4 "t"
                                   (make-node 3 "h" false false)
                                   (make-node 5 "j" false false))
                        (make-node 8 "v" false false)))

(define BSTD false)

#;
(define (fn-for-bt bt)
  (cond [(false? bt) ...]
        [else (...
               (node-key bt)
               (fn-for-bt (node-l bt))
               (fn-for-bt (node-r bt)))
              ]))

;; Functions

;; PROBLEM: design a function called tree-to-list, which present the keys in the tree in descending numerical order.

;; BST -> ListOfInteger
;; present the keys in the binary search tree in descending order as a list
(check-expect (tree-to-list false) empty)
(check-expect (tree-to-list (make-node 4 "e" 
                                       (make-node 1 "o" false false)
                                       (make-node 7 "p" false false)))
              (list 7 4 1))
(check-expect (tree-to-list (make-node 6 "a"
                                       (make-node 4 "b"
                                                  (make-node 1 "v" false false)
                                                  (make-node 5 "s" false false))
                                       (make-node 9 "q" 
                                                  false
                                                  (make-node 10 "x" false false))))
              (list 10 9 6 5 4 1))

;(define (tree-to-list bt) empty)   ;stub

(define (tree-to-list bt)
  (cond [(false? bt) empty]
        [else
         (append (tree-to-list (node-r bt))
                 (list (node-key bt))
                 (tree-to-list (node-l bt)))]))

; ========================================================
; ========================================================

(define-struct junction (left straight right))
       
;; Maze is one of:
;; - false
;; - "finish"
;; - (make-junction Maze Maze Maze)
;; a maze where at each junction you can either go straight, left or right. 
;; false means dead end, "finish" means you've reached the end of the maze

(define M0 false)      ; a maze that is a dead end
(define M1 "finish")   ; a maze where you are already at the finish
(define M2 (make-junction 
            (make-junction false 
                          (make-junction false
                                         false 
                                         (make-junction false
                                                        false 
                                                        false))
                          (make-junction false
                                         (make-junction 
                                          (make-junction false
                                                         false 
                                                         false)
                                          (make-junction false 
                                                        "finish"
                                                        false)
                                          false)
                                         false))
            (make-junction false 
                          false 
                          (make-junction false
                                         false
                                         false))
            false))    ; a maze

#;
(define (fn-for-maze m)
  (cond [(false? m) (...)]
        [(and (string? m) (string=? "finish" m)) (...)]
        [else
         (... (fn-for-maze (junction-left m))
              (fn-for-maze (junction-straight m))
              (fn-for-maze (junction-right m)))]))

;;What types of reference are present in the type Maze? -> SELF REFERENCE


; ========================================================
; ========================================================

(define (fn-for-title t)
  (cond [(string=? t "President") (...)]
        [(string=? t "Vice President") (...)]
        [(string=? t "Director") (...)]
        [(string=? t "Supervisor") (...)]
        [(string=? t "Employee") (...)]))
       
(define (fn-for-position p)
  (... (position-name p)
       (fn-for-title (position-title p))
       (fn-for-lop (position-subs p))))
       
(define (fn-for-lop lop)
  (cond [(empty? lop) (...)]
        [else 
         (... (fn-for-position (first p))
              (fn-for-lop (rest p)))]))

;; In a terrible coding accident, we have lost the structure definitions, type comments and interpretations for these data types,
;; and we need to reconstruct them from the templates.
;; Title - Enumeration
;; Position - Compoind
;; ListOfPosition - Arbitrary Size

(define-struct position (name title subs))
;; Position is (make-position String Title ListOfPosition)

;; We want to write a function which consumes a name and a position, and produces the position with that name if
;; it exists in the tree under the given position, otherwise false.

;; String Position -> Position or false
;; String ListOfPosition -> Position  or false
;; if a position with the given name exists within the tree, produce that position, otherwise false

(define (find--position n p) false)   ;stubs
(define (find--lop n lop) false)

(define (find--position n p)
  (if (string=? n (position-name p))
      p
      (find--lop n (position-subs p))))

(define (find--lop n lop)
  (cond [(empty? lop) false]
        [else
         (if (not (false? (find--position n (first lop))))
             (find--position n (first lop))
             (find--lop n (rest lop)))]))
