(ns app.day03p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(def data "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#")

(defn parse []
  (->> (read-file "./data/03.txt")
       (split-lines)))

(defn get-pos-for-line [i line]
    {:x (* i 3) :line line})

(defn is-tree-on-pos [{x :x line :line}]
  (->> line
       (count)
       (mod x)
       (nth line)
       (= "#")))

(defn count-trees [lines]
  (->> lines
      (map-indexed get-pos-for-line)
      (filter is-tree-on-pos)))

(defn run []
  (-> (parse)
      (count-trees)
      (count)
      (println)))
