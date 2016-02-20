(in-package :cl-user)
(defpackage octo
  (:use :cl)
  (:import-from :alexandria
                :proper-list-p)
  (:export :let1
           :dotted-list->proper-list
           :with
           :for))
(in-package :octo)

(defmacro let1 (var val &body body)
  `(let ((,var ,val))
     ,@body))

(defun dotted-list->proper-list (list)
  (if (proper-list-p list)
      list
      (labels ((f (list)
                 (if (consp list)
                     (cons (car list) (f (cdr list)))
                     (cons list nil))))
        (f list))))

(declaim (inline safe-endp))
(defun safe-endp (x)
  (declare (optimize safety))
  (endp x))

(defun plist->bindings (plist)
  (let (bindings)
    (do ((tail plist (cddr tail)))
        ((safe-endp tail) (nreverse bindings))
      (push `(,(first tail) ,(second tail)) bindings))))

(defmacro with (bind-plist &body body)
  (let1 bindings (plist->bindings bind-plist)
        `(let ,bindings
           ,@body)))

(defmacro for ((var start stop) &body body)
  (let1 gstop (gensym)
        `(do ((,var ,start (1+ ,var)))
             ((> ,var ,stop))
           ,@body)))
