(ns app.day03p2
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

(defn get-pos-for-line [i line {d :down r :right}]
  (let [x (/ (* i r) d)]
    {:x x :line line }))

(defn is-tree-on-pos [{x :x line :line}]
  (->> line
       (count)
       (mod x)
       (nth line)
       (= "#")))

(defn count-trees-for-path [lines path]
  (->> lines
       (map-indexed #(get-pos-for-line %1 %2 path))
       ;; only those with where x is an integer are valid
       (filter #(= 0 (mod (:x %) 1))) 
       (filter is-tree-on-pos)))

(def paths '({:right 1 :down 1}
             {:right 3 :down 1}
             {:right 5 :down 1}
             {:right 7 :down 1}
             {:right 1 :down 2}))

(defn count-trees [lines]
  (->> paths
       (map #(count-trees-for-path lines %))
       (map count)
       (reduce #(* %1 %2))))

(defn run []
  (-> (parse)
      (count-trees)
      (println)))
