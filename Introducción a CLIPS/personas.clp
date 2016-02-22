; Datos de personas

(deftemplate Persona
  (field Nombre)
  (field Edad)
  (field Sexo)
  (field EstadoCivil)
)

(defrule Varon
  (Persona
    (Sexo V))
  =>
  (printout t  "Tenemos un varón" crlf)
)

(deffacts VariosHechos
    (Persona
        (Nombre JuanCarlos)
        (Edad 33)
        (Sexo V)
        (EstadoCivil Soltero))

    (Persona
        (Nombre Maria)
        (Edad 23)
        (Sexo M)
        (EstadoCivil Casado))
)

(deffacts OtrosHechos
    (NumeroDeReactores 4)
)

(watch rules)
(watch facts)
(reset)
