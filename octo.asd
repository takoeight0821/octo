#|
  This file is a part of octo project.
  Copyright (c) 2016 Kono Yuya (takohati0821@gmail.com)
|#

#|
  Author: Kono Yuya (takohati0821@gmail.com)
|#

(in-package :cl-user)
(defpackage octo-asd
  (:use :cl :asdf))
(in-package :octo-asd)

(defsystem octo
  :version "0.1"
  :author "Yuya Kono"
  :license "The MIT License"
  :depends-on (:cl-annot :alexandria)
  :components ((:module "src"
                :components
                        ((:file "package")
			 (:file "octo")
			 (:file "list")
			 (:file "threading")
			 (:file "svg")
                         )))
  :description "Utility collection."
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op octo-test))))
