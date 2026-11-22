using LinearAlgebra # Para poder usar dot()
using Printf        # Para imprimir los pesos alineados a 2 decimales
include("procesar_matriz.jl")

# Entradas
    #Pesos
w_suma, w_resta, w_multi, w_div, w_pot = [zeros(49) for _ in 1:5] 

    #Error
b_suma = b_resta= b_multi= b_div= b_pot= 0.0

    #Patrones y Criteros
suma_patrones = procesar_matriz_patron("patrones de entrenamiento/suma_patrones.txt")
criterio_suma = [0, 0, 0, 0, 0, 0, 1]

resta_patrones = procesar_matriz_patron("patrones de entrenamiento/resta_patrones.txt")
criterio_resta= [0, 0, 0, 0, 0, 0, 1]

multi_patrones = procesar_matriz_patron("patrones de entrenamiento/multiplicacion_patrones.txt")
criterio_multi= [0, 0, 0, 0, 0, 0, 0, 1]

div_patrones = procesar_matriz_patron("patrones de entrenamiento2/division_patrones.txt")
criterio_div = [0, 0, 0, 0, 0, 0, 1]

pot_patrones = procesar_matriz_patron("patrones de entrenamiento/potencia_patrones.txt")
criterio_pot = [0, 0, 0, 0, 0, 0, 1, 1, 1]

tasa_aprendizaje = 0.01 
epocas = 100

matriz_valida, matriz_entrada = procesar_matriz_entrada("matriz_entrada.txt")

# Fin entradas

# Proceso
function Activacion(x, w, b)
    z = dot(x, w) + b
    salida = z >= 0.0 ? 1 : 0
    return salida, z
end

function imprimir_matriz_pesos(w, b, nombre_operador)
    println("Matriz de pesos 7x7 — $nombre_operador (Sesgo b = $(@sprintf("%+.2f", b))):")
    println("-"^52)
    for fila in 1:7
        for col in 1:7
            idx = (fila - 1) * 7 + col # Reconstruye fila por fila (igual que el .txt)
            @printf("%+7.2f", w[idx])
        end
        println()
    end
    println("-"^52)
end

function imprimir_matriz_entrada(x, titulo="Matriz de prueba introducida (7x7):")
    println("\n$titulo")
    println("-"^21)
    for fila in 1:7
        for col in 1:7
            idx = (fila - 1) * 7 + col
            print(" ", x[idx], " ")
        end
        println()
    end
    println("-"^21)
end

function centrar_matriz(x::AbstractVector{<:Integer})
    filas = Int[]
    cols  = Int[]

    for f in 1:7, c in 1:7
        if x[(f - 1) * 7 + c] == 1
            push!(filas, f)
            push!(cols, c)
        end
    end

    # Si la matriz está completamente en ceros, se devuelve igual
    isempty(filas) && return copy(x)

    # Centro de la caja delimitadora respecto al centro del tablero (4, 4)
    centro_f = cld(minimum(filas) + maximum(filas), 2)
    centro_c = cld(minimum(cols) + maximum(cols), 2)

    desp_f = 4 - centro_f
    desp_c = 4 - centro_c

    centrada = zeros(Int, 49)
    for (f, c) in zip(filas, cols)
        nf = f + desp_f
        nc = c + desp_c
        if 1 <= nf <= 7 && 1 <= nc <= 7
            centrada[(nf - 1) * 7 + nc] = 1
        end
    end

    return centrada
end


function Entrenamiento(w, b, tasa_aprendizaje, epocas, patrones, objetivos, nombre_operador)
    println("\nEntrenando perceptrón: $nombre_operador...")
    patrones_centrados = centrar_matriz.(patrones) # Normaliza todos los patrones igual que la prueba

    for epoca in 1:epocas
        error_total = 0
        for i in 1:length(patrones_centrados)
            obtenido, = Activacion(patrones_centrados[i], w, b)
            error = objetivos[i] - obtenido
            
            if error != 0
                error_total += error^2
                w .+= tasa_aprendizaje * error .* patrones_centrados[i]
                b += tasa_aprendizaje * error
            end
        end
        if error_total == 0
            println("Convergencia alcanzada en la época $epoca.")
            break
        end
    end

    imprimir_matriz_pesos(w, b, nombre_operador)
    return w, b
end


#   Zona de entrenamientos de Perceptrones
w_suma, b_suma = Entrenamiento(w_suma, b_suma, tasa_aprendizaje, epocas, suma_patrones, criterio_suma, "SUMA (+)")
w_resta, b_resta = Entrenamiento(w_resta, b_resta, tasa_aprendizaje, epocas, resta_patrones, criterio_resta, "RESTA (-)")
w_multi, b_multi = Entrenamiento(w_multi, b_multi, tasa_aprendizaje, epocas, multi_patrones, criterio_multi, "MULTIPLICACIÓN (*|x)")
w_div, b_div = Entrenamiento(w_div, b_div, tasa_aprendizaje, epocas, div_patrones, criterio_div, "DIVISIÓN (/|÷)")
w_pot, b_pot = Entrenamiento(w_pot, b_pot, tasa_aprendizaje, epocas, pot_patrones, criterio_pot, "POTENCIA (^)")


# Fin proceso 

# Salida
if matriz_valida
    println("\n==========================================")
    println("¡Matriz validada! Evaluando en todos los modelos...")
    
    imprimir_matriz_entrada(matriz_entrada, "Matriz original introducida (7x7):")
    matriz_centrada = centrar_matriz(matriz_entrada)
    imprimir_matriz_entrada(matriz_centrada, "Matriz centrada para evaluación (7x7):")
    println()
    
    # Ambos perceptrones leen la misma entrada
    salida_suma, z_suma = Activacion(matriz_centrada, w_suma, b_suma)
    salida_resta, z_resta = Activacion(matriz_centrada, w_resta, b_resta)
    salida_multi, z_multi = Activacion(matriz_centrada, w_multi, b_multi)
    salida_div, z_div = Activacion(matriz_centrada, w_div, b_div)
    salida_pot, z_pot = Activacion(matriz_centrada, w_pot, b_pot)
    
    # Agrupamos los resultados
    modelos = [
        ("SUMA (+)", salida_suma, z_suma),
        ("RESTA (-)", salida_resta, z_resta),
        ("MULTIPLICACIÓN (*|x)", salida_multi, z_multi),
        ("DIVISIÓN (/|÷)", salida_div, z_div),
        ("POTENCIA(^)", salida_pot, z_pot)
    ]
    
    # Tabla visual completa
    println(rpad("Operador", 24), " | ", rpad("Estado Binario", 16), " | ", "Potencial Real (z)")
    println("-"^66)
    for (nombre, activado, z) in modelos
        estado = activado == 1 ? "ACTIVADO (1)" : "INACTIVO (0)"
        println(rpad(nombre, 24), " | ", rpad(estado, 16), " | ", round(z, digits=4))
    end
    println("-"^66)
    
    # Filtrar activados
    activados = filter(m -> m[2] == 1, modelos)
    
    if isempty(activados)
        println("Diagnóstico: Ningún perceptrón superó el umbral (z < 0.0 en todos).")
        sort!(modelos, by = m -> m[3], rev = true)
        println("Observación: El símbolo más cercano fue $(modelos[1][1]) con z = $(round(modelos[1][3], digits=4)).")
        println("Resultado final: Patrón no reconocido.")
        
    elseif length(activados) == 1
        println("Diagnóstico: Clasificación sin conflicto.")
        println("Resultado final: Corresponde al símbolo de $(activados[1][1]).")
        
    else
        println("Diagnóstico: ¡CONFLICTO DETECTADO!")
        println("Se activaron simultáneamente $(length(activados)) perceptrones:")
        for m in activados
            println("  -> $(m[1]) con z = $(round(m[3], digits=4))")
        end
        
        # Auditoría de afinidad comparativa
        sort!(activados, by = m -> m[3], rev = true)
        lider = activados[1]
        segundo = activados[2]
        diferencia = round(lider[3] - segundo[3], digits=4)
        
        println("\nDesglose:")
        println("  -> Mayor correspondencia: $(lider[1]) (z = $(round(lider[3], digits=4)))")
        println("  -> Segundo más cercano:   $(segundo[1]) (z = $(round(segundo[3], digits=4)))")
        println("  -> Margen de diferencia:  $diferencia")
        println("\nConclusión: Se rechaza la decisión automática por conflicto,")
        println("pero el que más se acerca segun z corresponde a $(lider[1]).")
    end
    println("==================================================================")
else
    println("\nEntrada rechazada:")
    println(matriz_entrada)
end
#Fin salida