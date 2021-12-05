(ns app.day04p2
  (:require [app.reader :refer [read-file]])
  (:require [clojure.string :refer [split]]))

(def valid-data "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
")

(def invalid-data "eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007")

(defn parse []
  (->>
   (-> (read-file "./data/04.txt")
       (split  #"\n\n"))
   (list*)
   ;; add an extra space so all fields have a space after them
   (map #(str % " ")))) 

(defn valid-year [value min max]
  (if value
    (->> value
         (js/parseInt)
         (#(and (>= % min) (<= % max))))
    false))

(defn valid-byr [passport]
  (-> (re-find #"byr:(\d+)" passport)
      (second)
      (valid-year 1920 2002)))

(defn valid-iyr [passport]
  (-> (re-find #"iyr:(\d+)" passport)
      (second)
      (valid-year 2010 2020)))

(defn valid-eyr [passport]
  (-> (re-find #"eyr:(\d+)" passport)
      (second)
      (valid-year 2020 2030)))

(defn hgt-in-bounds [hgt]
  (let [n (js/parseInt (re-find #"\d+" hgt))
        unit (re-find #"in|cm" hgt)]
    (if (= unit "cm")
      (and (>= n 150) (<= n 193))
      (and (>= n 59) (<= n 76)))))

(defn valid-hgt [passport]
  (let [hgt (first (re-find #"hgt:\d+(in|cm)" passport))]
    (if hgt
      (hgt-in-bounds hgt)
      false)))

(defn valid-hcl [passport]
  (re-find #"hcl:#[0-9a-f]{6}\s" passport))

(defn valid-ecl [passport]
  (re-find #"ecl:amb|blu|brn|gry|grn|hzl|oth\s" passport))

(defn valid-pid [passport]
  (re-find #"pid:[0-9]{9}\s" passport))

(defn is-valid [passport]
  (and
   (valid-byr passport)
   (valid-iyr passport)
   (valid-eyr passport)
   (valid-hgt passport)
   (valid-hcl passport)
   (valid-ecl passport)
   (valid-pid passport)))

(defn count-valid [passports]
  (->> passports
       (filter is-valid)
       (count)))

(defn run []
  (-> (parse)
      (count-valid)
      (println)))
