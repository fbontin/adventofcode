(ns app.day06p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split]]))

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

(defn count-group [group]
  (->> (split group "")
       (list*)
       (distinct)
       (filter #(not= "\n" %))
       (count)))

(defn count-groups [groups]
  (->> groups
       (map count-group)
       (reduce +)))

(defn run []
  (->> (parse)
       (count-groups)
       (println)))
