(defun read-map (stream)
  (do* ((line (read-line stream nil) (read-line stream nil))
        (width (length line))
        (y 0 (1+ y))
        (antennae nil))
      ((not line) (list y width (reverse antennae)))
    (dotimes (x (length line))
      (if (char/= (char line x) #\.)
          (push (list y x (char line x)) antennae)))))

(defun get-antinodes (a l)
  (mapcan #'(lambda (x)
              (list (mapcar #'- a (mapcar #'- x a))
                    (mapcar #'+ x (mapcar #'- x a))))
          l))

(defun get-antenna-coordinates (antenna)
  (list (first antenna) (second antenna)))

(defun is-outside (antenna height width)
  (or (or (< (first antenna) 0) (>= (first antenna) height))
       (or (< (second antenna) 0)) (>= (second antenna) width)))

(defun solve (stream)
  (let* ((map (read-map stream))
         (height (first map)) (width (second map))
         (antennae (third map)))
    (length
      (remove-duplicates
        (remove-if #'(lambda (x)
                       (is-outside x height width))
                   (mapcon #'(lambda (x)
                               (get-antinodes (get-antenna-coordinates (car x))
                                              (mapcar #'get-antenna-coordinates
                                                      (remove-if-not
                                                        #'(lambda (y)
                                                            (char=
                                                              (third (car x))
                                                              (third y)))
                                                        (cdr x)))))
                           antennae)) :test #'equal))))

(format t "~A~%" (solve *standard-input*))
