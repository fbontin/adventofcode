(ns app.day09p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(def part-1-answer 104054607)

(defn parse []
  (->> (read-file "./data/09.txt")
       (split-lines)
       (map js/parseInt)))

(defn splice [start end l]
  (->> l
       (take end)
       (drop start)))

(defn get-sum-for-indices [i j numbers]
  (reduce + 0 (splice i j numbers)))

(defn find-indices [numbers]
  (loop [i 0 j 1]
    (let [sum (get-sum-for-indices i j numbers)]
      (cond
        (= sum part-1-answer) (splice i j numbers)
        (> sum part-1-answer) (recur (inc i) j)
        (< sum part-1-answer) (recur i (inc j))))))

(defn sum-min-max [l]
  (+ (apply min l) (apply max l)))

(defn run []
  (->> (parse)
       (find-indices)
       (sum-min-max)
       (println)))
