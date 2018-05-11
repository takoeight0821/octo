(defpackage :octo
  (:use :cl :alexandria)
  ;; threading.lisp
  (:export #:->
           #:->>)
  ;; octo.lisp
  (:export #:let1
	   #:last1
	   #:singlep
	   #:append1
	   #:conc1
	   #:mklist 
	   #:alist->plist
	   #:make-dotted-list
	   #:plist->alist
	   #:plist->bindings
	   #:with)
  ;; list.lisp
  (:export #:map-when
	   #:map-first
	   #:map-last
	   #:map-indexed
	   #:annotate
	   #:splice
	   #:splice-list
	   #:mapcat))
