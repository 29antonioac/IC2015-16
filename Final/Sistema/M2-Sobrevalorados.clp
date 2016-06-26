; Detección de valores peligrosos del usuario

(defrule ValoresSobrevaloradosGeneral
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (EtiqPER Alto) (EtiqRPD Bajo) (Sobrevalorado ~true))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosPequenia1
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano PEQUENIA) (EtiqPER Alto) (Sobrevalorado ~true))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosPequenia2
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano PEQUENIA) (EtiqPER Mediano) (EtiqRPD Bajo) (Sobrevalorado ~true))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosGrande1
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano GRANDE) (EtiqRPD Bajo)
        (EtiqPER ?per)
        (Sobrevalorado ~true))
  (or (eq ?per Alto) (eq ?per Mediano))
  =>
  (modify ?f (Sobrevalorado true))
)

(defrule ValoresSobrevaloradosGrande2
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano GRANDE) (EtiqRPD Mediano) (EtiqPER Alto) (Sobrevalorado ~true))
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
