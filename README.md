Pregunta 01

- [x] Mediante control de versiones con Git, realiza al menos dos commits: uno al iniciar el proyecto y otro al finalizar, con mensajes descriptivos.
- [x] Además, al crear el repositorio crea una rama feature/gestión sobre la cual manejaras todo el proyecto
- [x] Crea un proyecto Maven y agrega las dependencias necesarias para trabajar con JPA, Hibernate y MySQL.
- [x] Diseña la base de datos BD2_Apellido con las siguientes tablas:
- [x] tabla clientes: (id_cliente, nombre, email). Define tipos y longitudes. Inserta 3 registros de prueba.
- [x] tabla peliculas: (id_pelicula, titulo, genero, stock). Inserta 3 registros de prueba.
- [x] tabla alquileres: (id_alquiler autogenerado, fecha, id_cliente, total).
- [x] tabla detalle_alquiler: clave compuesta (id_alquiler, id_pelicula), cantidad.
- [x] Crea las entidades JPA correspondientes, aplicando:
- [x] Llaves primarias bien definidas.
- [x] Validación para que los Strings no acepten valores nulos.
- [x] La fecha del alquiler no será serializable.
- [x] El estado del alquiler (estado) será un enum con valores: Activo, Devuelto, Retrasado.

Pregunta 02

Diseñe una solución para Gestionar el Alquiler de películas:
Requisitos:
- [x] Mostrar combo de clientes y combo de películas (cargar desde la base de datos).
- [x] Permitir ingresar la cantidad y seleccionar películas.
- [x] Calcular el total automáticamente.
- [x] Registrar el alquiler en la base de datos con la fecha del sistema.
- [x] Validar datos y mostrar mensaje de éxito o error.
- [x] Termina el Branch e integra los cambios a la rama principal
- [x] Borra la rama feature/gestion