; Interacción con el usuario del sistema experto

;; 4.2 - Interacción con el usuario

; Busca el valor con mayor rendimiento esperado
; Basado en el Ejercicio 9 de Jacinto Carrasco Castillo de la Wiki
; http://ic4.ugr.es/prd/doku.php?id=asignatura:ic:ejercicio_9
; (defrule MaxRE
;   (Modulo 5)
;   (Propuesta (Nombre ?N1) (RE ?S1))
;   (not  (and (Propuesta (Nombre ?) (RE ?S2)) (test(> ?S2 ?S1))))
;   =>
;   (assert (MejorPropuesta ?N1 ?S1))
; )

;; Menú principal

(deffacts OpcionesMenu
  (Menu 0 "Salir")
  (Menu 1 "Mostrar propuestas")
  (Menu 2 "Ver cartera")
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
	(assert (Respuesta ?Respuesta))
)

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
  ?numPropuestas <- (NumeroPropuestas ?num)
  (MaximoPropuestas ?max)
  (test (< ?num ?max))
  ?mejor <- (Propuesta (Operacion ?Operacion) (Nombre ?Nombre) (RE ?RE)
            (Explicacion ?Explicacion) (OtraEmpresa ?Otra))
  (not  (and (Propuesta (Nombre ?) (RE ?S2)) (test(> ?S2 ?RE))))
  =>
  (printout t crlf ?Nombre crlf ?Operacion crlf ?Explicacion crlf)
  (printout t "Pulsa S si aceptas o cualquier otra tecla para rechazar: ")
  (bind ?Aceptar (read))
  (if (or (eq ?Aceptar S) (eq ?Aceptar s)) then
    (retract ?f)
    (if (eq ?Operacion Vender) then
      (assert (Vender ?Nombre))
      else
        (if (eq ?Operacion Comprar) then
          (assert (Comprar ?Nombre))
        else
          (assert (Intercambiar ?Nombre ?Otra))
        )
    )
  else
    (retract ?numPropuestas)
    (assert (NumeroPropuestas (+ ?num 1)))
  )
  (retract ?mejor)
)

(defrule Recalcular
  ?f <- (Modulo 5)
  ?numPropuestas <- (NumeroPropuestas ?num)
  (MaximoPropuestas ?max)
  (test (eq ?num ?max))
  =>
  (printout t crlf "Recalculando propuestas...")
  (retract ?f)
  (retract ?numPropuestas)
  (assert (NumeroPropuestas 0))
  (assert (Modulo 4))
)

;; Realizar operaciones

(defrule Comprar
  ?m <- (Modulo 5)
  ?f <- (Comprar ?Nombre)
  ?Cartera <- (Cartera (Nombre DISPONIBLE) (Valor ?disponible))
  (Valor (Nombre ?Nombre) (Precio ?Precio))
  =>
  (printout t crlf "Comprar acciones de " ?Nombre ". ¿Cuántas? Tu saldo disponible es " ?disponible " y el precio por acción es " ?Precio ": ")
  (bind ?cuanto (read))
  (bind ?coste (* ?cuanto ?Precio ))
  (while (> ?coste ?disponible)
    (printout t "No tienes suficiente saldo" crlf)
    (printout t crlf "Comprar acciones de " ?Nombre ". ¿Cuántas? Tu saldo disponible es " ?disponible " y el precio por acción es " ?Precio ": ")
    (bind ?cuanto (read))
    ; Meter comisión
    (bind ?coste (* ?cuanto ?Precio ))
  )
  (modify ?Cartera (Valor (- ?disponible ?coste)))
  ; Distinguir si ya tengo algo de aquí en la cartera
  (assert (Cartera (Nombre ?Nombre) (Acciones ?cuanto) (Valor ?coste)))
  (printout t crlf "Se han comprado " ?cuanto " acciones de " ?Nombre crlf)
  (retract ?f)
  (retract ?m)
  (assert (Modulo 4))
)

(defrule Vender
  ?m <- (Modulo 5)
  ?f <- (Vender ?Nombre)
  ?Cartera <- (Cartera (Nombre ?Nombre) (Acciones ?disponible) (Valor ?valor))
  ?Liquido <- (Cartera (Nombre DISPONIBLE) (Acciones ?accLiquido) (Valor ?liquido))
  (Valor (Nombre ?Nombre) (Precio ?Precio))
  =>
  (printout t crlf "Vender acciones de " ?Nombre ". ¿Cuántas? Tus acciones disponibles son " ?disponible " y el precio por acción es " ?Precio ": ")
  (bind ?cuanto (read))
  (while (> ?cuanto ?disponible)
    (printout t "No tienes suficientes acciones" crlf)
    (printout t crlf "Vender acciones de " ?Nombre ". ¿Cuántas? Tus acciones disponibles son " ?disponible " y el precio por acción es " ?Precio ": ")
    (bind ?cuanto (read))
  )
  ; Meter comisión
  (bind ?coste (* 0.995 ?cuanto ?Precio ))
  (if (eq ?disponible ?cuanto)
    (retract ?Cartera)
  else
    (modify ?Cartera (Acciones (- ?disponible ?cuanto) (Valor (- ?valor ?coste))))
  )
  ; Actualizar líquido
  (modify ?liquido (Valor (+ ?liquido ?coste) (Acciones (+ ?accLiquido ?coste))))
  (printout t crlf "Se han vendido " ?cuanto " acciones de " ?Nombre crlf)
  (retract ?f)
  (retract ?m)
  (assert (Modulo 4))
)

(defrule Intercambiar


)

;; Mostrar la cartera del usuario

(defrule MostrarCartera
  (Modulo 5)
  ?f <- (Respuesta 2)
  =>
  (retract ?f)

  (do-for-all-facts ((?valorC Cartera)) TRUE
    (bind ?nombre (fact-slot-value ?valorC Nombre))
    (bind ?acciones (fact-slot-value ?valorC Acciones))
    (bind ?valor (fact-slot-value ?valorC Valor))

    (if (eq ?nombre DISPONIBLE) then
      (printout t "Capital líquido: " ?valor "€." crlf)
    else
      (printout t ?nombre ": " ?acciones " acciones con un valor de "
             ?valor "€." crlf)
    )
  )

  (printout t crlf "Pulse la tecla [Entrar] para continuar... ")
  (readline)
  (assert(QuieroMenu))
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
