;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 05_product-tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Use an accumulator to design a tail-recursive version of product.

;; (listof Number) -> Number
;; produce the product of all the numbers in lon
(check-expect (product empty) 1)
(check-expect (product (list 1 2 3)) 6)
(check-expect (product (list 2.5 1 -4)) -10)

#;
(define (product lon)
  (cond [(empty? lon) 1]
        [else
         (* (first lon)
            (product (rest lon)))]))

(define (product lon0)
  ;; acc: Number; the sum of the elemets of lon0 seen so far
  ;; (product (list 2 3 4))
  ;; (product (list 2 3 4) 1)
  ;; (product (list   3 4) 2)
  ;; (product (list     4) 6)
  ;; (product (list      ) 24)
  (local [(define (product lon acc)
            (cond [(empty? lon) acc]
                  [else
                   (product (rest lon)
                            (* acc (first lon)))]))]
    (product lon0 1)))

