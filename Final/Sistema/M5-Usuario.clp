; Interacción con el usuario del sistema experto

;; 4.2 - Interacción con el usuario

; Busca el valor con mayor rendimiento esperado
; Basado en el Ejercicio 9 de Jacinto Carrasco Castillo de la Wiki
; http://ic4.ugr.es/prd/doku.php?id=asignatura:ic:ejercicio_9
(defrule MaxRE
  (Modulo 5)
  (Propuesta (Nombre ?N1) (RE ?S1))
  (not  (and (Propuesta (Nombre ?) (RE ?S2)) (test(> ?S2 ?S1))))
  =>
  (assert (MejorPropuesta ?N1 ?S1))
)

;; Menú principal

(deffacts OpcionesMenu
  (Menu 0 "Salir")
  (Menu 1 "Mostrar propuestas")
)

(defrule Iniciar
  (declare (salience 100))
  (Modulo 5)
  =>
  (printout t crlf)
  (assert (QuieroMenu))
)

(defrule MostrarMenu
  (Modulo 5)
  (QuieroMenu)
  (Menu ?opcion ?mensaje)
  =>
  (printout t "Pulsa " ?opcion " para " ?mensaje crlf)
)

(defrule LeerRespuesta
  (Modulo 5)
  ?f <- (QuieroMenu)
  =>
  (retract ?f)
  (bind ?Respuesta (read))
	(assert (Respuesta ?Respuesta)))

(defrule OpcionIncorrecta
  (Modulo 5)
  ?f <- (Respuesta ?Respuesta)
  (not (Menu ?Respuesta ?))
  =>
  (retract ?f)
  (printout t "Esta opción no existe" crlf)
  (assert (QuieroMenu))
)

;; Mostrar propuestas

(defrule MostrarPropuestas
  (Modulo 5)
  ?f <- (Respuesta 1)
  (MejorPropuesta ?Nombre ?RE)
  (Propuesta (Operacion ?Operacion) (Nombre ?Nombre) (RE ?RE) (Explicacion ?Explicacion) )
  =>
  (retract ?f)
  (printout t crlf ?Nombre crlf ?Operacion crlf ?Explicacion crlf)
)

(defrule Salir
  (Modulo 5)
  (Respuesta 0)
  =>
  (exit)
)




(defrule CerrarModulo5
  (declare (salience -10000))
  ?f <- (Modulo 5)
  =>
  (retract ?f)
)
