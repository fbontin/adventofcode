(ns app.day07p2
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

(def data2 "shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.")

(defn parse-inner [inner-v]
  (let [[n c1 c2] (list* (split inner-v #" "))]
    {:n (js/parseInt n)
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

(defn count-bags [rules c n]
  (let [inner (->> rules
                   (filter #(= c (:outer %)))
                   (first)
                   (:inner))]
    (if (= 0 (count inner))
      n
      (->> inner
           (map #(count-bags rules (:c %) (:n %)))
           (map #(* n %))
           (reduce +)
           (+ n)))))

(defn run []
  (-> (parse)
      (count-bags "shiny-gold" 1)
      (#(- % 1)) ; remove the outmost gold bag
      (println)))
