(ns app.day01p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

;; (def data "1721\n979\n366\n299\n675\n1456")

(defn parse []
  (->> (read-file "./data/01.txt")
       (split-lines)
       (list*)
       (map js/parseInt)))

(defn create-sum [n, m]
  {:n n :m m :sum (+ n m)})

(defn combine [numbers n]
  (map #(create-sum n %) numbers))

(defn find-numbers [numbers]
  (->> numbers
       (map #(combine numbers %))
       (reduce #(concat %1 %2))
       (filter #(= 2020 (:sum %)))
       (first)))

(defn run []
  (let [numbers (parse)
        result (find-numbers numbers)]
    (println (* (:n result) (:m result)))))