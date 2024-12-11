(defun is-even (n) (= 0 (rem (length (format nil "~D" n)) 2)))

(defun split (n)
  (let ((s (format nil "~D" n)))
    (mapcar #'parse-integer (list (subseq s 0 (/ (length s) 2))
                                  (subseq s (/ (length s) 2))))))

(defun blink (stones n)
  (cond ((= n 0) stones)
        (t (mapcan #'(lambda (x)
                       (cond ((= 0 x) (list 1))
                             ((is-even x) (split x))
                             (t (list (* x 2024)))))
                   (blink stones (1- n))))))

(defun read-stones (stream)
  (do ((stones nil) (stone (read stream nil) (read stream nil)))
      ((not stone) stones)
    (push stone stones)))

(format t "~A~%" (length (blink (read-stones *standard-input*) 25)))
