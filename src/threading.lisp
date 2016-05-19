(in-package :octo)

(defmacro -> (x &optional form &rest more)
  "Threads the expr through the forms. Inserts x as the
second item in the first form, making a list of it if it is not a
list already. If there are more forms, inserts the first form as the
second item in second form, etc."
  (cond ((null form) x)
        ((null more) (if (listp form)
                         `(,(car form) ,x ,@(cdr form))
                         (list form x)))
        (t `(-> (-> ,x ,form) ,@more))))

(defmacro ->> (x &optional form &rest more)
  "Threads the expr through the forms. Inserts x as the
last item in the first form, making a list of it if it is not a
list already. If there are more forms, inserts the first form as the
last item in second form, etc."
  (cond ((null form) x)
        ((null more) (if (listp form)
                         (append form (list x))
                         (list form x)))
        (t `(->> (->> ,x ,form) ,@more))))
