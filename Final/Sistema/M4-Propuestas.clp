; Realización de propuestas del sistema experto

;; 4.1 - Obtener posibles propuestas

; Vender valores de empresas peligrosas
(defrule VenderValoresPeligrosos
  (Modulo 4)
  (Cartera (Nombre ?nombre) (Peligrosidad true))
  ; Hasta que meta la explicación de la Peligrosidad
  (bind ?explicacion "Porque sí")
  ;;;;;;;
  (Valor (Nombre ?nombre) (Sector ?sector) (VarMes ?varMes) (RPD ?RPD))
  (Sector (Nombre ?sector) (VarMes ?varSector))
  (test (< ?varMes 0))
  (test (< (- ?varMes ?varSector) -3))
  =>
  (bind ?RE (- 20 ?RPD))
  (assert Propuesta
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
                  ))
  )
)

; Invertir en empresas infravaloradas
(defrule InvertirValoresInfravalorados
  (Modulo 4)
  (Valor (Nombre ?nombre) (Sector ?sector) (PER ?PER) (RPD ?RPD) (Infravalorada true))
  ; Hasta que meta la explicación de la Infravalorada
  (bind ?explicacion "Porque sí")
  ;;;;;;;

  (Cartera (Nombre DISPONIBLE) (Valor ?valor))
  (Sector (Nombre ?sector) (PER ?PERMedio))
  (test (> ?valor 0))
  =>
  (bind ?RE (+ (/ (* 100 (- ?PERMedio ?PER)) (* 5 ?PER)) ?RPD))
  (assert Propuesta
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
                  ))
  )
)

; Vender valores de empresas sobrevaloradas
(defrule VenderValoresSobrevalorados
  (Cartera (Nombre ?nombre))
  (Valor (Nombre ?nombre) (Sobrevalorado true))
  ; Hasta que meta la explicación de Sobrevalorado
  (bind ?explicacion "Porque sí")
  ;;;;;;;

  =>
  (bind ?RE (- () ?RPD))
  (assert Propuesta
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
                  ))

  )

)
