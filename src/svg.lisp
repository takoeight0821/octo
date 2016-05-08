(in-package :cl-user)
(defpackage :octo.svg
  (:use :cl :cl-annot :octo))
(in-package :octo.svg)

(annot:enable-annot-syntax)

(defun print-tag (name alist closingp)
  (princ #\<)
  (when closingp
    (princ #\/))
  (princ (string-downcase name))
  (mapc (lambda (att)
          (format t " ~a=\"~a\"" (string-downcase (car att)) (cdr att)))
        alist)
  (princ #\>))

@export
(defmacro tag (name atts &body body)
  `(progn (print-tag ',name
                     (list ,@(mapcar (lambda (x)
                                       `(cons ',(car x) ,(cdr x)))
                                     (loop for (k v) on atts by #'cddr
                                           collect (cons (string-downcase k) v))))
                     nil)
          ,@body
          (print-tag ',name nil t)))

@export
(defmacro html (&body body)
  `(tag html ()
        ,@body))

@export
(defmacro body (&body body)
  `(tag body ()
        ,@body))

@export
(defmacro svg (width height &body body)
  `(tag svg (xmlns "http://www.w3.org/2000/svg"
                   "xmlns:xlink" "http://www.w3.org/1999/xlink" height ,height width ,width)
        ,@body))

@export
(defun brightness (col amt)
  (mapcar (lambda (x)
            (min 255 (max 0 (+ x amt))))
          col))

@export
(defun svg-style (color)
  (format nil
          "~{fill:rgb(~a,~a,~a);stroke:rgb(~a,~a,~a)~}"
          (append color
                  (brightness color -100))))

@export
(defun circle (center radius color)
  (tag circle (cx (car center) cy (cdr center) r radius style (svg-style color))))

@export
(defun polygon (points color)
  (tag polygon (points (format nil
                               "~{~a,~a ~}"
                               (mapcan (lambda (tp)
                                         (list (car tp) (cdr tp)))
                                       points))
                style (svg-style color))))

@export
(defun rect (pos size color)
  (tag rect (x (car pos) y (cdr pos)
               width (car size) height (cdr size)
               style (svg-style color))))

(defparameter *rgb*
  ;; https://ja.wikipedia.org/wiki/ウェブカラー 参照
  '((white 255 255 255) (silver 192 192 192) (gray 128 128 128) (black 0 0 0)
    (red 255 0 0) (maroon 128 0 0) (yellow 255 255 0) (olive 128 128 0)
    (lime 0 255 0) (green 0 50 0) (aqua 0 255 255) (teal 0 128 128)
    (blue 0 0 255) (navy 0 0 128) (fuchsia 255 0 255) (purple 128 0 128)))

@export
(defun get-color (name &optional (amt 0))
  (brightness (cdr (assoc name *rgb*)) amt))

