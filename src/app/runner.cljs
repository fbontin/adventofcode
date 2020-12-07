(ns app.runner
  (:require [app.day07p2 :refer [run]]))

;; currently broken in shadow-cljs
(set! *warn-on-infer* true)

(defn main []
  (run))
