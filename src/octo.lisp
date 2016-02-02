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

(declaim (inline safe-endp))
(defun safe-endp (x)
  (declare (optimize safety))
  (endp x))

(defun plist->bindings (plist)
  (let (bindings)
    (do ((tail plist (cddr tail)))
        ((safe-endp tail) (nreverse bindings))
      (push `(,(first tail) ,(second tail)) bindings))))

(defmacro where (bind-plist &body body)
  (let1 bindings (plist->bindings bind-plist)
        `(let ,bindings
           ,@body)))
