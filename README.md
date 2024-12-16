# ProgramMemoryAnimations
Programa en ensamblador para DSPIC33FJ32MC202 que ejecuta 8 animaciones LED (como cortinas, llenado y vaciado) con retardos ajustables (350 ms, 500 ms, 100 µs) controlados mediante PORTA y PORTB. Los patrones de animación están almacenados en memoria de programa para optimizar el uso de recursos.

El archivo P5.s es el código en lenguaje ensamblador en donde se encuentra la lógica de los retardos y memoria del programa. El archivo p33FJ32MC202.gld es el archvo linker. El archivo p33FJ32MC202.inc es el archvo header. El archivo de proteus requiere un .hex para poder ejecutar en el dspic el código.

Este proyecto contiene un conjunto de programas en ensamblador diseñados para el microcontrolador DSPIC33FJ32MC202. El enfoque principal es implementar animaciones LED utilizando retardos configurables y patrones almacenados en la memoria de programa. A continuación, se detalla su funcionamiento:

## Funcionalidades principales
Animaciones LED
Se implementan 8 tipos de animaciones que incluyen:

Shift Right/Left: Desplazamientos de bits hacia la derecha e izquierda.
Cortina: Apertura y cierre en patrones.
Blink: Encendido y apagado de LEDs de forma intermitente.
Llenado/Vaciado: Incremental y doble.
Control de retardos
Tres retardos ajustables:

500 ms
350 ms
100 µs
La selección se realiza mediante los bits habilitados en el puerto PORTB.
Uso eficiente de memoria
Los patrones de las animaciones están almacenados en la memoria de programa, optimizando el uso de los registros de propósito general y la memoria RAM.

## Interacción dinámica

PORTA: Selección de la animación activa.
PORTB: Configuración del retardo y ejecución continua de animaciones.
Estructura del proyecto
Código principal: Implementa el control de puertos, la selección de patrones y la ejecución de animaciones mediante retardos controlados.
Memoria de programa: Los patrones de las animaciones se almacenan en secciones definidas del espacio de programa, utilizando directivas como .WORD para cargar datos directamente en los registros.
Retardos configurables: Algoritmo optimizado para ciclos de retardo ajustables mediante variables y bucles.
Cómo usar este proyecto
Simulación
Puede ejecutarse en herramientas como Proteus para observar las animaciones en circuitos simulados de LEDs.

## Configuración de retardos

Cambiar los valores en PORTB para seleccionar uno de los tres retardos disponibles.
Selección de animaciones

Utilizar los bits de PORTA para elegir la animación deseada.
