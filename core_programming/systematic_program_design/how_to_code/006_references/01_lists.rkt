;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 01_lists) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

empty

(empty? empty)
 
(define L1 (cons "Flames" empty))                ; a list of 1 elemet

(define L2 (cons "Leafs" (cons "Flames" empty))) ; a list of 2 elemets

(define L3 (cons 10 (cons 9 (cons 8 empty))))  ; a list of 3 elements

(define L4 (cons (square 10 "solid" "blue")
      (cons (triangle 20 "solid" "green")
            empty)))

(first L1)
(first L2)
(first L3)
(first L4)

(rest L1)
(rest L2)
(rest L3)
(rest L4)

; how do I get the second element of a list 
(first (rest L3))

; how do I get the third element of a list 
(first (rest(rest L3)))

