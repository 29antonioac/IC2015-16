; Detección de valores peligrosos del usuario

(defrule ValoresSobrevaloradosGeneral
  (Modulo 2)
  ?f <- (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (EtiqPER Alto) (EtiqRPD Bajo))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosPequenia1
  (Modulo 2)
  ?f <- (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Tamanio PEQUENIA) (EtiqPER Alto))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosPequenia2
  (Modulo 2)
  ?f <- (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Tamanio PEQUENIA) (EtiqPER Mediano) (EtiqRPD Bajo))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosGrande1
  (Modulo 2)
  ?f <- (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Tamanio GRANDE) (EtiqRPD Bajo) (or (EtiqPER Alto)
                                                              (EtiqPER Mediano)))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosGrande2
  (Modulo 2)
  ?f <- (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Tamanio GRANDE) (EtiqRPD Mediano) (EtiqPER Alto))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule CerrarModulo2
  (declare (salience -10000))
  ?f <- (Modulo 2)
  =>
  (retract ?f)
  (assert (Modulo 3))
)
