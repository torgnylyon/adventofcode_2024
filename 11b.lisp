(defvar *split-count* 0)
(defvar *cache* nil)

(defun cache (stone blink split)
  (push (cons (list stone blink) split) *cache*))

(defun get-cache (stone blink)
  (cdr (assoc-if #'(lambda (x)
                     (and (= (first x) stone) (= (second x) blink))) *cache*)))

(defun is-even (n)
  (= 0 (rem (length (format nil "~D" n)) 2)))

(defun split (n)
  (let ((s (format nil "~D" n)))
    (mapcar #'parse-integer (list (subseq s 0 (/ (length s) 2))
                                  (subseq s (/ (length s) 2))))))

(defun blink (stone)
  (cond ((= 0 stone) (list 1))
        ((is-even stone) (progn (incf *split-count*) (split stone)))
        (t (list (* stone 2024)))))

(defun blink-stones (l n)
  (if (> n 0)
      (dolist (i l)
        (let ((split (get-cache i n)))
          (cond (split (incf *split-count* split))
                (t (let ((old-count *split-count*))
                     (blink-stones (blink i) (1- n))
                     (cache i n (- *split-count* old-count)))))))))

(defun solve (l n)
  (blink-stones l n)
  (+ (length l) *split-count*))

(defun read-stones (stream)
  (do ((stones nil) (stone (read stream nil) (read stream nil)))
      ((not stone) stones)
    (push stone stones)))

(format t "~A~%" (solve (read-stones *standard-input*) 75))
