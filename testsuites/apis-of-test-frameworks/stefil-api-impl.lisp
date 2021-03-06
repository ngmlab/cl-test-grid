(defpackage #:stefil-api-impl
  (:use #:cl :stefil-api))

(in-package #:stefil-api-impl)

(defun print-details (test-suite-result)
    (format t "~&~%-------------------------------------------------------------------------------------------------~%")
    (format t "The test result details (printed by cl-test-grid in addition to the standard Stefil output above)~%")
    (format t "~%(DESCRIBE RESULT):~%")
    (describe test-suite-result)
    (format t "~&~%Individual failures:~%")
    (map 'nil
         (lambda (descr) (format t "~A~%" descr))
         (stefil::failure-descriptions-of test-suite-result)))

(defun run-test-suite (test-suite-name)
  (let* ((*debug-io* *standard-output*)
         (result (stefil:funcall-test-with-feedback-message test-suite-name)))
    (print-details result)
    result))

(defun test-name (failure-description)
  (let ((hierarchical-names  (mapcar 
                              #'(lambda (context) 
                                  (stefil::name-of
                                   (stefil::test-of context)))
                              (stefil::test-context-backtrace-of failure-description))))
    (format nil "~(~{~A~^.~}~)" (nreverse hierarchical-names))))

(defun failed-tests (test-suite-result)
  (remove-duplicates (map 'list
                          #'test-name
                          (stefil::failure-descriptions-of test-suite-result))
                     :test #'string=))