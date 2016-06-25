; 1 - Los valores del sector de la construcción son inestables por defecto
(defrule Construccion
  (Modulo 0)
  ?f <- (Valor (Nombre ?valor) (Sector Construccion) (Estabilidad ~Inestable))
  =>
  (modify ?f (Estabilidad Inestable)))

; 2 - Si la economía está bajando, los valores del sector servicios son inestables
(defrule Servicios
  (Modulo 0)
  ?f <- (Valor (Nombre ?valor) (Sector Servicios) (Estabilidad ~Inestable))
  ; Economía bajando
  (Sector (Nombre Ibex) (Perd5Consec true))
  =>
  (modify ?f (Estabilidad Inestable))
)

; 3 - Si hay una noticia positiva sobre él o su sector, un valor inestable
; deja de serlo durante dos días
(defrule NoticiasPositivas
  (declare (salience -10))
  (Modulo 0)
  ; Le damos menos prioridad a las positivas para que se ejecuten después,
  ; luego en realidad la prioridad es mayor
  ?f <- (Valor (Nombre ?valor) (Sector ?sector) (Estabilidad ~Estable))
  (or (and  (Noticia (Nombre ?valor) (Tipo Buena) (Antiguedad ?A1))
            (test (<= ?A1 2))
      )
      (and  (Noticia (Nombre ?sector) (Tipo Buena) (Antiguedad ?A2))
            (test (<= ?A2 2))
      )
  )
  =>
  (modify ?f (Estabilidad Estable))
)

; 4 - Si hay una noticia negativa sobre un valor, pasa a ser inestable durante
; 2 días
; 5 - Si hay una noticia negativa sobre un sector, los valores del sector pasan
; a ser inestables durante 2 días.
; 6 - Si hay una noticia negativa sobre la economía, todos los valores pasan a
; ser inestables durante 2 días.
(defrule NoticiasNegativas
  (declare (salience 10))
  (Modulo 0)
  ; Le damos menos prioridad a las positivas para que se ejecuten después,
  ; luego en realidad la prioridad es mayor

  ?f <- (Valor (Nombre ?valor) (Sector ?sector) (Estabilidad ~Inestable))
  (Noticia (Nombre ?noticia) (Tipo Mala) (Antiguedad ?A))
  (test (<= ?A 2))
  (or (eq ?noticia ?valor) (eq ?noticia ?sector) (eq ?noticia Economia))
  =>
  (modify ?f (Estabilidad Inestable))
)

(defrule CerrarModulo0
  (declare (salience -10000))
  ?f <- (Modulo 0)
  =>
  (retract ?f)
  (assert (Modulo 1))
)
