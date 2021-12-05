(ns app.day05p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(defn parse []
  (-> (read-file "./data/05.txt")
      (split-lines)
      (list*)))

(defn calc-row [pass]
  (-> pass
      (subs 0 7)
      (clojure.string/replace #"B" "1")
      (clojure.string/replace #"F" "0")
      (js/parseInt 2)))

(defn calc-column [pass]
  (-> pass
      (subs 7)
      (clojure.string/replace #"R" "1")
      (clojure.string/replace #"L" "0")
      (js/parseInt 2)))

(defn calc-seat-id [pass]
  (let [row (calc-row pass)
        column (calc-column pass)]
    (+ (* row 8) column)))

(defn sum-sequence [lowest highest]
  (->> (range lowest (inc highest))
       (reduce +)))

(defn find-missing-seat [seat-ids]
  (let [sorted (sort seat-ids)
        lowest (first sorted)
        highest (last sorted)
        expected-sum (sum-sequence lowest highest)
        sum (reduce + sorted)]
    (- expected-sum sum)))

(defn run []
  (->> (parse)
       (map calc-seat-id)
       (find-missing-seat)
       (println)))
