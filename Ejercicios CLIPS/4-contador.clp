(defrule IniciarContador
  ; Si queremos contar hechos y no hemos empezado lo ponemos a 0
  (ContarHechos ?hecho)
  (not (NumeroHechos ?hecho ?numhechos))
  =>
  (assert (NumeroHechos ?hecho 0))
)

(defrule Sumar
  ; Añadimos una suma de uno a cada hecho que hay que contar
  (ContarHechos ?hecho)
  (Hecho ?hecho $?)
  =>
  (assert (MasUno ?hecho))
)

(defrule ContarUno
  ; Si hay una suma y el número es numhechos
  ?suma <- (MasUno ?hecho)
  ?anterior <- (NumeroHechos ?hecho ?numhechos)
  =>
  ; Sumamos 1 y quitamos la sumatoria y el número de hechos anterior
  (assert (NumeroHechos ?hecho (+ ?numhechos 1))
  (retract ?suma ?anterior)
)
