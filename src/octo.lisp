(in-package :cl-user)
(defpackage octo
  (:use :cl)
  (:export
   :let1
   :last1
   :singlep
   :append1
   :conc1
   :mklist 
   :alist->plist
   :plist->alist
   :with))
(in-package :octo)

(defmacro let1 (var val &body body)
  `(let ((,var ,val))
     ,@body))

(defun last1 (list)
  "Return the last element of list."
  (first (last1 list)))

(defun singlep (list)
  (and (consp list) (not (cdr list))))

(defun append1 (list obj)
  (append list (list obj)))

(defun conc1 (list obj)
  (nconc list (list obj)))

(defun mklist (obj)
  (if (listp obj) obj (list obj)))

(defun alist->plist (alist)
  "Convert a alist into a plist. For example, ((a . b) (c . d)) -> (a b c d)"
  (cond ((null alist) nil)
        (t (mapcan (lambda (pair) (list (car pair) (cdr pair))) alist))))

;;; TODO: もっと読みやすい書き方があるはず。 
(defun make-dotted-list (list)
  "Convert a two-element list into a dotted list."
  (cond ((null list) nil)
        ((not (consp list)) nil)
        ((singlep list) (first list))
        (t (cons (first list)
                 (make-dotted-list (rest list))))))

(defun plist->alist (plist)
  "Convert a plist into a alist. For example, (a b c d) -> ((a . b) (c . d))"
  (cond ((null plist) nil)
        ((singlep plist) (list plist))
        ((singlep (cdr plist)) (list (make-dotted-list plist)))
        (t (append (list (make-dotted-list (subseq plist 0 2)))
                   (plist->alist (subseq plist 2))))))

(defun plist->bindings (plist)
  (mapcar (lambda (pair)
            (list (car pair) (cdr pair)))
          (plist->alist plist)))

(defmacro with (bind-plist &body body)
  (let1 bindings (plist->bindings bind-plist)
        `(let ,bindings
           ,@body)))
