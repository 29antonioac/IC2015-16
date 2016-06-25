
; Con estos hechos relacionamos los ficheros con su ruta
(deffacts Ficheros
  (Fichero Analisis         "DatosIbex35/Analisis.txt")
  (Fichero AnalisisSectores "DatosIbex35/AnalisisSectores.txt")
  (Fichero Cartera          "DatosIbex35/Cartera.txt")
  (Fichero Noticias         "DatosIbex35/Noticias.txt")
)

;;;; Análisis
(defrule abrirFicheroAnalisis
  (declare (salience 2))
  (Fichero Analisis ?archivo)
  =>
  (open ?archivo archivoAnalisis)
  (assert (SeguirLeyendo DatosAnalisis))
)

(defrule leerFicheroAnalisis
  (declare (salience 1))
  ?f <- (SeguirLeyendo DatosAnalisis)
  =>
  (bind ?Leido (read archivoAnalisis))
  (retract ?f)
  (if (neq ?Leido EOF) then
    (assert (Valor
      (Nombre ?Leido)
      (Precio (read archivoAnalisis))
      (VarDia (read archivoAnalisis))
      (Capitalizacion (read archivoAnalisis))
      (PER (read archivoAnalisis))
      (RPD (read archivoAnalisis))
      (Tamano (read archivoAnalisis))
      (PorcIbex (read archivoAnalisis))
      (EtiqPER (read archivoAnalisis))
      (EtiqRPD (read archivoAnalisis))
      (Sector (read archivoAnalisis))
      (Var5Dias (read archivoAnalisis))
      (Perd3Consec (read archivoAnalisis))
      (Perd5Consec (read archivoAnalisis))
      (VarRespSector5Dias (read archivoAnalisis))
      (PerdRespSectorGrande (read archivoAnalisis))
      (VarMes (read archivoAnalisis))
      (VarTri (read archivoAnalisis))
      (VarSem (read archivoAnalisis))
      (VarAnual (read archivoAnalisis))
    ))
    (assert (SeguirLeyendo DatosAnalisis))
  )
)

(defrule cerrarFicheroAnalisis
  (declare (salience -1))
  =>
  (close archivoAnalisis)
)

;;;; Análisis Sectores

(defrule abrirFicheroAnalisisSectores
  (declare (salience 2))
  (Fichero AnalisisSectores ?archivo)
  =>
  (open ?archivo archivoAnalisisSectores)
  (assert (SeguirLeyendo DatosAnalisisSectores))
)

(defrule leerFicheroAnalisisSectores
  (declare (salience 1))
  ?f <- (SeguirLeyendo DatosAnalisisSectores)
  =>
  (bind ?Leido (read archivoAnalisisSectores))
  (retract ?f)
  (if (neq ?Leido EOF) then
    (assert (Sector
      (Nombre ?Leido)
      (VarDia (read archivoAnalisisSectores))
      (Capitalizacion (read archivoAnalisisSectores))
      (PER (read archivoAnalisisSectores))
      (RPD (read archivoAnalisisSectores))
      (PorcIbex (read archivoAnalisisSectores))
      (Var5Dias (read archivoAnalisisSectores))
      (Perd3Consec (read archivoAnalisisSectores))
      (Perd5Consec (read archivoAnalisisSectores))
      (VarMes (read archivoAnalisisSectores))
      (VarTri (read archivoAnalisisSectores))
      (VarSem (read archivoAnalisisSectores))
      (VarAnual (read archivoAnalisisSectores))
    ))
    (assert (SeguirLeyendo DatosAnalisisSectores))
  )
)

(defrule cerrarFicheroAnalisisSectores
  (declare (salience -1))
  =>
  (close archivoAnalisisSectores)
)

;;;; Cartera

(defrule abrirFicheroCartera
  (declare (salience 2))
  (Fichero Cartera ?archivo)
  =>
  (open ?archivo archivoCartera)
  (assert (SeguirLeyendo DatosCartera))
)

(defrule leerFicheroCartera
  (declare (salience 1))
  ?f <- (SeguirLeyendo DatosCartera)
  =>
  (bind ?Leido (read archivoCartera))
  (retract ?f)
  (if (neq ?Leido EOF) then
    (assert (Cartera
      (Nombre ?Leido)
      (Acciones (read archivoCartera))
      (Valor (read archivoCartera))
    ))
    (assert (SeguirLeyendo DatosCartera))
  )
)

(defrule cerrarFicheroCartera
  (declare (salience -1))
  =>
  (close archivoCartera)
)

;;;; Noticias

(defrule abrirFicheroNoticias
  (declare (salience 2))
  (Fichero Noticias ?archivo)
  =>
  (open ?archivo archivoNoticias)
  (assert (SeguirLeyendo DatosNoticias))
)

(defrule leerFicheroNoticias
  (declare (salience 1))
  ?f <- (SeguirLeyendo DatosNoticias)
  =>
  (bind ?Leido (read archivoNoticias))
  (retract ?f)
  (if (neq ?Leido EOF) then
    (assert (Noticia
      (Nombre ?Leido)
      (Tipo (read archivoNoticias))
      (Antiguedad (read archivoNoticias)))
    )
    (assert (SeguirLeyendo DatosNoticias))
  )
)

(defrule cerrarFicheroNoticias
  (declare (salience -1))
  =>
  (close archivoNoticias)
)
