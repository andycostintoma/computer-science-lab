;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 03_struct) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct pos (x y))

; constructors
(define P1 (make-pos 3 6))
(define P2 (make-pos 2 8))

P1
P2

; selectors
(pos-x P1)
(pos-y P1)

; predicate
(pos? P1)
(pos? "hello")

  