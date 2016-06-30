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
  (Menu 3 "Guardar cartera")
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
      (assert (Vender ?Nombre -1))
      else
        (if (eq ?Operacion Comprar) then
          (assert (Comprar ?Nombre -1))
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
  ?f <- (Comprar ?Nombre ?input)
  ?Cartera <- (Cartera (Nombre DISPONIBLE) (Valor ?disponible))
  (Valor (Nombre ?Nombre) (Precio ?Precio))
  =>
  (if (eq ?input -1) then
    (printout t crlf "Comprar acciones de " ?Nombre ". ¿Cuántas? Tu saldo disponible es " ?disponible " y el precio por acción es " ?Precio ": ")
    (bind ?cuanto (read))
    (bind ?costeBruto (* ?cuanto ?Precio ))
    (while (> ?costeBruto ?disponible)
      (printout t "No tienes suficiente saldo" crlf)
      (printout t crlf "Comprar acciones de " ?Nombre ". ¿Cuántas? Tu saldo disponible es " ?disponible " y el precio por acción es " ?Precio ": ")
      (bind ?cuanto (read))

      (bind ?costeBruto (* ?cuanto ?Precio))
    )
  else
    ; Meter comisión
    (bind ?cuanto ?input)
    (bind ?costeBruto (* ?cuanto ?Precio))
  )
  (bind ?coste (* 1.005 ?costeBruto))

  ; Actualizar valor de dicha acción en la cartera (si existe)
  (do-for-fact
      ((?vc Cartera))
      (eq ?Nombre (fact-slot-value ?vc Nombre))

      ; Obtenemos el número actual de acciones
      (bind ?vcAcc (fact-slot-value ?vc Acciones))
      ;
      ; Actualizamos el valor de acciones que vamos a tener
      (bind ?cuanto (+ ?vcAcc ?cuanto))

      ; Eliminamos el valor de la cartera
      (retract ?vc)
  )


  (modify ?Cartera (Valor (- ?disponible ?coste)))
  ; Distinguir si ya tengo algo de aquí en la cartera
  (assert (Cartera (Nombre ?Nombre) (Acciones ?cuanto) (Valor ?costeBruto)))
  (printout t crlf "Tienes " ?cuanto " acciones de " ?Nombre crlf)
  (retract ?f)
  (retract ?m)
  (assert (Modulo 4))
)

(defrule Vender
  ?m <- (Modulo 5)
  ?f <- (Vender ?Nombre ?input)
  ?Cartera <- (Cartera (Nombre ?Nombre) (Acciones ?disponible) (Valor ?valor))
  ?Liquido <- (Cartera (Nombre DISPONIBLE) (Acciones ?accLiquido) (Valor ?liquido))
  (Valor (Nombre ?Nombre) (Precio ?Precio))
  =>
  (if (eq ?input -1) then
    (printout t crlf "Vender acciones de " ?Nombre ". ¿Cuántas? Tus acciones disponibles son " ?disponible " y el precio por acción es " ?Precio ": ")
    (bind ?cuanto (read))
    (while (> ?cuanto ?disponible)
      (printout t "No tienes suficientes acciones" crlf)
      (printout t crlf "Vender acciones de " ?Nombre ". ¿Cuántas? Tus acciones disponibles son " ?disponible " y el precio por acción es " ?Precio ": ")
      (bind ?cuanto (read))
    )
  else
    (bind ?cuanto ?input)
  )
  ; Meter comisión
  (bind ?costeBruto (* ?cuanto ?Precio ))
  (bind ?coste (* 0.95 ?costeBruto ))
  (if (eq ?disponible ?cuanto) then
    (retract ?Cartera)
  else
    (modify ?Cartera (Acciones (- ?disponible ?cuanto)))
    (modify ?Cartera (Valor (- ?valor ?costeBruto)))
  )
  ; Actualizar líquido
  (modify ?Liquido (Valor (+ ?liquido ?coste)))
  (modify ?Liquido (Acciones (+ ?accLiquido ?coste)))
  (printout t crlf "Se han vendido " ?cuanto " acciones de " ?Nombre crlf)
  (retract ?f)
  (retract ?m)
  (assert (Modulo 4))
)

(defrule Intercambiar
  (Modulo 5)
  ?f <- (Intercambiar ?EmpresaVender ?EmpresaComprar)
  (Valor (Nombre ?EmpresaVender)  (Precio ?PrecioVender))
  (Valor (Nombre ?EmpresaComprar) (Precio ?PrecioComprar))
  (Cartera (Nombre ?EmpresaVender) (Acciones ?AccionesVender))
  =>
  (retract ?f)

  (bind ?ratio (/ ?PrecioVender ?PrecioComprar))

  ; Calculamos el capital total de la cartera
  (bind ?valorTotalCartera 0)
  (do-for-all-facts ((?cart Cartera)) TRUE
      (bind ?valorActual (fact-slot-value ?cart Valor))
      (bind ?valorTotalCartera (+ ?valorTotalCartera ?valorActual))
  )

  (printout t "El capital total de tu cartera es de " ?valorTotalCartera ". Por cada acción de " ?EmpresaVender " puedes comprar " ?ratio " acciones de " ?EmpresaComprar ". Por favor, introduce el número de acciones que quieres vender de " ?EmpresaVender " y nostros calcularemos cuántas comprar de " ?EmpresaComprar ": ")


  (bind ?acc (read))

  (while (not (and (>= ?acc 0) (<= ?acc ?AccionesVender) ) ) do
      (format t "\n El número de acciones debe estar entre %d y %d: "
          0 ?AccionesVender
      )
      (bind ?acc (read))
  )

  (bind ?cuantasComprar (div (* ?acc ?ratio) 1))

  ; Vendemos las acciones indicadas por el usuario
  (assert (Vender ?EmpresaVender ?acc))

  ; Compramos las acciones indicadas el usuario
  (assert (Comprar ?EmpresaComprar ?cuantasComprar))

)

;; Mostrar la cartera del usuario

(defrule MostrarCartera
  (Modulo 5)
  ?f <- (Respuesta 2)
  =>
  (retract ?f)
  (printout t crlf)

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
  (printout t crlf)
  (assert(QuieroMenu))
)

(defrule GuardarCartera
  (Modulo 5)
  ?g <- (Respuesta 3)
  (Fichero Cartera ?ficheroCartera)
  =>
  (retract ?g)
  (open ?ficheroCartera fichCartera "w")

  (do-for-all-facts ((?v Cartera)) TRUE
      (bind ?nombre (fact-slot-value ?v Nombre))
      (bind ?acciones (fact-slot-value ?v Acciones))
      (bind ?valor (fact-slot-value ?v Valor))
      (printout fichCartera ?nombre " " ?acciones " " ?valor crlf)
  )

  (close fichCartera)

  (printout t crlf "Cartera guardada en " ?ficheroCartera "." crlf)

)

(defrule Salir
  (Modulo 5)
  (Respuesta 0)
  =>
  (exit)
)
