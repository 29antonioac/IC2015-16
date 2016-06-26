; Detección de valores peligrosos del usuario

(defrule ValoresPeligrososInestables
  (Modulo 1)
  ?f <- (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Estabilidad Inestable) (Perd3Consec true))
  =>
  (modify ?f (Peligroso true))
)

(defrule ValoresPeligrosos
  (Modulo 1)
  ?f <- (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Perd5Consec true) (PerdidaResSectorGrande true))
  =>
  (modify ?f (Peligroso true))
)

(defrule CerrarModulo1
  (declare (salience -10000))
  ?f <- (Modulo 1)
  =>
  (retract ?f)
  (assert (Modulo 2))
)
