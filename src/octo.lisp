(in-package :cl-user)
(defpackage octo
  (:use :cl)
  (:export :let1
           :single
           :alist->plist
           :plist->alist
           :with))
(in-package :octo)

(defmacro let1 (var val &body body)
  `(let ((,var ,val))
     ,@body))

(defun single (list)
  (and (consp list) (not (cdr list))))

(defun alist->plist (alist)
  "Convert a alist into a plist.((a . b) (c . d)) -> (a b c d)"
  (cond ((null alist) nil)
        (t (mapcan #'(lambda (pair) (list (first pair) (rest pair))) alist))))

;;; TODO: もっと読みやすい書き方があるはず。 
(defun make-dotted-list (list)
  "Convert a two-element list into a dotted list."
  (cond ((null list) nil)
        ((not (consp list)) nil)
        ((single list) (first list))
        (t (cons (first list)
                 (make-dotted-list (rest list))))))

(defun plist->alist (plist)
  "Convert a plist into a alist.(a b c d) -> ((a . b) (c . d))"
  (cond ((null plist) nil)
        ((single plist) (list plist))
        ((single (cdr plist)) (list (make-dotted-list plist)))
        (t (append (list (make-dotted-list (subseq plist 0 2)))
                   (plist->alist (subseq plist 2))))))

(defun plist->bindings (plist)
  (mapcar #'(lambda (pair)
              (list (first pair) (rest pair)))
          (plist->alist plist)))
;;; TODOここまで

(defmacro with (bind-plist &body body)
  (let1 bindings (plist->bindings bind-plist)
        `(let ,bindings
           ,@body)))
