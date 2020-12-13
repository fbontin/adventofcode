(ns app.day13p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines split]]))

(def data "939
7,13,x,x,59,x,31,19")

(defn parse []
  (->> (read-file "./data/13.txt")
  ;(->> data
       (split-lines)
       (list*)))

(def dep-time (js/parseInt (first (parse))))
(def lines (->> (second (parse))
                (#(split % #","))
                (remove #(= % "x"))
                (map js/parseInt)))

(defn get-time-after-dep [line]
  (loop [t 0]
    (if (>= t dep-time)
      {:t t :line line}
      (recur (+ t line)))))

(defn multiply [{t :t line :line}]
  (* line (- t dep-time)))

(defn run []
  (->> lines
       (map get-time-after-dep)
       (sort-by :t)
       (first)
       ((fn [{t :t line :line}] (* line (- t dep-time))))
       (println)))
