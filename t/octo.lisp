(in-package :cl-user)
(defpackage octo-test
  (:use :cl
        :octo
        :prove))
(in-package :octo-test)

;; NOTE: To run this test file, execute `(asdf:test-system :octo)' in your Lisp.

(setf *enable-colors* nil)

(plan 11)

(subtest "let1 test"
  (is-expand (let1 foo "bar" 'baz)
	     (let ((foo "bar"))
	       'baz)))

(subtest "last1 test"
  (is (last1 '(1 2 3)) 3))

(subtest "signlep test"
  (ok (singlep '(foo)))
  (is (singlep '(foo bar)) nil)
  (is (singlep '()) nil))

(subtest "append1 test"
  (is (append1 '(foo bar) 'baz)
      '(foo bar baz)))

(subtest "conc1 test"
  (is (conc1 '(foo bar) 'baz)
      '(foo bar baz)))

(subtest "mklist test"
  (is (mklist 'foo) '(foo))
  (is (mklist '(bar)) '(bar)))

(subtest "alist->plist test"
  (is (alist->plist '((a . b) (c . d)))
      '(a b c d)))

(subtest "make-dotted-list test"
  (is (make-dotted-list '(foo bar))
      '(foo . bar))
  (is (make-dotted-list '(foo bar baz))
      '(foo bar . baz))
  (is (make-dotted-list '(foo))
      'foo)
  (is (make-dotted-list nil)
      nil)
  (is (make-dotted-list '(foo . bar))
      '(foo . bar)))

(subtest "plist->alist test"
  (is (plist->alist '(a b c d))
      '((a . b) (c . d))))

(subtest "plist->bindings test"
  (is (plist->bindings '(a b c d))
      '((a b) (c d))))

(subtest "with test"
  (is-expand (with (a b c d) 'foo)
	     (let ((a b) (c d) 'foo))))

(finalize)
