; Template para almacenar un valor del IBEX35
(deftemplate Valor
  (field Nombre)
  (field Precio)
  (field VarDia)
  (field Capitalizacion)
  (field PER)
  (field RPD)
  (field Tamano)
  (field PorcIbex)
  (field EtiqPER)
  (field EtiqRPD)
  (field Sector)
  (field Var5Dias)
  (field Perd3Consec)
  (field Perd5Consec)
  (field VarRespSector5Dias)
  (field PerdRespSectorGrande)
  (field VarMes)
  (field VarTri)
  (field VarSem)
  (field VarAnual)
)

; Template para almacenar un sector del IBEX35
(deftemplate Sector
  (field Nombre)
  (field VarDia)
  (field Capitalizacion)
  (field PER)
  (field RPD)
  (field PorcIbex)
  (field Var5Dias)
  (field Perd3Consec)
  (field Perd5Consec)
  (field VarMes)
  (field VarTri)
  (field VarSem)
  (field VarAnual)
)

; Template para almacenar una noticia
(deftemplate Noticia
  (field Nombre)
  (field Tipo)
  (field Antiguedad)
)

; Template para almacenar la información de un valor de la cartera
(deftemplate Cartera
  (field Nombre)
  (field Acciones)
  (field Valor)
)
