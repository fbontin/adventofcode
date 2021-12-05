(ns app.day10p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines]]))

(def data "16
10
15
5
1
11
7
19
6
12
4")

(def data2 "28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3")

(defn parse []
  ;(->> data2
  (->> (read-file "./data/10.txt")
       (split-lines)
       (list*)
       (map js/parseInt)))

(defn find-result [adapters]
  (let [sorted (sort adapters)
        nbr-adapters (count adapters)]
    (loop [i 0 n1 1 n3 1]
        (if (>= (inc i) nbr-adapters)
          [n1 n3]
          (case (- (nth sorted (inc i)) (nth sorted i))
            1 (recur (inc i) (inc n1) n3)
            2 (recur (inc i) n1       n3)
            3 (recur (inc i) n1       (inc n3)))))))

(defn run []
  (->> (parse)
       (find-result)
       (#(* (first %) (second %)))
       (println)))
