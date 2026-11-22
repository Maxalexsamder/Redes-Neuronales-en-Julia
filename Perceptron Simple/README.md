# Perceptrón Simple en Julia

Implementación de un perceptrón unicapa desarrollado en **Julia** para el reconocimiento y clasificación de patrones correspondientes a cinco operaciones matemáticas básicas: **suma**, **resta**, **multiplicación**, **división** y **potencia**.

---

### Estructura de archivos

Para que las rutas relativas funcionen correctamente durante la ejecución, todos los archivos y subcarpetas deben mantenerse dentro de este mismo directorio:

```text
Perceptron-Simple/
├── perceptron_simple.jl          # Script principal: entrenamiento y clasificación del perceptrón
├── procesar_matriz.jl            # Módulo auxiliar para lectura y procesamiento de matrices
├── matriz_entrada.txt            # Matriz de prueba que será evaluada por el modelo
├── patrones de entrenamiento/    # Conjunto de datos de entrenamiento por operación
│   ├── suma_patrones.txt
│   ├── resta_patrones.txt
│   ├── multiplicacion_patrones.txt
│   ├── division_patrones.txt
│   └── potencia_patrones.txt
└── README.md                     # Documentación de esta implementación
```

## Requisitos y librerías

* **Entorno:** Julia (versión 1.x o superior).
* **Dependencias:** Ninguna. Utiliza únicamente la biblioteca estándar de Julia.

---

### Funcionamiento

1. **Procesamiento de datos (`procesar_matriz.jl`):** Lee las matrices desde los archivos de texto y las convierte al formato numérico que requiere la red.
2. **Entrenamiento (`perceptron_simple.jl`):** Carga los ejemplos de `patrones de entrenamiento/` y ajusta los pesos sinápticos y el sesgo (*bias*) mediante la regla de aprendizaje del perceptrón.
3. **Evaluación (`matriz_entrada.txt`):** Analiza el patrón definido por el usuario y determina a cuál de las cinco operaciones matemáticas corresponde.

---

### Proceso de ejecución

1. **Comprobar archivos:** Verifica que `perceptron_simple.jl`, `procesar_matriz.jl`, `matriz_entrada.txt` y la carpeta `patrones de entrenamiento/` estén juntos dentro de `Perceptron-Simple/`.
2. **Configurar la entrada:** Abre `matriz_entrada.txt`, introduce el patrón matricial que deseas evaluar (manteniendo el formato numérico de los patrones de entrenamiento) y guarda el archivo.
3. **Ejecutar el modelo:** Abre una terminal, ubícate en la carpeta del proyecto y lanza el script principal:
   ```bash
   cd Perceptron-Simple
   julia perceptron_simple.jl
   ```
4. **Ver resultado:** El programa cargará `procesar_matriz.jl`, entrenará la red y mostrará directamente en la terminal la operación matemática reconocida.

