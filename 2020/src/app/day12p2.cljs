(ns app.day12p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(def data "F10
N3
F7
R90
F11")

(defn parse []
  (->> (read-file "./data/12.txt")
       (split-lines)
       (list*)))

(defn rotate-waypoint [obj char n]
  (let [{xw :xw yw :yw} obj
        calc (case char
               "L" (case n
                     90  {:xw (- 0 yw) :yw xw}
                     180 {:xw (- 0 xw) :yw (- 0 yw)}
                     270 {:xw yw :yw (- 0 xw)})
               "R" (case n
                     90 {:xw yw :yw (- 0 xw)}
                     180 {:xw (- 0 xw) :yw (- 0 yw)}
                     270  {:xw (- 0 yw) :yw xw}))]
    (merge obj calc)))

(defn forward [obj n]
  (let [{x :x y :y xw :xw yw :yw} obj
        newx (+ x (* xw n))
        newy (+ y (* yw n))]
    {:x newx :y newy :xw xw :yw yw}))

(defn run-instruction [obj ins]
  (let [{x :x y :y xw :xw yw :yw} obj
        [_ char num] (re-matches #"(\w)(\d+)" ins)
        n (js/parseInt num)]
    (case char
      "N" {:x x :y y :xw xw :yw (+ yw n)}
      "S" {:x x :y y :xw xw :yw (- yw n)}
      "E" {:x x :y y :xw (+ xw n) :yw yw}
      "W" {:x x :y y :xw (- xw n) :yw yw}
      "L" (rotate-waypoint obj char n)
      "R" (rotate-waypoint obj char n)
      "F" (forward obj n))))

(defn run-instructions [instructions]
  (reduce run-instruction {:x 0 :y 0 :xw 10 :yw 1} instructions))

(defn calc-manhattan-distance [{x :x y :y}]
  (+ (Math/abs x) (Math/abs y)))

(defn run []
  (->> (parse)
       (run-instructions)
       (calc-manhattan-distance)
       (println)))
