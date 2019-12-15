(provide "casino-mode")
(in-package "editor")
(export '(casino-mode
          casino-toggle-map
          casino-goto
          casino-list-jackpot
          casino-start-timer
          casino-start-timer-and-list-jackpot
          casino-stop-timer
          *casino-mode-map*
          *casino-dir*
          *casino-normalize*
          *casino-display-above-jackpot*
          *casino-10c-linediff*
          *casino-100c-linediff*
          *casino-10c-jackpot-list*
          *casino-100c-jackpot-list*
          *casino-10c-regexp-keyword-list*
          *casino-100c-regexp-keyword-list*
          *casino-timer-correction-table*
          *casino-timer-max-duration*
          *casino-timer-highlight-border*
          *casino-timer-highlight-fmt*
          ))

(defvar *casino-mode-syntax-table* nil)
(unless *casino-mode-syntax-table*
  (setq *casino-mode-syntax-table* (make-syntax-table))
  (dotimes (x 127)
    (let ((c (code-char x)))
      (unless (alphanumericp c)
        (set-syntax-symbol *casino-mode-syntax-table* c))))
  (set-syntax-whitespace *casino-mode-syntax-table* #\SPC)
  (set-syntax-whitespace *casino-mode-syntax-table* #\TAB)
  (set-syntax-whitespace *casino-mode-syntax-table* #\C-l)
  (set-syntax-whitespace *casino-mode-syntax-table* #\RET)
;   (set-syntax-start-comment *casino-mode-syntax-table* #\; nil)
  (set-syntax-end-comment *casino-mode-syntax-table* #\LFD nil t)
;   (set-syntax-string *casino-mode-syntax-table* #\")
;   (set-syntax-quote *casino-mode-syntax-table* #\#)
;   (set-syntax-quote *casino-mode-syntax-table* #\')
;   (set-syntax-quote *casino-mode-syntax-table* #\,)
;   (set-syntax-quote *casino-mode-syntax-table* #\`)
;   (set-syntax-match *casino-mode-syntax-table* #\( #\))
;   (set-syntax-escape *casino-mode-syntax-table* #\\)
;   (set-syntax-start-multi-comment *casino-mode-syntax-table* "#|")
;   (set-syntax-end-multi-comment *casino-mode-syntax-table* "|#")
  )


(defvar *casino-timer-correction-table*
  '((henry-cloth #\0 "��" 0.3 nil)
    (prize #\1 "�i" -0.2 nil)
    (old-man #\2 "��" 4.9 nil)
    (until-3000 #\3 "3k" 5.0 nil)
    )
  "�^�C�}�[�␳���Ԃ̃e�[�u�� (�V���{���� �V���[�g�J�b�g�L�[ �X�e�[�^�X�o�[�ɕ\�����镶�� �␳���� �L�����ǂ���)")

(defvar *casino-mode-map* nil)
(unless *casino-mode-map*
  (setq *casino-mode-map* (make-sparse-keymap))
  ;; �L�[���̖͂�����
  (dotimes (x 127)
    (let ((c (code-char x)))
      (when (standard-char-p c)
        (define-key *casino-mode-map* c #'(lambda () (interactive))))))
  (define-key *casino-mode-map* #\RET #'(lambda () (interactive)))
  (define-key *casino-mode-map* #\Delete #'(lambda () (interactive)))
  (define-key *casino-mode-map* #\Backspace #'(lambda () (interactive)))
  ;; �^�C���␳�̃g�O��
  (dotimes (i (length *casino-timer-correction-table*))
    (let* ((l (nth i *casino-timer-correction-table*))
           (c (nth 1 l)))
      (define-key *casino-mode-map* c
                  #'(lambda ()
                      (interactive)
                      ; (message "~s" l)
                      (setf (nth 4 l) (not (nth 4 l)))
                      ))))
  (define-key *casino-mode-map* #\TAB 'casino-toggle-map)
  (define-key *casino-mode-map* #\C-a 'casino-list-jackpot)
  (define-key *casino-mode-map* #\M-g 'casino-goto)
  )

(defvar *casino-dir* (etc-path)
  "10C.txt, 100C.txt �̒u����")

(defvar *casino-normalize* 1/2
  "�W�I�̒��O�ɓ��邽�߂̕␳(�P�ʂ͕b)�B���������Ă��܂��ꍇ��1/2���Z���A�t�͒����ύX����B")

(defvar *casino-coloring-300k* '(:color 7 4 :bold :underline)
  "30���`�̕����C��")
(defvar *casino-coloring-30k* '(:color 7 10 :bold :underline)
  "3���`6��")
(defvar *casino-coloring-3k* '(:color 7 2 :bold :underline)
  "3000�`6000(10C�\�̂�)")

(defvar *casino-display-above-jackpot* 15
  "�ꗗ����W�����v����ہA�W�I��肱�̍s������ɔ�ԁB�^�C�~���O���Ɏ��M������ΒႭ�ύX����Ƃ����B�A���ύX�����100C�̈ꗗ�\������]���ƑΉ����Ȃ��Ȃ�B")

(defvar *casino-timer-max-duration* (* 15 60)
  "�^�C�}�[�������Œ�~���鎞��(�b)")

(defvar *casino-timer-highlight-border* 15
  "���Z�^�C�}�[�̎c�莞�Ԃ�����ȉ��ŁA���Z�^�C�}�[����������(�b)")

(defvar *casino-timer-highlight-fmt* "**~a**"
  "���Z�^�C�}�[�̋����̎d��")

(defvar *casino-timer-undefined-target-string* "(���I��)"
  "�ڕW�����I���̂Ƃ��̃^�C�}�[�Ƃ��ĕ\�����镶����")

(defvar *casino-timer-target-line* nil
  "�W�I�̉�]��")

(defvar *casino-timer-target* nil
  "�W�I�܂ł̎c�莞��(�~���b)")

(defvar *casino-timer-target-note* nil
  "�W�I�̔��l��")

(defvar *casino-timer* nil
  "�^�C�}�[��������ϐ�")

(defvar *casino-timer-base-point* nil
  "���Z�^�C�}�[�̊�ƂȂ�ʒu")

(defvar *casino-timer-base-time* 0
  "�^�C�}�[�̊J�n����")

(defvar *casino-list-update-neededp* t
  "������ꗗ�̍X�V���K�v���ǂ���")

(defvar *casino-10c-linediff* 15)

(defvar *casino-100c-linediff* (+ 0 *casino-display-above-jackpot*))

;; ������̎��(���L�Q��) ��] �W�I�ɂ��郉�C�� �m�� �K�v�R�C�� ���l
;; 1:3000, 2:6000, 3:30000, 4:60000, 5:300000
(defvar *casino-10c-jackpot-list*
  '(
    (1 -13 2 "3/5" "10")
    (1 -2 4 "4/5" "10or30")
    (1 33 4 "3/5" "10")
    (1 35 5 "4/5" "20")
    (1 83 4 "4/5" "30")
    (1 274 3 "3/5" "10")
    (1 365 5 "3/5" "30")
    (3 492 4 "2/5" "30" "��:2/5")
    (1 657 2 "4/5" "30")
    (1 689 5 "3/5" "30")
    (1 698 4 "3/5" "30")
    (3 714 5 "1/5" "10" "��:3/5")
    (1 845 5 "4/5" "30")
    (1 917 6 "3/5" "10")
    (1 959 6 "3/5" "10")
    (5 1062 3 "1/5" "90" "��:2/5, ��:2/5")
    (5 2831 2 "1/5" "90")
    (5 4527 2 "1/5" "80" "��:2/5, ��:2/5")
    (5 4749 2 "1/5" "90")
    ))

(defvar *casino-100c-jackpot-list*
  '((5 19 1 "1/5" "900")
    (5 58 1 "1/5" "700")
    (5 123 1 "1/5" "800")
    (5 363 2 "1/5" "700" "��6��")
    (5 495 3 "1/5" "900")
    (5 644 5 "1/5" "800")
    (5 698 3 "1/5" "700")
    (5 1023 2 "1/5" "800")
    (5 1062 3 "1/5" "90" "10C�X���b�g")
    (5 1150 2 "1/5" "900")
    (5 1208 2 "1/5" "800")
    (5 1265 2 "1/5" "900")
    (5 1297 4 "1/5" "800")
    (5 1541 2 "1/5" "800")
    (5 1982 5 "1/5" "700")
    (5 2831 2 "1/5" "90" "10C�X���b�g")
    (5 3000 4 "3/5" "700")
    ;; (5 3003 2 "1/5" "800")
    (5 3071 4 "1/5" "900")
    (5 3156 5 "1/5" "800" "33��")
    (5 3230 3 "1/5" "700")
    (5 3262 4 "1/5" "800")
    (5 3652 4 "1/5" "800")
    (5 3696 2 "1/5" "700") ;; 3710��]���_���]�T����邽��
;;    (5 3698 2 "1/5" "700")
    (5 3710 3 "1/5" "900")
    (5 3918 3 "2/5" "900")
    (5 4308 3 "1/5" "700")
    (5 4527 2 "1/5" "90" "10C�X���b�g")
    (5 4570 2 "1/5" "700")
    (5 4749 2 "1/5" "90" "10C�X���b�g")
    (5 4977 5 "1/5" "900")
    ))

(defvar *casino-10c-regexp-keyword-list*
  (compile-regexp-keyword-list
   `(
     ;; ������҂�
     ("\\*-?[0-9]+$" t (:color 8 6) nil)
     ;; �����̍s�ԍ�
     ("-?[0-9]+$" t :comment nil)
     ;; 10c-77777 30��
     ("\\(77777\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 10c-55555 3��
     ("\\(55555\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 10c-44444 6000
     ("\\(44444\\)" nil ,*casino-coloring-3k* nil 1 1)
     ;; 10c-33333 3000
     ("\\(33333\\)" nil ,*casino-coloring-3k* nil 1 1)
     ;; 10c-7777 3��
     ("\\(7777\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 10c-6666 6000
     ("\\(6666\\)" nil ,*casino-coloring-3k* nil 1 1)
     ;; 10c-5555 3000
     ("\\(5555\\)" nil ,*casino-coloring-3k* nil 1 1)
     ;; 10c-777 3000
     ("\\(777\\)" nil ,*casino-coloring-3k* nil 1 1)
     )))

(defvar *casino-100c-regexp-keyword-list*
  (compile-regexp-keyword-list
   `(
     ;; ������҂�
     ("^ *\\*-?[0-9]+" t (:color 8 6) nil)
     ;; �����̍s�ԍ�
     ("^ *-?[0-9]+" t :comment nil)
     ;; 100c-77777 300��
     ("\\(77777\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 100c-55555 30��
     ("\\(55555\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 100c-44444 6��
     ("\\(44444\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-33333 3��
     ("\\(33333\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-7777 30��
     ("\\(7777\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 100c-6666 6��
     ("\\(6666\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-5555 3��
     ("\\(5555\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-777 3��
     ("\\(777\\)" nil ,*casino-coloring-30k* nil 1 1)
     )))

(defun casino-100cp ()
  (string-matchp "100C\\.txt$" (get-buffer-file-name)))

(defun casino-string-join (seq &optional (sep ""))
  (let ((r "")
        (sep (string sep)))
    (dolist (s seq)
      (setq r (concat r s sep)))
    (substring r 0 (max 0 (- (length r) (length sep))))))

(defvar *casino-x-regexp*
  (let ((s "\\([^ \n]\\{15,\\}\\)"))
    (compile-regexp (concat ".*?" (casino-string-join (list s s s s s) " ")))))

(defun casino-get-x (&optional point)
  (save-excursion
    (let ((p (or point (point))))
      (goto-bol)
      (or (looking-at *casino-x-regexp*)
          (error "�o�ڂ̍s�ł͂���܂���"))
      (cond ((< p (match-beginning 2))
             1)
            ((< p (match-beginning 3))
             2)
            ((< p (match-beginning 4))
             3)
            ((< p (match-beginning 5))
             4)
            (t
             5)))))

(defun casino-set-x (x)
  (or (<= 1 x 5)
      (error "���C���͈̔͂𒴂��Ă��܂�: ~d" x))
  (goto-bol)
  (or (looking-at *casino-x-regexp*)
      (error "�o�ڂ̍s�ł͂���܂���"))
  (goto-char (match-beginning x)))

(defun casino-get-y (&optional point)
  (save-excursion
    (when point
      (goto-char point))
    (- (current-line-number)
       (if (casino-100cp)
           *casino-100c-linediff*
         *casino-10c-linediff*))))

(defun casino-set-y (y)
  (goto-line (+ y
                (if (casino-100cp)
                    *casino-100c-linediff*
                  *casino-10c-linediff*))))

(defun casino-toggle-map ()
  "���݈ʒu��ۑ����A100C�\��10C�\��؂�ւ�"
  (interactive)
  (let ((y (casino-get-y))
        (x (casino-get-x))
        (target (merge-pathnames (if (casino-100cp)
                                     "10C.txt"
                                   "100C.txt")
                                 *casino-dir*)))
    (find-file target)
    (casino-set-y y)
    (casino-set-x x)
    (recenter 0)))

(defun casino-goto (y-x)
  "��][-���C��]�̌`�Ŏw�肵�Ĉړ�"
  (interactive "sRoll[-Line] to goto: ")
  (if (string-match "\\(-?[0-9]+\\)\\(?:-\\([0-9]+\\)\\)?" y-x)
      (let ((y (match-string 1))
            (x (match-string 2)))
        (casino-set-y (parse-integer y))
        (when x
          (casino-set-x (parse-integer x))))
    nil))

(defun casino-calc-wait (from to)
  (+ (/ (- (car to) (car from)) 6)
     (* (- (cdr to) (cdr from)) 1/30)))

(defun casino-build-summary-of-jackpots ()
  "���݈ʒu�ȍ~�̓�����ڂƂ��̑҂����Ԃ̈ꗗ���\�z"
  (let* ((result nil)
         (y (cdr *casino-timer-base-point*))
         (x (car *casino-timer-base-point*))
         (jl (if (casino-100cp)
                 *casino-100c-jackpot-list*
               *casino-10c-jackpot-list*)))
    (push (list "��]" ;; 10C�ł��u��]�v���g���Ă���
                "�҂����ԁ@�@�@������@�m���@�@�K�vC�@���l") result)
    (dolist (i jl (nreverse result))
      (multiple-value-bind (type yy xx prob coin note)
          (values-list i)
        (when (< (+ y 12) yy)
          (let* ((line (+ yy
                          (if (casino-100cp)
                              *casino-100c-linediff*
                            *casino-10c-linediff*)
                          (- *casino-display-above-jackpot*)))
                 (target (round (* (+ (casino-calc-wait (cons y x) (cons yy xx))
                                      *casino-normalize*)
                                   1000)))
;                  (left (casino-calc-left-time
;                         (round (* target 1000))
;                         (- (get-internal-real-time) *casino-timer-base-time*)))
                 (index (format nil "~a	~a	~a	~a	~a"
                                (casino-time2string target)
                                (cdr (assoc type
                                            '((0 . "-")
                                              (1 . "��")
                                              (2 . "2��")
                                              (3 . "��")
                                              (4 . "2��")
                                              (5 . "30��"))))
                                prob
                                (or coin "	")
                                (if note (concat "��" note) "")
                                )))
            (push (list line index target) result)))))
    ))

(defun casino-list-jackpot ()
  "list-function�̑���"
  (interactive)
  (when (or *casino-list-update-neededp*
            (not *casino-timer*))
    (setq *list-function-buffer* nil)) ;; ���X�g�č\�z������
  (setq *casino-list-update-neededp* (not *casino-timer*))
  (when (not *casino-timer*)
    (setq *casino-timer-base-point* (cons (casino-get-x) (casino-get-y))))
  (when (list-function)
    ;; *list-function-selected* �� nth 2 �ɑ҂����Ԃ�}������ł���
    (let ((wait (nth 2 *list-function-selected*))
          (line (nth 0 *list-function-selected*))
          (note (and (string-matchp "��.*" (nth 1 *list-function-selected*))
                     (match-string 0))))
      (setq *casino-timer-target-line* line)
      (setq *casino-timer-target* wait)
      (setq *casino-timer-target-note* note)
      (recenter 0))))

(defun casino-time2string (time)
  (let* ((sign (if (minusp time) "-" ""))
         (time (abs time))
         (ms (mod time 1000))
         (s (mod (truncate time 1000) 60))
         (m (truncate time (* 1000 60))))
    (format nil "~a~2,'0d:~2,'0d.~3,'0d" sign m s ms)))

(defun casino-calc-left-time (target duration)
  (let* ((correction 0)
         (a  (mapcar #'(lambda (cr)
                         (when (nth 4 cr)
                           ; �c�莞�Ԃɕ␳�^�C�������Z(�o�ߎ��Ԃ͕ύX���Ȃ�)
                           (incf correction (truncate (* (nth 3 cr) 1000))))
                         (let ((fmt (if (nth 4 cr) "[~c:~a]" "~c:~a")))
                           (format nil fmt (nth 1 cr) (nth 2 cr))))
                     *casino-timer-correction-table*))
         (s (casino-string-join a "/")))
    (values (+ (- target duration) correction) s)))

(defun casino-start-timer (&key (max (* *casino-timer-max-duration* 1000)) (fps 60))
  (interactive)
  ;; �d�؂蒼���O�ɃX�g�b�v��K�v�ɂ������Ȃ�A������
;   (when *casino-timer*
;     (return-from casino-start-timer))
  (casino-stop-timer)
  (setq *casino-timer-base-point* (cons (casino-get-x) (casino-get-y)))
  (setq *casino-timer-base-time* (get-internal-real-time))
  (let* ((base-time *casino-timer-base-time*)
         (timer
          #'(lambda ()
              (let* ((target (or *casino-timer-target* 0))
                     (duration (- (get-internal-real-time) base-time)))
                (multiple-value-bind (left s)
                    (casino-calc-left-time target duration)
                  (let ((highlightp (< left (* *casino-timer-highlight-border* 1000))))
                    (message "~a with ~a (�o��: ~a) ~a"
                             (if (= target 0)
                                 (format nil *casino-timer-highlight-fmt*
                                         *casino-timer-undefined-target-string*)
                               (format nil "~d��]�܂�: ~a"
                                       *casino-timer-target-line*
                                       (format nil (if highlightp *casino-timer-highlight-fmt* "~a")
                                               (casino-time2string left))))
                             (if (= (length s) 0) "�|" (concat "\"" s "\""))
                             (casino-time2string duration)
                             (or *casino-timer-target-note* "")
                             )
                    (when (and (minusp left)
                               (numberp max)
                               (>= duration max))
                      (casino-stop-timer))))))))
    (stop-timer *casino-timer*)
    (setq *casino-timer* timer)
    (start-timer (/ 1 fps) *casino-timer*)
    ))

(defun casino-start-timer-and-list-jackpot (&rest args)
  (interactive)
  (apply #'casino-start-timer args)
  ;; (sit-for 0.5)
  (casino-list-jackpot))

  (defun casino-stop-timer ()
  (interactive)
  (stop-timer *casino-timer*)
  ; �^�C�}�[���폜
  (setq *casino-timer* nil)
  (setq *casino-timer-target* nil)
  (setq *casino-timer-target-note* nil)
  (setq *casino-list-update-neededp* t)
  ; �^�C���␳���S�ď���
  (dolist (l *casino-timer-correction-table*)
    (setf (nth 4 l) nil))
  )

(defun casino-mode ()
  (interactive)
  (kill-all-local-variables)
  (setq mode-name
        (if (casino-100cp) "100C" "10C"))
  (setq buffer-mode 'casino-mode)
  (use-syntax-table *casino-mode-syntax-table*)
  (use-keymap *casino-mode-map*)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start "^$\\|\f")
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'build-summary-function)
  (setq build-summary-function 'casino-build-summary-of-jackpots)
  (make-local-variable 'regexp-keyword-list)
  (setq regexp-keyword-list
        (if (casino-100cp)
            *casino-100c-regexp-keyword-list*
          *casino-10c-regexp-keyword-list*)))