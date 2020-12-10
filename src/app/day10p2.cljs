(ns app.day10p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(defn parse []
  (->> (read-file "./data/10.txt")
       (split-lines)
       (list*)
       (map js/parseInt)))

; memo-find is a memoized version of find-ways
; not very pretty, and too terse, but it's late
(defn find-ways [i memo-find adapters]
  (if
   (= (inc i) (count adapters))
    1
    (->> (range (inc i) (+ i 3 1))                    ; get three subsequent indices
         (filter #(<= % (- (count adapters) 1)))      ; remove too big indices
         (map (fn [n] {:a (nth adapters n) :n n}))    ; map index to value and index
         (filter #(<= (- (:a %) (nth adapters i)) 3)) ; remove those more than 3 away
         (map #(memo-find (:n %) memo-find adapters)) ; for each, find the next way
         (reduce + 0))))                              ; sum each

(defn run []
  (->> (parse)
       (cons 0)
       (sort)
       (find-ways 0 (memoize find-ways))
       (println)))
