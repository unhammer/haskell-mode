(require 'ert)
(require 'haskell-indentation)
(require 'haskell-mode)
(require 'cl-lib)


(defun haskell-indentation-check (lines expected)
  (with-temp-buffer
    (haskell-mode)
    (haskell-indentation-mode)
    ;; insert lines
    (dolist (line lines)
      (insert line)
      (insert "\n"))
    ;; find where the string 'HERE' is and go there
    (goto-char (point-min))
    (let ((case-fold-search t))
      (search-forward "HERE"))
    ;; try to indent once
    (indent-for-tab-command)
    ;; get the contents and compare
    (let ((result (cl-remove-if
		   (lambda (s) (equal "" s))
		   (split-string (buffer-substring-no-properties (point-min) (point-max)) "\n"))))
      (should (equal expected result)))))


(ert-deftest haskell-indentation-check-1 ()
    "Check if '{' on its own line gets properly indented"
    :expected-result :failed
    (haskell-indentation-check
     '("function = Record"
       "     { field = 123 } -- HERE")
     '("function = Record"
       "           { field = 123 } -- HERE")))

(ert-deftest haskell-indentation-check-2 ()
    "Handle underscore in identifiers"
    (haskell-indentation-check
     '("function = do"
       "  (_x) <- return ()"
       " z -- HERE")
     '("function = do"
       "  (_x) <- return ()"
       "  z -- HERE")))
