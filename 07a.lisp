(ql:quickload "str")

(defun compute-solutions (l)
  (cond ((rest (rest l))
         (mapcan #'(lambda (x) (list (* (first l) x) (+ (first l) x)))
                 (compute-solutions (rest l))))
        (t (list (* (first l) (second l)) (+ (first l) (second l))))))

(defun has-solution (test-value operands)
  (find test-value (compute-solutions (reverse operands))))

(defun get-equation (line)
  (list
    (parse-integer (first (str:split ": " line)))
    (mapcar #'parse-integer (str:split " " (second (str:split ": " line)))))) 

(defun read-equations (stream)
  (let ((line (read-line stream nil)))
    (cond (line (cons (get-equation line) (read-equations stream)))
          (t nil))))

(defun solve (stream)
  (apply #'+ (mapcar #'(lambda (x) (or (has-solution (first x) (second x)) 0))
                     (read-equations stream))))

(format t "~A~%" (solve *standard-input*))
