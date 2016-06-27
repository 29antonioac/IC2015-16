; Realización de propuestas del sistema experto

;; 4.1 - Obtener posibles propuestas

; Vender valores de empresas peligrosas
(defrule VenderValoresPeligrosos
  (Modulo 4)
  (Cartera (Nombre ?nombre) (Peligroso true ?explicacion))
  (Valor (Nombre ?nombre) (Sector ?sector) (VarMes ?varMes) (RPD ?RPD))
  (Sector (Nombre ?sector) (VarMes ?varSector))
  (test (< ?varMes 0))
  (test (< (- ?varMes ?varSector) -3))
  =>
  (bind ?RE (- 20 ?RPD))
  (assert (Propuesta
    (Operacion Vender)
    (Nombre ?nombre)
    (RE ?RE)
    (Explicacion (str-cat "La empresa es peligrosa porque " ?explicacion
                          ". Además está entrando en tendencia bajista "
                          "con respecto a su sector. Según mi estimación existe "
                          "una probabilidad no despreciable de que pueda caer al "
                          "cabo del año un 20%, aunque produzca "
                          ?RPD
                          "% por dividendos perderíamos un "
                          ?RE
                          "%."
                  )))
  )
)

; Invertir en empresas infravaloradas
(defrule InvertirValoresInfravalorados
  (Modulo 4)
  (Valor (Nombre ?nombre) (Sector ?sector) (PER ?PER) (RPD ?RPD) (Infravalorado true ?explicacion))

  (Cartera (Nombre DISPONIBLE) (Valor ?valor))
  (Sector (Nombre ?sector) (PER ?PERMedio))
  (test (neq ?PER 0))
  (test (> ?valor 0))
  =>
  (bind ?RE (+ (/ (* 100 (- ?PERMedio ?PER)) (* 5 ?PER)) ?RPD))
  (assert (Propuesta
    (Operacion Comprar)
    (Nombre ?nombre)
    (RE ?RE)
    (Explicacion (str-cat "Esta empresa está infravalorada porque "
                          ?explicacion
                          " y seguramente el PER tienda "
                          "al PER medio en 5 años, con lo que se debería revalorizar un "
                          ?RE
                          " anual a lo que habría que sumar el "
                          ?RPD
                          " de beneficios por dividendos."
                  )))
  )
)

; Vender valores de empresas sobrevaloradas
(defrule VenderValoresSobrevalorados
  (Modulo 4)
  (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Sector ?sector) (PER ?PER) (RPD ?RPD) (RPA ?RPA) (Sobrevalorado true ?explicacion))
  (Sector (Nombre ?nombre) (PER ?PERMedio))
  ; Hasta que vea el precio del dinero
  (bind ?precioDinero 0)
  ;;;;;;;

  (test (neq ?PER 0))
  (test (< ?RPA (+ 5 ?precioDinero)))
  =>
  (bind ?RE (- (/ (- ?PER ?PERMedio) (* 5 ?PER)) ?RPD))
  (assert (Propuesta
    (Operacion Vender)
    (Nombre ?nombre)
    (RE ?RE)
    (Explicacion (str-cat "Esta empresa está sobrevalorada, es mejor amortizar "
                          "lo invertido, ya que seguramente el PER tan alto deberá "
                          "bajar al PER medio del sector en unos 5 años, con lo que "
                          "se devería devaluar un "
                          ?RE
                          " anual, así que aunque se pierda el "
                          ?RPD
                          " de beneficios por dividendos saldría rentable."
                  )))
  )
)

; Cambiar inversión a valores más rentables
(defrule CambiarInversion
  (Modulo 4)
  (Valor (Nombre ?empresa1) (RPD ?RPD1) (RPA ?RPA1) (Sobrevalorado ~true))
  (Cartera (Nombre ?empresa2))
  (Valor (Nombre ?empresa2 & ~?empresa1) (RPD ?RPD2) (RPA ?RPA2) (Infravalorado ~true))
  (test (> ?RPD1 (+ ?RPA2 ?RPD2 1)))
  =>
  (bind ?valorEmpresa2 (+ ?RPA2 ?RPD2 1))
  (bind ?RE (- ?RPD1 ?valorEmpresa2))
  (assert (Propuesta
    (Operacion Cambiar)
    (Nombre ?empresa2)
    (RE ?RE)
    (Explicacion (str-cat ?empresa1
                          " debe tener una revalorización acorde con la evolución "
                          "de la bolsa. Por dividendos se espera un "
                          ?RPD1
                          ", que es más que lo que te está dando "
                          ?empresa2
                          ", por eso te propongo cambiar los valores por los de esta otra "
                          ?valorEmpresa2
                          ". Aunque se pague el 1% del coste del cambio te saldría rentable."
                  ))
    (OtraEmpresa ?empresa1))
  )
)

(defrule CerrarModulo4
  (declare (salience -10000))
  ?f <- (Modulo 4)
  =>
  (retract ?f)
  (assert (Modulo 5))
)
