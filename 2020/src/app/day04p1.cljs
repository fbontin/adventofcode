(ns app.day04p1
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split]]))

(def data "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in")

(defn remove-linebreaks [str]
  (clojure.string/replace str #"\n" ""))

(defn print-return [arg]
  (println "item: " arg)
  arg)


(defn parse []
  (->>
   (-> (read-file "./data/04.txt")
       (split  #"\n\n"))
   (list*)
   (map remove-linebreaks)))

(defn is-valid [passport]
  (-> passport
      (and
       (re-find #"byr:" passport)
       (re-find #"iyr:" passport)
       (re-find #"eyr:" passport)
       (re-find #"hgt:" passport)
       (re-find #"hcl:" passport)
       (re-find #"ecl:" passport)
       (re-find #"pid:" passport))))

(defn count-valid [passports]
  (->> passports
       (filter is-valid)
       (count)))


(defn run []
  (-> (parse)
      (count-valid)
      (println)))
