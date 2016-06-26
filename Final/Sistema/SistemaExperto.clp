(deffunction main()
  (clear)
  (load "Estructuras.clp")
  (load "M0-LeerFicheros.clp")
  (load "M0-Deducciones.clp")
  (load "M1-Peligrosos.clp")
  (load "M2-Sobrevalorados.clp")
  ; Aquí los que queden
  (reset)
  (assert (Modulo 0))
  (run)
)

(main)
