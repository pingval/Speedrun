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
  '((henry-cloth #\0 "服" 0.3 nil)
    (prize #\1 "景" -0.2 nil)
    (old-man #\2 "爺" 4.9 nil)
    (until-3000 #\3 "3k" 5.0 nil)
    )
  "タイマー補正時間のテーブル (シンボル名 ショートカットキー ステータスバーに表示する文字 補正時間 有効かどうか)")

(defvar *casino-mode-map* nil)
(unless *casino-mode-map*
  (setq *casino-mode-map* (make-sparse-keymap))
  ;; キー入力の無効化
  (dotimes (x 127)
    (let ((c (code-char x)))
      (when (standard-char-p c)
        (define-key *casino-mode-map* c #'(lambda () (interactive))))))
  (define-key *casino-mode-map* #\RET #'(lambda () (interactive)))
  (define-key *casino-mode-map* #\Delete #'(lambda () (interactive)))
  (define-key *casino-mode-map* #\Backspace #'(lambda () (interactive)))
  ;; タイム補正のトグル
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
  "10C.txt, 100C.txt の置き場")

(defvar *casino-normalize* 1/2
  "標的の直前に入るための補正(単位は秒)。早く入ってしまう場合は1/2より短く、逆は長く変更する。")

(defvar *casino-coloring-300k* '(:color 7 4 :bold :underline)
  "30万～の文字修飾")
(defvar *casino-coloring-30k* '(:color 7 10 :bold :underline)
  "3万～6万")
(defvar *casino-coloring-3k* '(:color 7 2 :bold :underline)
  "3000～6000(10C表のみ)")

(defvar *casino-display-above-jackpot* 15
  "一覧からジャンプする際、標的よりこの行数分上に飛ぶ。タイミング取りに自信があれば低く変更するといい。但し変更すると100Cの一覧表示が回転数と対応しなくなる。")

(defvar *casino-timer-max-duration* (* 15 60)
  "タイマーが自動で停止する時間(秒)")

(defvar *casino-timer-highlight-border* 15
  "減算タイマーの残り時間がこれ以下で、減算タイマーを強調する(秒)")

(defvar *casino-timer-highlight-fmt* "**~a**"
  "減算タイマーの強調の仕方")

(defvar *casino-timer-undefined-target-string* "(未選択)"
  "目標が未選択のときのタイマーとして表示する文字列")

(defvar *casino-timer-target-line* nil
  "標的の回転数")

(defvar *casino-timer-target* nil
  "標的までの残り時間(ミリ秒)")

(defvar *casino-timer-target-note* nil
  "標的の備考欄")

(defvar *casino-timer* nil
  "タイマーを代入する変数")

(defvar *casino-timer-base-point* nil
  "減算タイマーの基準となる位置")

(defvar *casino-timer-base-time* 0
  "タイマーの開始時間")

(defvar *casino-list-update-neededp* t
  "当たり一覧の更新が必要かどうか")

(defvar *casino-10c-linediff* 15)

(defvar *casino-100c-linediff* (+ 0 *casino-display-above-jackpot*))

;; 当たりの種類(下記参照) 回転 標的にするライン 確率 必要コイン 備考
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
    (3 492 4 "2/5" "30" "千:2/5")
    (1 657 2 "4/5" "30")
    (1 689 5 "3/5" "30")
    (1 698 4 "3/5" "30")
    (3 714 5 "1/5" "10" "千:3/5")
    (1 845 5 "4/5" "30")
    (1 917 6 "3/5" "10")
    (1 959 6 "3/5" "10")
    (5 1062 3 "1/5" "90" "万:2/5, 千:2/5")
    (5 2831 2 "1/5" "90")
    (5 4527 2 "1/5" "80" "万:2/5, 千:2/5")
    (5 4749 2 "1/5" "90")
    ))

(defvar *casino-100c-jackpot-list*
  '((5 19 1 "1/5" "900")
    (5 58 1 "1/5" "700")
    (5 123 1 "1/5" "800")
    (5 363 2 "1/5" "700" "次6万")
    (5 495 3 "1/5" "900")
    (5 644 5 "1/5" "800")
    (5 698 3 "1/5" "700")
    (5 1023 2 "1/5" "800")
    (5 1062 3 "1/5" "90" "10Cスロット")
    (5 1150 2 "1/5" "900")
    (5 1208 2 "1/5" "800")
    (5 1265 2 "1/5" "900")
    (5 1297 4 "1/5" "800")
    (5 1541 2 "1/5" "800")
    (5 1982 5 "1/5" "700")
    (5 2831 2 "1/5" "90" "10Cスロット")
    (5 3000 4 "3/5" "700")
    ;; (5 3003 2 "1/5" "800")
    (5 3071 4 "1/5" "900")
    (5 3156 5 "1/5" "800" "33万")
    (5 3230 3 "1/5" "700")
    (5 3262 4 "1/5" "800")
    (5 3652 4 "1/5" "800")
    (5 3696 2 "1/5" "700") ;; 3710回転も狙う余裕を作るため
;;    (5 3698 2 "1/5" "700")
    (5 3710 3 "1/5" "900")
    (5 3918 3 "2/5" "900")
    (5 4308 3 "1/5" "700")
    (5 4527 2 "1/5" "90" "10Cスロット")
    (5 4570 2 "1/5" "700")
    (5 4749 2 "1/5" "90" "10Cスロット")
    (5 4977 5 "1/5" "900")
    ))

(defvar *casino-10c-regexp-keyword-list*
  (compile-regexp-keyword-list
   `(
     ;; 当たり待ち
     ("\\*-?[0-9]+$" t (:color 8 6) nil)
     ;; ただの行番号
     ("-?[0-9]+$" t :comment nil)
     ;; 10c-77777 30万
     ("\\(77777\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 10c-55555 3万
     ("\\(55555\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 10c-44444 6000
     ("\\(44444\\)" nil ,*casino-coloring-3k* nil 1 1)
     ;; 10c-33333 3000
     ("\\(33333\\)" nil ,*casino-coloring-3k* nil 1 1)
     ;; 10c-7777 3万
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
     ;; 当たり待ち
     ("^ *\\*-?[0-9]+" t (:color 8 6) nil)
     ;; ただの行番号
     ("^ *-?[0-9]+" t :comment nil)
     ;; 100c-77777 300万
     ("\\(77777\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 100c-55555 30万
     ("\\(55555\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 100c-44444 6万
     ("\\(44444\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-33333 3万
     ("\\(33333\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-7777 30万
     ("\\(7777\\)" nil ,*casino-coloring-300k* nil 1 1)
     ;; 100c-6666 6万
     ("\\(6666\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-5555 3万
     ("\\(5555\\)" nil ,*casino-coloring-30k* nil 1 1)
     ;; 100c-777 3万
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
          (error "出目の行ではありません"))
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
      (error "ラインの範囲を超えています: ~d" x))
  (goto-bol)
  (or (looking-at *casino-x-regexp*)
      (error "出目の行ではありません"))
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
  "現在位置を保存しつつ、100C表⇔10C表を切り替え"
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
  "回転[-ライン]の形で指定して移動"
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
  "現在位置以降の当たり目とその待ち時間の一覧を構築"
  (let* ((result nil)
         (y (cdr *casino-timer-base-point*))
         (x (car *casino-timer-base-point*))
         (jl (if (casino-100cp)
                 *casino-100c-jackpot-list*
               *casino-10c-jackpot-list*)))
    (push (list "回転" ;; 10Cでも「回転」を使っていい
                "待ち時間　　　当たり　確率　　必要C　備考") result)
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
                                              (1 . "千")
                                              (2 . "2千")
                                              (3 . "万")
                                              (4 . "2万")
                                              (5 . "30万"))))
                                prob
                                (or coin "	")
                                (if note (concat "※" note) "")
                                )))
            (push (list line index target) result)))))
    ))

(defun casino-list-jackpot ()
  "list-functionの代わり"
  (interactive)
  (when (or *casino-list-update-neededp*
            (not *casino-timer*))
    (setq *list-function-buffer* nil)) ;; リスト再構築させる
  (setq *casino-list-update-neededp* (not *casino-timer*))
  (when (not *casino-timer*)
    (setq *casino-timer-base-point* (cons (casino-get-x) (casino-get-y))))
  (when (list-function)
    ;; *list-function-selected* の nth 2 に待ち時間を挿し込んでいる
    (let ((wait (nth 2 *list-function-selected*))
          (line (nth 0 *list-function-selected*))
          (note (and (string-matchp "※.*" (nth 1 *list-function-selected*))
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
                           ; 残り時間に補正タイムを加算(経過時間は変更しない)
                           (incf correction (truncate (* (nth 3 cr) 1000))))
                         (let ((fmt (if (nth 4 cr) "[~c:~a]" "~c:~a")))
                           (format nil fmt (nth 1 cr) (nth 2 cr))))
                     *casino-timer-correction-table*))
         (s (casino-string-join a "/")))
    (values (+ (- target duration) correction) s)))

(defun casino-start-timer (&key (max (* *casino-timer-max-duration* 1000)) (fps 60))
  (interactive)
  ;; 仕切り直す前にストップを必要にしたいなら、こっち
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
                    (message "~a with ~a (経過: ~a) ~a"
                             (if (= target 0)
                                 (format nil *casino-timer-highlight-fmt*
                                         *casino-timer-undefined-target-string*)
                               (format nil "~d回転まで: ~a"
                                       *casino-timer-target-line*
                                       (format nil (if highlightp *casino-timer-highlight-fmt* "~a")
                                               (casino-time2string left))))
                             (if (= (length s) 0) "－" (concat "\"" s "\""))
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
  ; タイマーを削除
  (setq *casino-timer* nil)
  (setq *casino-timer-target* nil)
  (setq *casino-timer-target-note* nil)
  (setq *casino-list-update-neededp* t)
  ; タイム補正も全て消す
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
