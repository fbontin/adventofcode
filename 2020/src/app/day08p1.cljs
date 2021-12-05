(ns app.day08p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines split]]))

(def data "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6")

(defn parse []
  (->> (read-file "./data/08.txt")
       (split-lines)
       (list*)))

(defn parse-action [action]
  (let [[_ sign num] (re-find #"([+-])(\d+)" action)
        number (js/parseInt num)]
    (case sign
      "+" number
      "-" (- number))))

(defn parse-instruction [n acc in]
  (let [[word action] (split in #" ")]
    (case word
      "nop" {:n (inc n) :acc acc}
      "acc" {:n (inc n) :acc (+ acc (parse-action action))}
      "jmp" {:n (+ n (parse-action action)) :acc acc})))


(defn run-instructions [n acc visited ins]
  (if (some #(= n %) visited)
    acc
    (->> (nth ins n)
         (parse-instruction n acc)
         (#(run-instructions (:n %) (:acc %) (cons n visited) ins)))))

(defn run []
  (->> (parse)
       (run-instructions 0 0 '())
       (println)))
