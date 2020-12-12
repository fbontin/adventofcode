(ns app.day12p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(def data "F10
N3
F7
R90
F11")

(defn parse []
  (->> (read-file "./data/12.txt")
  ;(->> data
       (split-lines)
       (list*)))

(defn replace-f [char dir]
  (if (= char "F")
    (case dir
      0 "E"
      90 "N"
      180 "W"
      270 "S")
    char))

(defn turn [dir char n]
  (case char
    "L" (mod (+ dir n) 360)
    "R" (mod (- dir n) 360)))

(defn run-instruction [{x :x y :y dir :dir} ins]
  (let [[_ char num] (re-matches #"(\w)(\d+)" ins)
        n (js/parseInt num)]
    (case (replace-f char dir)
      "N" {:x x :y (+ y n) :dir dir}
      "S" {:x x :y (- y n) :dir dir}
      "E" {:x (+ x n) :y y :dir dir}
      "W" {:x (- x n) :y y :dir dir}
      "L" {:x x :y y :dir (turn dir char n)}
      "R" {:x x :y y :dir (turn dir char n)})))

(defn run-instructions [instructions]
  (reduce run-instruction {:x 0 :y 0 :dir 0} instructions))

(defn calc-manhattan-distance [{x :x y :y}]
  (+ (Math/abs x) (Math/abs y)))

(defn run []
  (->> (parse)
       (run-instructions)
       (calc-manhattan-distance)
       (println)))
