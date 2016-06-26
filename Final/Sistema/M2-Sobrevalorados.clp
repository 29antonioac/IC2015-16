; Detección de valores sobrevalorados

(defrule ValoresSobrevaloradosGeneral
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (EtiqPER Alto) (EtiqRPD Bajo) (Sobrevalorado ~true))
  =>
  (modify ?f (Sobrevalorado true "Tiene un PER alto y un RPD bajo"))
)

(defrule ValoresSobrevaloradosPequenia1
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano PEQUENIA) (EtiqPER Alto) (Sobrevalorado ~true))
  =>
  (modify ?f (Sobrevalorado true "Es pequeña y tiene un PER alto"))
)

(defrule ValoresSobrevaloradosPequenia2
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano PEQUENIA) (EtiqPER Mediano) (EtiqRPD Bajo) (Sobrevalorado ~true))
  =>
  (modify ?f (Sobrevalorado true "Es pequeña y tiene PER mediano y RPD alto"))
)

(defrule ValoresSobrevaloradosGrande1
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano GRANDE) (EtiqRPD Bajo)
        (EtiqPER ?per)
        (Sobrevalorado ~true))
  (or (eq ?per Alto) (eq ?per Mediano))
  =>
  (modify ?f (Sobrevalorado true "Es grande, tiene RPD bajo y tiene PER mediano o alto"))
)

(defrule ValoresSobrevaloradosGrande2
  (Modulo 2)
  ?f <- (Valor (Nombre ?nombre) (Tamano GRANDE) (EtiqRPD Mediano) (EtiqPER Alto) (Sobrevalorado ~true))
  =>
  (modify ?f (Sobrevalorado true "Es grande, tiene RPD mediano y PER alto"))
)

(defrule CerrarModulo2
  (declare (salience -10000))
  ?f <- (Modulo 2)
  =>
  (retract ?f)
  (assert (Modulo 3))
)
