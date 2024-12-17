(defun read-board (stream)
  (do* ((line (read-line stream nil) (read-line stream nil))
        (width (length line))
        (y 0 (1+ y))
        (obstacles nil)
        (guard))
      ((not line) (list y width guard obstacles))
    (dotimes (x (length line))
      (cond ((char= (char line x) #\#)
             (push (list y x) obstacles))
            ((find (char line x) "^>v<")
             (setf guard (list y x (char line x))))))))

(defun get-next-position (guard)
  (append
    (cond ((char= (third guard) #\^) (list (1- (first guard)) (second guard)))
          ((char= (third guard) #\>) (list (first guard) (1+ (second guard))))
          ((char= (third guard) #\v) (list (1+ (first guard)) (second guard)))
          ((char= (third guard) #\<) (list (first guard) (1- (second guard)))))
    (list (third guard))))

(defun turn-guard (guard)
  (list (first guard) (second guard)
        (cond ((char= (third guard) #\^) #\>)
              ((char= (third guard) #\>) #\v)
              ((char= (third guard) #\v) #\<)
              ((char= (third guard) #\<) #\^))))

(defun is-outside (guard height width)
  (or (< (first guard) 0) (< (second guard) 0)
      (>= (first guard) height) (>= (second guard) width)))

(defun is-obstacle (guard obstacles)
  (find (list (first guard) (second guard)) obstacles :test #'equal))

(defun is-loop (height width guard obstacles obstruction visited)
  (cond ((is-outside (get-next-position guard) height width) nil)
        ((find (get-next-position guard) visited :test #'equal) t)
        ((or (is-obstacle (get-next-position guard) obstacles)
             (equal (list (first (get-next-position guard))
                          (second (get-next-position guard))) obstruction))
         (is-loop height width (turn-guard guard) obstacles obstruction
                  (cons guard visited)))
        (t (is-loop height width (get-next-position guard) obstacles obstruction
                    (cons guard visited)))))

(defun get-path (height width guard obstacles)
  (cond ((is-outside (get-next-position guard) height width)
         (list guard))
        ((is-obstacle (get-next-position guard) obstacles)
         (get-path height width (turn-guard guard) obstacles))
        (t
         (cons guard (get-path height width (get-next-position guard)
                               obstacles)))))

(defun solve (stream)
  (let ((board (read-board stream))
        (n 0))
    (dolist (obstruction
              (remove-duplicates
                (mapcar #'(lambda (x) (list (first x) (second x)))
                        (apply #'get-path board)) :test #'equal)
              n)
      (if (apply #'is-loop (append board (list obstruction) '(nil)))
          (incf n)))))

(format t "~A~%" (solve *standard-input*))
