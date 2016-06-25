(deffacts Ficheros
  (Fichero Analisis         "DatosIbex35/Analisis.txt")
  (Fichero AnalisisSectores "DatosIbex35/AnalisisSectores.txt")
  (Fichero Cartera          "DatosIbex35/Cartera.txt")
  (Fichero Noticias         "DatosIbex35/Noticias.txt")
)


(defrule abrirFicheroAnalisis
  (declare (salience 10))
  (Fichero Analisis ?archivo)
  =>
  (open ?archivo archivoAnalisis)
  (assert (SeguirLeyendo))
)

(defrule leerFicheroAnalisis
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Leido (read archivoAnalisis))
  (retract ?f)
  (if (neq ?Leido EOF) then
    (assert (ValorCierre ?Leido (read archivoAnalisis)))
    (assert (SeguirLeyendo))
  )
)

(defrule cerrarFicheroAnalisis
  (declare (salience -10))
  =>
  (close archivoAnalisis)
)

;;;;;

(defrule abrirFicheroAnalisisSectores
  (declare (salience 10))
  (Fichero AnalisisSectores ?archivo)
  =>
  (open ?archivo archivoAnalisisSectores)
  (assert (SeguirLeyendo))
)

(defrule leerFicheroAnalisisSectores
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Leido (read archivoAnalisisSectores))
  (retract ?f)
  (if (neq ?LeidoEOF) then
    (assert (ValorCierre ?Leido (read archivoAnalisisSectores)))
    (assert (SeguirLeyendo))
  )
)

(defrule cerrarFicheroAnalisisSectores
  (declare (salience -10))
  =>
  (close archivoAnalisisSectores)
)

;;;;;;

(defrule abrirFicheroCartera
  (declare (salience 10))
  (Fichero Cartera ?archivo)
  =>
  (open ?archivo archivoCartera)
  (assert (SeguirLeyendo))
)

(defrule leerFicheroCartera
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Leido (read archivoCartera))
  (retract ?f)
  (if (neq ?LeidoEOF) then
    (assert (ValorCierre ?Leido (read archivoCartera)))
    (assert (SeguirLeyendo))
  )
)

(defrule cerrarFicheroCartera
  (declare (salience -10))
  =>
  (close archivoCartera)
)
;;;;;;;

(defrule abrirFicheroNoticias
  (declare (salience 10))
  (Fichero Noticias ?archivo)
  =>
  (open ?archivo archivoNoticias)
  (assert (SeguirLeyendo))
)

(defrule leerFicheroNoticias
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Leido (read archivoNoticias))
  (retract ?f)
  (if (neq ?LeidoEOF) then
    (assert (ValorCierre ?Leido (read archivoNoticias)))
    (assert (SeguirLeyendo))
  )
)

(defrule cerrarFicheroNoticias
  (declare (salience -10))
  =>
  (close archivoNoticias)
)
