(ns app.day07p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split split-lines]]))

(def data "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.")

(defn parse-inner [inner-v]
  (let [[n c1 c2] (list* (split inner-v #" "))]
    {:n n
     :c (str c1 "-" c2)}))

(defn parse-inners [inner-str]
  (->> (re-seq #"\d\s\w+\s\w+" inner-str)
       (map parse-inner)))

(defn parse-rule [row]
  (let [[outer-str inner-str] (split row " bags contain ")
        outer (clojure.string/replace outer-str " " "-")
        inner (parse-inners inner-str)]
    {:outer outer :inner inner}))

(defn parse []
  (->> (read-file "./data/07.txt")
       (split-lines)
       (list*)
       (map parse-rule)))

(defn has-inner-color [rule c]
  (->> (:inner rule)
       (filter #(= c (:c %)))
       (count)
       (not= 0)))

(defn find-bags [rules c]
  (let [with-inner (filter #(has-inner-color % c) rules)]
    (->> with-inner
         (mapcat #(find-bags rules (:outer %)))
         (concat with-inner)
         (distinct))))

(defn run []
  (-> (parse)
      (find-bags "shiny-gold")
      (count)
      (println)))
