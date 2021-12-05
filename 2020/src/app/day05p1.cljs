(ns app.day05p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(def data "BFFFBBFRRR\nFFFBBBFRRR\nBBFFBBFRLL")

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

(defn find-highest-seat-id [passes]
  (->> passes
       (map calc-seat-id)
       (sort)
       (last)))

(defn run []
  (->> (parse)
      (find-highest-seat-id)
      (println)))
