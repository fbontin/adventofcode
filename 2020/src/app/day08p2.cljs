(ns app.day08p2
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

(defn parse-d [str]
  (let [[_ sign num] (re-find #"([+-])(\d+)" str)
        d (js/parseInt num)]
    (case sign
      "+" d
      "-" (- d))))

(defn parse-instruction [in]
  (let [[word d] (split in #" ")]
    {:word word :d (parse-d d)}))

(defn modify-instruction [word n ins]
  (let [row (nth ins n)
        new-word (if (= word "jmp") "nop" "jmp")]
    (map-indexed
     #(if (= n %1) {:word new-word :d (:d row)} %2)
     ins)))

(defn modify-instructions [ins]
  (->> ins
       (map :word)
       (map-indexed (fn [n word] {:word word :n n}))
       (filter #(or (= "jmp" (:word %)) (= "nop" (:word %))))
       (map #(modify-instruction (:word %) (:n %) ins))))

(defn run-instruction [n acc in]
  (case (:word in)
    "nop" {:n (inc n) :acc acc}
    "acc" {:n (inc n) :acc (+ acc (:d in))}
    "jmp" {:n (+ n (:d in)) :acc acc}))

(defn run-instructions [n acc visited ins]
  (cond
    (>= n (count ins)) acc ; finished properly
    (some #(= n %) visited) nil ; infinite loop
    :else
    (->> (nth ins n)
         (run-instruction n acc)
         (#(run-instructions (:n %) (:acc %) (cons n visited) ins)))))

(defn run []
  (->> (parse)
       (map parse-instruction)
       (modify-instructions)
       (map #(run-instructions 0 0 '() %))
       (filter identity)
       (first)
       (println)))
