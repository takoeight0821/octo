(in-package :cl-user)
(defpackage octo
  (:use :cl :cl-annot)
  (:import-from :alexandria
                :proper-list-p
                :plist-alist)
  (:export :let1
           :dotted-list->proper-list
           :where))
(in-package :octo)

(annot:enable-annot-syntax)

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

(defun alist-parameter (alist)
  (mapcar #'dotted-list->-proper-list alist))

(defmacro where (bind-plist &body body)
  (let1 bindings (alist-parameter (plist-alist bind-plist))
        `(let ,bindings
           ,@body)))
