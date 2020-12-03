(ns app.runner
  (:require [app.day03p1 :refer [run]]))

;; currently broken in shadow-cljs
(set! *warn-on-infer* true)

(defn main []
  (run))
