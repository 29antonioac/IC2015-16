; Detección de valores infravalorados

(defrule ValoresInfravaloradosGeneral
  (Modulo 3)
  ?f <- (Valor (Nombre ?nombre) (EtiqPER Bajo) (EtiqRPD Alto) (Infravalorado ~true))
  =>
  (modify ?f (Infravalorado true "Tiene PER bajo y RPD alto"))
)

(defrule ValoresInfravaloradosCaida
  (Modulo 3)
  ?f <- (Valor (Nombre ?nombre) (VarMes ?mes) (VarTri ?tri) (VarSem ?sem)
        (VarAnual ?anual) (EtiqPER Bajo) (Infravalorado ~true))
  (test(or (< ?tri -30) (< ?sem -30) (< ?anual -30)))
  (test(< ?mes 10))
  (test(> ?mes 0))
  =>
  (modify ?f (Infravalorado true "Tiene PER bajo y presenta pérdidas de más del
                30% en los últimos meses, pero una subida pequeña en el último mes"))
)

(defrule ValoresInfravaloradosGrande
  (Modulo 3)
  ?f <- (Valor (Nombre ?nombre) (Tamano GRANDE) (EtiqPER Mediano) (EtiqRPD Alto)
        (Sector ?sector) (Var5Dias ?var) (VarRespSector5Dias ?varSector) (Infravalorado ~true))
  (test (> ?var 0))
  (test (> ?varSector 0))
  =>
  (modify ?f (Infravalorado true "Es grande, tiene PER mediano y RPD alto, y está
                ganando con respecto al sector"))
)


(defrule CerrarModulo3
  (declare (salience -10000))
  ?f <- (Modulo 3)
  =>
  (retract ?f)
  (assert (Modulo 4))
)
