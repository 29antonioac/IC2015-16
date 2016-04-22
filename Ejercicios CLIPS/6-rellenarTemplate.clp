(deftemplate TTT
    (slot nombreslot1)
    (slot nombreslot2)
    (multislot nombreslot3)
)

(defrule EntradaTTT
  =>
  ; Pedir información
  (printout t "Introduce un TTT: ")

  ; Separamos las palabras por espacios
  (bind ?separado (explode$ (readline)))

  ; Cogemos la primera y la segunda
  (bind ?primera (nth$ 1 ?separado))
  (bind ?segunda (nth$ 2 ?separado))

  ; Cogemos el resto y lo guardamos en una única variable
  (bind ?resto (subseq$ ?separado 3 (length$ separado)))

  ; Ahora guardamos nuestras variables en el template TTT
  (assert (TTT
      (nombreslot1 ?primera)
      (nombreslot2 ?segunda)
      (nombreslot3 ?resto)
    )
  )




)
