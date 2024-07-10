# Proyecto Batalla Naval en Assembly 8086 - Michael Estrada & Juan Plúas

---

## Descripción del Proyecto
Este proyecto consiste en desarrollar una versión para computadora del juego de mesa "Batalla Naval" utilizando el ensamblador 8086. El juego está diseñado para un solo jugador y se ejecuta en un tablero de 6x6, con una flota compuesta por un portaviones, un destructor y un submarino.

### Especificaciones Funcionales
- **Tablero**: 6x6
- **Flota**: 
  - Portaviones: 5 celdas
  - Destructor: 3 celdas
  - Submarino: 3 celdas
- **Misiles**: El jugador tiene hasta 18 misiles para hundir la flota enemiga.
- **Condiciones de Victoria**: El jugador gana si hunde toda la flota enemiga con 18 misiles o menos.
- **Finalización del Juego**: Si no se hunden todos los objetivos, se resaltan las celdas donde estaban los buques no encontrados. El jugador puede optar por jugar nuevamente o salir del programa.
- **Salida Rápida**: La combinación de teclas `CTRL+E` debe habilitarse para salir del programa en cualquier momento.

### Requisitos del Proyecto
- Utilizar el simulador emu8086.
- Validaciones adecuadas para los ingresos del usuario.
- Comentarios descriptivos en el código.

### Detalles Adicionales
- **Mapa Inicial**: Al comienzo del juego se muestra el mapa del juego pero sin mostrar los barcos.
- **Validación de Celdas Atacadas**: Durante el juego se valida si el jugador ingresó una celda que ya fue atacada previamente.
- **Corregir la entrada**: Puede corregir la celda mientras tipea la entrada.
- **No necesita del ENTER**: A la hora de colocar la celda se ejecuta inmediatamente.
- **Resultado del Juego**: Al final se muestra si el jugador ganó o perdió, y se le pregunta si quiere empezar de nuevo con un nuevo mapa aleatorio.
## Capturas de Pantalla del Programa

### Pantalla Inicial
![image1.png](image1.png)

### Juego en Progreso
![image2.png](image2.png)
![image3.png](image3.png)
## Referencias
- [Battleship Online](https://www.minijuegos.com/juego/battleship-online)
- Documentación y manuales de emu8086

## Instrucciones para Ejecución
1. **Compilación**: Utilice el emulador emu8086 para compilar el archivo `.ASM`.
2. **Ejecución**: Cargue y ejecute el programa en el emulador.
3. **Interacción**: Siga las instrucciones en pantalla para jugar el juego de "Batalla Naval".
