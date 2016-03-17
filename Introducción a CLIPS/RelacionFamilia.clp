; Definimos como hechos los parentescos de cada uno de los miembros de la familia
(deffacts Parentescos
  ; Definimos las personas de la familia según su sexo
  (Sexo "Antoñito" Hombre)        ; Yo
  (Sexo "Antonio" Hombre)         ; Padre
  (Sexo "Abuelo Antonio" Hombre)  ; Abuelo
  (Sexo "Manolo" Hombre)
  (Sexo "Pepe" Hombre)
  (Sexo "Manu" Hombre)
  (Sexo "Jaime" Hombre)
  (Sexo "Carlos" Hombre)
  (Sexo "Lolo" Hombre)

  (Sexo "Eva" Mujer)
  (Sexo "Ana" Mujer)
  (Sexo "MariCarmen" Mujer)
  (Sexo "Rosarito" Mujer)
  (Sexo "Isabel" Mujer)
  (Sexo "Inma" Mujer)
  (Sexo "Julia" Mujer)
  (Sexo "Aina" Mujer)
  (Sexo "Gloria" Mujer)
  (Sexo "Isa" Mujer)

  ; Definimos las relaciones principales entre estos miembros ("pareja de" y "padre de")
  ; Parejas
  (Relacion Pareja "Antoñito" "Eva")
  (Relacion Pareja "Antonio" "MariCarmen")
  (Relacion Pareja "Isabel" "Manu")
  (Relacion Pareja "Pepe" "Julia")
  (Relacion Pareja "Manolo" "Inma")
  (Relacion Pareja "Abuelo Antonio" "Rosarito")

  ; Padre de
  (Relacion Padre "Antonio" "Antoñito")
  (Relacion Padre "Antonio" "Ana")
  (Relacion Padre "MariCarmen" "Antoñito")
  (Relacion Padre "MariCarmen" "Ana")

  (Relacion Padre "Manolo" "Aina")
  (Relacion Padre "Manolo" "Jaime")
  (Relacion Padre "Inma" "Aina")
  (Relacion Padre "Inma" "Jaime")

  (Relacion Padre "Julia" "Gloria")
  (Relacion Padre "Julia" "Carlos")
  (Relacion Padre "Pepe" "Carlos")
  (Relacion Padre "Pepe" "Gloria")

  (Relacion Padre "Isabel" "Isa")
  (Relacion Padre "Isabel" "Lolo")
  (Relacion Padre "Manu" "Isa")
  (Relacion Padre "Manu" "Lolo")

  (Relacion Padre "Abuelo Antonio" "Antonio")
  (Relacion Padre "Rosarito" "Antonio")

  ; Definimos los duales de las relaciones (padre-hijo, nieto-abuelo, etc)
  (Dual Padre Hijo)
  (Dual Hermano Hermano)
  (Dual Tio Sobrino)
  (Dual Pareja Pareja)
  (Dual Primo Primo)
  (Dual Suegro Yerno)
  (Dual Abuelo Nieto)

  ; Definimos los parentescos compuestos (abuelo, tío, etc)
  (Compuesto Padre Padre Abuelo)
  (Compuesto Hermano Padre Tio)
  (Compuesto Pareja Hermano Cuñado)
  (Compuesto Hermano Pareja Cuñado)
  (Compuesto Hijo Tio Primo)
  (Compuesto Padre Pareja Suegro)
  (Compuesto Hijo Padre Hermano)
  (Compuesto Pareja Padre Padre)

  ; Definimos los géneros de para parentesco
  (GeneroRelacion Padre Madre)
  (GeneroRelacion Hijo Hija)
  (GeneroRelacion Tio Tia)
  (GeneroRelacion Cuñado Cuñada)
  (GeneroRelacion Primo Prima)
  (GeneroRelacion Abuelo Abuela)
  (GeneroRelacion Hermano Hermana)
  (GeneroRelacion Pareja Pareja)
  (GeneroRelacion Sobrino Sobrina)
  (GeneroRelacion Suegro Suegra)
  (GeneroRelacion Yerno Nuera)
  (GeneroRelacion Nieto Nieta)
  (GeneroRelacion Consuegro Consuegra)
)

; Definimos las relaciones duales
(defrule Dualizar
    (Relacion ?R1 ?x ?y)  ; Si hay una relación de x a y
    (Dual ?R1 ?R2)        ; Y existe su dual
    =>
    (assert (Relacion ?R2 ?y ?x))
)

; Definimos el dual de la relación dual
(defrule MetaDualizar
    (Dual ?R1 ?R2)    ; Existe dual entre R1 y R2
    =>
    (assert (Dual ?R2 ?R1))
)

; Definimos la composición de relaciones
(defrule Componer
    (Relacion ?R1 ?x ?y)      ; Si existe una relación de x a y
    (Relacion ?R2 ?y ?z)      ; Y una de y a z
    (Composicion ?R1 ?R2 ?R3) ; Las componemos
    (test (neq ?x ?z))        ; Nos cercioramos que no hablemos de la misma persona
    =>
    (assert (Relacion ?R3 ?x ?z))
)

; Pregunta donde el primer argumento es masculino
(defrule PreguntaMasculino
    (Pregunta ?nombre1 ?nombre2)            ; Preguntamos sobre estos nombres
    (Relacion ?relacion ?nombre1 ?nombre2)  ; Vemos la relación entre ambas
    (Genero ?nombre1 Hombre)                ; Sólo hombres
    =>
    (printout t crlf ?nombre1 " es " ?relacion " de " ?nombre2 crlf)
)

; Pregunta donde el primer argumento es femenino
(defrule PreguntaFemenino
    (Pregunta ?nombre1 ?nombre2)            ; Preguntamos sobre estos nombres
    (Relacion ?relacion ?nombre1 ?nombre2)  ; Vemos la relación entre ambas
    (Genero ?nombre1 Mujer)                 ; Sólo mujeres
    (RelacionGenero ?relacion ?relacionFem) ; Tomamos la relación en femenino
    =>
    (printout t crlf ?nombre1 " es " ?relacionFem " de " ?nombre2 crlf)
)

; Obtener la relación entre ambas personas
(defrule ObtenerRelacion
    =>
    (printout t "Introduzca el nombre de una persona: ")
    (bind ?nombre1 (readline))
    (printout t "Introduzca el nombre de otra persona: ")
    (bind ?nombre2 (readline))
    (assert (Pregunta ?nombre1 ?nombre2))
)
