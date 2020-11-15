# Marvel Heroes iOS
Aplicación que trae una lista de super heroes de marvel y muestra el detalle de cada uno.

Esta app cuenta con:

1. Un patron de diseño MVVM+Coordinator.
2. Cuenta con pruebas unitarias y UI.
3. Para realizar el diseño de la UX/UI he usado Xibs.
4. Toda la navegación esta aislada con el patrón coordinator.
5. He agregado un empty state por si se va la internet o hay un error. Es Spider man diciendo Oh No!(Ese es mi favorito :)
6. Spider man Oh no! tambien aparece si hubo algtun error descargando la imagen del superheroe.
7. Algunos Super heroes no tienen descripción. Asi que puse un mensaje de aviso.
8. Para mas información del super heroe implemente Safari controller para que pueda navegar desde la misma App a los enlaces del heroe.
9. Las imagenes usan cache, por ende, cuando se reutiliza la celda la imagen se recarga sin internet.
10. Hay una capa de Data y Dominio donde podemos aislar la logica de negocio de la de presentación.

En fin, Gracias por su tiempo en analizar este proyecto.

Saludos
