(ns app.runner
  (:require [app.day09p1 :refer [run]]))

;; currently broken in shadow-cljs
(set! *warn-on-infer* true)

(defn main []
  (run))
