(ns app.day14p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines split]]))

(def data "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0")

(defn parse []
  (->> (read-file "./data/14.txt")
  ;(->> data
       (split-lines)
       (list*)))

(defn run-mask [state ins]
  (let [[_ mask] (re-matches #"mask\s=\s([X10]+)" ins)]
    (assoc state :mask mask)))

(defn pad-with-zeros [val len]
  (if (= (count val) len)
    val
    (recur (str "0" val) len)))

(defn calc-with-mask [val mask]
  (let [str-val (pad-with-zeros (.toString val 2) (count mask))]
   (->> mask
       (map-indexed (fn [i m] (let [c (nth str-val i)]
                                (if (= m "X") c m))))
       (apply str)
       (#(js/parseInt % 2)))))

(defn run-mem [{mem :mem mask :mask} ins]
  (let [[_ address dec-val] (re-matches #"mem\[(\d+)\]\s=\s(\d+)" ins)
        val (-> (js/parseInt dec-val)
                (calc-with-mask mask))]
    {:mask mask :mem (assoc mem address val)}))

(defn run-instruction [{mem :mem mask :mask} ins]
  (if (= "a" (nth ins 1))
    (run-mask {:mem mem} ins)
    (run-mem {:mem mem :mask mask} ins)))

(defn run []
  (->> (parse)
       (reduce run-instruction {:mem {} :mask ""})
       ((fn [{mem :mem}] (reduce + (vals mem))))
       (println)))
