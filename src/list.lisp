(in-package :octo)

(defun map-when (pred rep list)
  (if (null list)
      nil
      (cons
       (if (funcall pred (first list))
           (funcall rep (first list))
           (first list))
       (map-when pred rep (rest list)))))

(defun map-first (pred rep list)
  (if (null list)
      nil
      (if (funcall pred (first list))
          (cons (funcall rep (first list)) (rest list))
          (cons (first list) (map-first pred rep (rest list))))))

(defun map-last (pred req list)
  (nreverse (map-first pred req (reverse list))))

(defun map-indexed (fn list)
  (loop :for i :from 0 :to (1- (length list))
        :for x :in list
        :collect (funcall fn i x)))

(defun annotate (fn list)
  (loop :for x :in list
        :collect (cons (funcall fn x) x)))

(defun splice (pred fn list)
  (if (null list)
      nil
      (if (funcall pred (first list))
          `(,@(funcall fn (first list)) ,@(splice pred fn (rest list)))
          `(,(first list) ,@(splice pred fn (rest list))))))

(defun splice-list (pred new-list list)
  (splice pred (lambda (x) (declare (ignore x)) new-list) list))

(defun mapcat (fn list)
  (if (null list)
      nil
      (append (funcall fn (first list)) (mapcat fn (rest list)))))


