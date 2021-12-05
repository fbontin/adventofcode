(ns app.day02p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split-lines split]]))

(def data "1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc")

(defn parse-int [str]
  (js/parseInt str))

(defn parse-max-min [str]
  (let [max-min (split str "-")]
    { :min (-> max-min 
               (first) 
               (parse-int)) 
     :max (-> max-min 
              (last)
              (parse-int))}))

(defn parse-char [str]
  (-> str
      (split #"")
      (nth 1))) ;; for some reason the char is in position 1

(defn parse-line [line]
  (let [splitted (split line #" ")
        max-min (parse-max-min (first splitted))
        char (parse-char (nth splitted 1))
        password (nth splitted 2)]
    (merge max-min {:char char :password password})))

(defn parse []
  (->> (read-file "./data/02.txt")
       (split-lines)
       (list*)
       (map #(parse-line %))))

(defn is-valid [line]
  (let [password (:password line)
        char (:char line)
        reg (re-pattern char)
        count (count (re-seq reg password))
        min (:min line)
        max (:max line)]
    (and (>= count min) (<= count max))))

(defn remove-unvalid [lines]
  (filter is-valid lines))

(defn run []
  (-> (parse)
      (remove-unvalid)
      (count)
      (println)))
