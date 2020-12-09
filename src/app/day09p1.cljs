(ns app.day09p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(def preamble-length 25)

(defn parse []
  (->> (read-file "./data/09.txt")
       (split-lines)
       (list*)
       (map js/parseInt)))

(defn take-in-middle [start l]
  (->> l 
       (drop start) 
       (take preamble-length)))

(defn is-invalid [i num numbers]
  (let [numbers-to-check (take-in-middle i numbers)]
    (->> numbers-to-check
         (map #(- num %))
         (filter (fn [n] (some #(= n %) numbers)))
         (filter #(not= (* 2 %) num))
         (count)
         (#(< % 2)); % < 2
         )))

(defn find-invalid-number [numbers]
  (->> numbers
       (drop preamble-length)
       (map-indexed (fn [i num] [i num]))
       (filter (fn [[i num]] (is-invalid i num numbers)))
       (first)
       (second)))

(defn run []
  (->> (parse)
       (find-invalid-number)
       (println)))
