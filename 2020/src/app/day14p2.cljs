(ns app.day14p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines replace-first]]))

(defn parse []
  (->> (read-file "./data/14.txt")
       (split-lines)
       (list*)))

(defn run-mask [state ins]
  (let [[_ mask] (re-matches #"mask\s=\s([X10]+)" ins)]
    (assoc state :mask mask)))

(defn pad-with-zeros [val len]
  (if (= (count val) len)
    val
    (recur (str "0" val) len)))

(defn calc-addresses [addresses]
  (->> addresses
       (map (fn [addr] (if (some #(= % "X") addr)
                         (calc-addresses
                          [(replace-first addr "X" "0")
                           (replace-first addr "X" "1")])
                         addr)))
       (flatten)))

(defn calc-with-mask [val mask address]
  (let [str-addr (pad-with-zeros (.toString address 2) (count mask))
        masked (->> mask
                    (map-indexed (fn [i m] (let [c (nth str-addr i)]
                                             (if (= m "0") c m))))
                    (apply str))
        addresses (map #(js/parseInt % 2) (calc-addresses [masked]))]
    (reduce #(assoc %1 %2 val) {} addresses)))

(defn run-mem [{mem :mem mask :mask} ins]
  (let [[_ address dec-val] (re-matches #"mem\[(\d+)\]\s=\s(\d+)" ins)]
    {:mask mask
     :mem (merge
           mem
           (calc-with-mask
            (js/parseInt dec-val)
            mask
            (js/parseInt address)))}))

(defn run-instruction [{mem :mem mask :mask} ins]
  (if (= "a" (nth ins 1))
    (run-mask {:mem mem} ins)
    (run-mem {:mem mem :mask mask} ins)))

(defn run []
  (->> (parse)
       (reduce run-instruction {:mem {} :mask ""})
       ((fn [{mem :mem}] (reduce + (vals mem))))
       (println)))
