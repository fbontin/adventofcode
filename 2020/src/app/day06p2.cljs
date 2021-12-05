(ns app.day06p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split split-lines]]))

(def data "abc

a
b
c

ab
ac

a
a
a
a

b")

(defn parse []
  (-> (read-file "./data/06.txt")
      (split "\n\n")
      (list*)))

(defn is-in-every-line [char chars nbr-lines]
  (->> (split chars "")
       (filter #(= % char))
       (count)
       (= nbr-lines)))

(defn count-group [group]
  (let [nbr-lines (count (split-lines group))]
    (->> (split group "")
         (list*)
         (filter #(not= "\n" %))
         (filter #(is-in-every-line % chars nbr-lines))
         (distinct)
         (count))))

(defn count-groups [groups]
  (->> groups
       (map count-group)
       (reduce +)))

(defn run []
  (->> (parse)
       (count-groups)
       (println)))
