#|
  This file is a part of octo project.
  Copyright (c) 2016 Kono Yuya (takohati0821@gmail.com)
|#

(in-package :cl-user)
(defpackage octo-test-asd
  (:use :cl :asdf))
(in-package :octo-test-asd)

(defsystem octo-test
  :author "Kono Yuya"
  :license "MIT"
  :depends-on (:octo
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "octo"))))
  :description "Test system for octo"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
