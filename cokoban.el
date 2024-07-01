;;; cokoban.el --- Two player Sokoban Game           -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Nicholas Vollmer

;; Author:  Nicholas Vollmer
;; Keywords: games

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A two player co-op sokoban game.

;;; Code:
(require 'cl-lib)
(defgroup cokoban nil "Cokoban game." :group 'applications :prefix "cokoban-")
(cl-defstruct (cokoban-object (:constructor cokoban-object)
                              (:type list) (:copier nil) (:named))
  "Game object."
  (tangible t)
  (weight 1)
  (renderer nil))

(defun cokoban-render-tile (_tile)
  "Draw TILE."
  (insert " "))

(cl-defstruct (cokoban-tile (:include cokoban-object
                                      (tangible nil)
                                      (weight -1)
                                      (renderer #'cokoban-render-tile))
                            (:constructor cokoban-tile)
                            (:type list) (:copier nil) (:named))
  "Game tile object.")

(defun cokoban-render-wall (_wall) "Draw wall."
  (insert "."))

(cl-defstruct (cokoban-wall (:include cokoban-object
                                      (tangible t)
                                      (weight most-positive-fixnum)
                                      (renderer #'cokoban-render-wall))
                            (:constructor cokoban-wall)
                            (:type list) (:copier nil) (:named))
  "Game wall object.")

(defun cokoban-render-player (_player)
  "Draw PLAYER."
  (insert "x"))

(cl-defstruct (cokoban-player (:include cokoban-object
                                        (weight 1)
                                        (renderer #'cokoban-render-player))
                              (:constructor cokoban-player)
                              (:type list) (:copier nil) (:named))
  "Game tile object.")

(defvar cokoban-grid nil)

(defun cokoban-draw (grid)
  "Draw GRID."
  (with-current-buffer (get-buffer-create "*COKOBAN TEST*")
    (with-silent-modifications
      (erase-buffer)
      (cl-loop for row in grid do
               (cl-loop for col in row
                        do (if-let ((col)
                                    (renderer (cokoban-object-renderer col)))
                               (funcall renderer col)
                             (insert " ")))
               (insert "\n")))))

;;@TEST
(defun cokoban-test ()
  "TEST."
  (interactive)
  (let ((grid (list (make-list 7 (cokoban-wall))
                    `(,(cokoban-wall) ,@(make-list 2 nil)
                      ,(cokoban-player) ,@(make-list 2 nil)
                      ,(cokoban-wall))
                    (make-list 7 (cokoban-wall)))))
    (display-buffer (current-buffer))
    (cokoban-draw grid)))

(provide 'cokoban)
;;; cokoban.el ends here
