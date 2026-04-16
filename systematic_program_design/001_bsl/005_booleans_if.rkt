;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 005_booleans_if) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

true
false

(define WIDTH 100)  
(define HEIGHT 100) 

(> WIDTH HEIGHT)    ;false 
(>= WIDTH HEIGHT)   ;true

(= 1 2) ;false
(= 1 1) ;true
(> 3 9) ;false

;(define I1 (rectangle 10 20 "solid" "red"))
;(define I2 (rectangle 20 10 "solid" "blue"))
;
;(< (image-width I1) (image-width I2))
;
;(if (< (image-width I1) (image-height I1))
;    "tall"
;    "wide")
;
;(if (< (image-width I2) (image-height I2))
;    "tall"
;    "wide")
;
;(and (> (image-height I1) (image-height I2))
;    (< (image-width I1) (image-width I2)))