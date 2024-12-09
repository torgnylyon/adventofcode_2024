(defun read-board (stream)
  (do ((line (read-line stream nil) (read-line stream nil))
       (board (make-array '(0 0) :adjustable t)))
      ((not line) board)
    (adjust-array board (list (1+ (array-dimension board 0)) (length line)))
    (dotimes (i (length line))
      (setf (aref board (1- (array-dimension board 0)) i) (char line i)))))

(defun get-guard (board)
  (dotimes (line (array-dimension board 0))
    (dotimes (column (array-dimension board 1))
      (if (find (aref board line column) "^>v<")
          (return-from get-guard (list line column
                                       (aref board line column)))))))

(defun turn-guard (guard)
  (list (first guard) (second guard)
        (cond ((char= (third guard) #\^) #\>)
              ((char= (third guard) #\>) #\v)
              ((char= (third guard) #\v) #\<)
              ((char= (third guard) #\<) #\^))))

(defun is-obstacle (board line column)
  (char= (aref board line column) #\#))

(defun is-outside (board line column)
  (or (< line 0) (< column 0)
      (>= line (array-dimension board 0))
      (>= column (array-dimension board 1))))

(defun get-next (guard)
  (append
    (cond ((char= (third guard) #\^) (list (1- (first guard)) (second guard)))
          ((char= (third guard) #\>) (list (first guard) (1+ (second guard))))
          ((char= (third guard) #\v) (list (1+ (first guard)) (second guard)))
          ((char= (third guard) #\<) (list (first guard) (1- (second guard)))))
    (list (third guard))))

(defun mark-board (board line column)
  (setf (aref board line column) #\X))

(defun count-board (board)
  (do ((i 0 (1+ i)) (n 0)) ((= i (array-total-size board)) n)
    (if (char= (row-major-aref board i) #\X)(incf n))))

(defun move-guard (board guard)
  (mark-board board (first guard) (second guard))
  (let ((next (get-next guard)))
    (cond ((is-outside board (first next) (second next))
           (count-board board))
          ((is-obstacle board (first next) (second next))
           (move-guard board (turn-guard guard)))
          (t (move-guard board next)))))

(defun solve (stream)
  (let ((board (read-board stream)))
    (format t "~A~%" (move-guard board (get-guard board)))))

(solve *standard-input*)
