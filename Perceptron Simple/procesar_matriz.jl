
# --- FUNCIÓN AUXILIAR PRIVADA ---
# Convierte 7 líneas de texto en un vector unidimensional de 49 enteros
function lineas_a_vector(lineas::Vector{String})
    filas = [map(x -> parse(Int, x), split(linea)) for linea in lineas]
    return reduce(vcat, filas)
end

# --- 1. PROCESAR MATRIZ ENTRADA (EVALUACIÓN / PROFESOR) ---
# Diseñada para el archivo de prueba: valida exhaustivamente la existencia,
# dimensiones (7x7) y que los valores sean binarios (0 o 1).
function procesar_matriz_entrada(filepath::String)
    # Comprobar si existe el archivo
    if !isfile(filepath)
        return (false, "Error: El archivo '$filepath' no existe en la carpeta indicada.")
    end

    # Leer y filtrar líneas vacías
    lineas = filepath |> readlines |> x -> filter(l -> !isempty(strip(l)), x)

    # Validar exactamente 7 filas
    if length(lineas) != 7
        return (false, "Error de dimensión: La matriz debe tener exactamente 7 filas.")
    end

    # Parsear a listas de enteros
    matriz_listas = map(lineas) do linea
        linea |> split |> x -> map(val -> parse(Int, val), x)
    end

    # Validar exactamente 7 columnas por fila
    if !all(fila -> length(fila) == 7, matriz_listas)
        return (false, "Error de dimensión: Una o más filas no contienen exactamente 7 columnas.")
    end

    # Validar que los valores sean únicamente 0 o 1
    if !all(fila -> all(val -> val ∈ (0, 1), fila), matriz_listas)
        return (false, "Error de formato: La matriz contiene elementos distintos a 0 y 1.")
    end

    # Si todo es correcto, vectorizar (retorna tupla con éxito y el vector de 49 elementos)
    vector_49 = reduce(vcat, matriz_listas)
    return (true, vector_49)
end

# --- 2. PROCESAR MATRIZ PATRÓN (ENTRENAMIENTO / TUS DATOS) ---
# Diseñada para tu archivo de entrenamiento: extrae sin validaciones pesadas
# múltiples matrices separadas por líneas vacías y retorna un vector de vectores.
function procesar_matriz_patron(filepath::String)
    lineas = readlines(filepath)
    patrones = Vector{Vector{Int}}()
    buffer_lineas = String[]

    for linea in lineas
        linea_limpia = strip(linea)
        
        if isempty(linea_limpia)
            if !isempty(buffer_lineas)
                push!(patrones, lineas_a_vector(buffer_lineas))
                empty!(buffer_lineas)
            end
        else
            push!(buffer_lineas, linea_limpia)
        end
    end

    # Procesar la última matriz en caso de que no termine en línea vacía
    if !isempty(buffer_lineas)
        push!(patrones, lineas_a_vector(buffer_lineas))
    end

    return patrones
end