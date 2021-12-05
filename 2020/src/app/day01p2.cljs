(ns app.day01p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

;; (def data "1721\n979\n366\n299\n675\n1456")

(defn parse-int [str]
  (js/parseInt str))

(defn parse []
  (let [input (read-file "./data/01.txt")
        str-vector (split-lines input)
        str-list (list* str-vector)
        numbers (map parse-int str-list)]
    numbers))

(defn create-sum-2 [n, m]
  {:n n :m m :sum (+ n m)})

(defn combine-2 [numbers n]
  (map #(create-sum-2 n %) numbers))

(defn create-sum-3 [comb, o]
  (merge comb {:o o :sum (+ o (:sum comb))}))

(defn combine-3 [combined n]
  (map #(create-sum-3 n %) combined))

(defn distinct-by-sum [coll]
  (->> coll
       (group-by :sum)
       (vals)
       (map first)))

(defn find-numbers [numbers]
  (->> numbers
       (map #(combine-2 numbers %))
       (reduce #(concat %1 %2))
       (distinct-by-sum)
       (map #(combine-3 numbers %))
       (reduce #(concat %1 %2))
       (filter #(= 2020 (:sum %)))
       (first)))

(defn run []
  (let [numbers (parse)
        result (find-numbers numbers)]
    (println (* (:n result) (:m result) (:o result)))))