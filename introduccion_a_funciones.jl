### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 98dde660-39a3-11eb-36ae-1f540bcd1f6e
begin
	using Plots
	using PlutoUI
	plotly()
end

# ╔═╡ bc86db48-39a1-11eb-3702-5fec3865f699
md"
# Introducción a Funciones

## ¿Qué es una Función?

Podemos pensar a una función como una simple máquina a la que se le ingresa un valor y te devuelve otro valor. Para esto, la máquina cumple dos requerimientos mínimos: 

- Siempre que la máquina entienda lo que le doy, nos da un resultado. A esto lo llamamos \"existencia\".
- Siempre que le pase una entrada, la salida será la misma. A esto lo llamamos \"unicidad\". Esto significa que la \"salida\" está \"determinada\" por la entrada.

Imaginemos una máquina que cuenta la cantidad de letras que tiene una palabra en lenguaje español. Cuando le ingresamos la palabra \"Elefante\" nos devuelve un 8, si le ingreso \"Remo\" nos devuelve un 4.

Vamos a probar esto en Julia:
"

# ╔═╡ b75d7b04-39a9-11eb-3958-f9e9b67f76c6
contador_de_letras(palabra) = length(palabra);

# ╔═╡ 75278720-39a9-11eb-29e0-3d25c917c1a5
contador_de_letras("Elefante")

# ╔═╡ ab0792a4-39a9-11eb-29d6-e1c48c4f5357
contador_de_letras("Remo")

# ╔═╡ 07eb7bb4-39a2-11eb-3966-7fb63826c807
md"
¿Cumple esta máquina con las dos condiciones que le pusimos para que la podamos pensar como función? 

- Primero vemos que cualquier palabra va a tener una cantidad de letras, así que el resultado existe. 
- En cuanto a la unicidad... \"Elefante\" no puede tener 8 y 9 letras, tiene 8. Siempre que ingrese esa palabra, me va a devolver lo mismo, (siempre tiene 8 letras).

Por lo tanto nuestra máquina de contar letras **es un función**.
"

# ╔═╡ 1d1e7cb6-39a2-11eb-1441-57d8e1e5f1c2
md"
Como contraejemplo, imaginemos una máquina a la cual le damos un libro y nos devuelve un párrafo al azar contenido en ese libro. Esta máquina ¿es una función?

- Respecto a la existencia, todo libro tendrá un párrafo que devolvernos. Siempre habrá un resultado.
- Respecto a la unicidad del resultado, no se cumple ya que la elección es al azar. Si a nuestra máquina le damos un mismo libro dos veces, podríamos tener como resultado dos frases distintas.

Nuestra máquina de selección de frases, entonces, **no** es una función.
"

# ╔═╡ 24564a0e-39a2-11eb-03d0-f96c52fbcddd
md"
![ejemplo no-función](https://github.com/FIUBA-CBC/analisis/img/funciones_basicas_1.jpg)
"

# ╔═╡ 4d98e5e8-39a2-11eb-2521-21cbf3403029
md"
## Entrada y Salida - Dominio e Imagen

Volviendo al ejemplo del contador de letras... ¿Qué pasa ahora si en vez de una palabra en español intentamos ingresar otra cosa? Por ejemplo si a nuestra máquina le ingresamos \"こんにちは\", ¿Qué nos devuelve? La realidad es que no devuelve nada, porque no está preparada para entender Hiragana. A todo el conjunto de elementos que sí acepta (las palabras en lenguaje español), lo vamos a llamar **dominio**.

Y también es interesante ver qué cosas nos puede devolver nuestra maquina/función. En nuestro ejemplo siempre nos va a devolver números (números enteros positivos si somos mas específicos). Al conjunto de elementos que me puede devolver mi función lo llamamos **imagen**.

Resumiendo, nuestra máquina contadora de letras tiene como dominio todas las palabras que existen y para conocer la imagen, tenemos que ingresar todos estos elementos del dominio y ver el conjunto de valores que nos devuelve. En este caso van a ser los números naturales del 1 a n, donde n es la cantidad de letras de la palabra mas larga que existe. Según la RAE, en el español esta palabra es _electroencefalografista_, con lo cual la imagen son los enteros entre 1 y 23 (inclusive). Para otros idiomas, la imagen podría ser más amplia...
"

# ╔═╡ 5ce13672-39a2-11eb-3943-adbc2ea4df34
md"
Por ejemplo, para este pueblo en Gales que ostenta el nombre más largo del mundo: 

![cartel del pueblo galés con el nombre más largo](https://upload.wikimedia.org/wikipedia/commons/e/e8/Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch_station_sign_%28cropped_version_1%29.jpg)
"

# ╔═╡ 639b9534-39a2-11eb-1105-9959261a360e
md"
También podemos pensar a una función como una tabla que relaciona dos valores, por ejemplo la lista de precios de una verdulería:

| Producto | Precio [\$/kg]  |
|-----|------|
| Banana  | 50   |
| Manzana  | 35   |
| Durazno   | 67    |
| Pera   | 35    |
| Ananá   | 40    |

En este caso, si yo quiero saber el valor de una fruta que se encuentra en la tabla, el valor de entrada es la fruta que busco, el valor de saluda es el precio y la función es la relación que asocia ambos valores.

¿Cumple con las condiciones que establecimos?
- Toda fruta tiene un precio asociado, o sea que el resultado existe.
- Para cada fruta el precio es uno solo, por lo cual el valor de salida es único.

En este caso particular, el dominio es el conjunto {Banana, Manzana, Durazno, Pera, Ananá} y la imagen son los números {35, 40, 50, 67}.

¿Puede pasar que dos valores diferentes de entrada me den un mismo valor de salida? Mis condiciones no lo impiden, solamente impiden que un valor de entrada tenga dos valores de salida. Pero dos entradas diferentes (por ejemplo, \"Manzana\" y \"Pera\") pueden tener un mismo valor de salida (en este caso, \"35\").
"

# ╔═╡ c5c72e6c-39a2-11eb-28f2-1bc72645c20c
md"
## Funciones Numéricas
Ahora nos vamos a concentrar en funciones que toman como valor de entrada un  número y nos devuelven otro. Además, a diferencia del ejemplo de la verdulería, donde no hay una relación clara entre los valores de entrada y los de salida, vamos a estudiar relaciones que van a estar dadas por fórmulas.

Pensemos en el siguiente ejemplo: una función que tome números y me devuelva el doble del valor ingresado. Le vamos a poner nombre a esta función, pero como no somos muy creativos la vamos a llamar $f$. Podemos entonces escribirla como:

$f(x) = y$

Donde llamamos $x$ a los valores de entrada, e $y$ a los de salida. 

Como nuestra función nos devuelve el doble del número que ingresamos, la definimos como:

$f(x) = y = 2 \cdot x$
"

# ╔═╡ b03534aa-39a6-11eb-3e3b-056e1dce25f7
md"
Podemos usar esta notación para definir una función en el lenguaje Julia:
"

# ╔═╡ f3929bf6-39a2-11eb-0579-e523f774ab20
y(x) = 2x;

# ╔═╡ e00eed60-39a6-11eb-026b-e3034bb33326
md"
Ahora que creamos nuestra función $y$ en la celda de arriba, apliquemos esta función a varias entradas y veremos que nos devuelve siempre el doble.
"

# ╔═╡ 7419201a-39a6-11eb-3f8d-1d64ed0dd3c6
y(2)

# ╔═╡ 771eff84-39a6-11eb-0da0-991cf8d801cb
y(5)

# ╔═╡ 7a74486a-39a6-11eb-1751-03a59c43534a
y(3.14)

# ╔═╡ ff108920-39a2-11eb-31c8-c1da25a851f4
md"
Ahora podemos pensar cuál va a ser el dominio de esta función, es decir, todos los valores de entrada posibles. Para esto tenemos que fijarnos si hay alguna restricción. Todos los números reales pueden ser multiplicados por dos, por lo tanto, el dominio de esta función son todos los números reales. Para conocer la imagen, tenemos que definir el conjunto de todas las cosas que nos puede devolver cuando le aplicamos la función a todo su dominio. Vamos a volver a ver esto más adelante.

Una manera de visualizar la relación entre el dominio y la imagen es armar una tabla de entradas y salidas. Vamos a hacer una tabla chica, eligiendo algunos valores de $x$ y aplicando la fórmula de la función. Lo haremos para 5 valores:
"


# ╔═╡ 1f2cef24-39a7-11eb-1013-4fea26fec72b
begin
	valores_de_x_para_la_tabla = [-2, -1, 0, 1, 2]
	y(valores_de_x_para_la_tabla)
end

# ╔═╡ 78d354a0-39a7-11eb-29c3-c95fe549edf3
md"
La tabla resultante de los cálculos entonces es la siguiente:

| $x$ | $y = 2 \cdot x$  |
|-----|------|
| -2  | -4   |
| -1  | -2   |
| 0   | 0    |
| 1   | 1    |
| 2   | 4    |

Esta es una manera de visualizar la función, pero resulta un poco limitada, porque hay muchos otros valores de $x$ donde podríamos aplicar la $y$. Además, nos dice muy poco de qué \"forma\" tiene nuestra función. 
"

# ╔═╡ 28028400-39a3-11eb-1929-9da042af8605
md"
### Gráfica de una función

La manera mas usual de representar una función es con lo que llamamos \"gráfica\" de la función. Para esto vamos a utilizar un par de rectas perpendiculares, una horizontal y otra vertical. 
"

# ╔═╡ 2b1c0e40-39a3-11eb-086a-fd57357fe0b9
begin
	plot([0], seriestype="hline", lab="Eje x",color=:red)
	plot!([0], seriestype="vline", lab="Eje y",color=:blue)
	scatter!([0],[0], lab="Origen", color=:green)
	xlims!(-5, 5)
	ylims!(-5, 5)
end

# ╔═╡ 7a980408-39a1-11eb-2cba-7d91808ef38f
md"
- En la horizontal vamos a representar todos los valores de entrada. La llamaremos \"eje $x$\".
- En la vertical, representaremos los valores de salida. La llamaremos \"eje $y$\".
- En la intersección de ambos ejes ponemos el valor $0$, quedando entonces los valores positivos de $x$ a la derecha, y los negativos a la izquierda; los valores de $y$ positivos hacia arriba y negativos hacia abajo. A esta intersección entre los ejes la llamamos \"origen\".

Para representar nuestra función sobre esta gráfica, basta con tomar cada valor $x$ de la tabla, con su correspondiente $y$ y pondremos un punto en el gráfico para cada par de valores. Por ejemplo, para el par $(x=2, y=4)$ irá un punto.
"


# ╔═╡ bc58643e-39a4-11eb-0b5c-45be59611272
begin
	valores_de_x = collect(-2:2)
	scatter(valores_de_x, y(valores_de_x) , lab="",color=:red, linestyle=:dot)
	plot!([0], seriestype="vline", lab="",color=:black, linestyle=:dot)	
	plot!([0], seriestype="hline", lab="",color=:black, linestyle=:dot)
	xlabel!("Eje x")
	ylabel!("Eje y")
	xlims!(-5, 5)
	ylims!(-5, 5)
end

# ╔═╡ b87f16dc-39a4-11eb-0769-b1df0ed6f46c
md"
Podemos ver los 5 puntos de la tabla dibujados. Para $x = 0$, corresponde $y = 0$. Para $x = 1$, corresponde $y = 2$ y así sucesivamente. Pasar el mouse por arriba del gráfico permite ver esa correspondencia.

En el siguiente gráfico pondremos un slider para cambiar la cantidad de puntos que dibujamos. Veamos qué pasa a medida que agregamos más...
"

# ╔═╡ b5a582e2-39a5-11eb-304b-155d747ba3ae
begin
    vslider=  @bind n Slider(5:1:100; default=5, show_value=true)
    md""" Cantidad de puntos: n $(vslider)"""
end

# ╔═╡ 06eadb16-39a6-11eb-3e6d-f94904175161
begin
    puntos_x = collect(-2.5:5/n:2.5)

    scatter(puntos_x, y(puntos_x), lab="", color=:red)
    plot!([0], seriestype="hline", lab="",color=:black)
    plot!([0], seriestype="vline", lab="",color=:black)
    xlims!(-5,5)
    ylims!(-5,5)
end

# ╔═╡ b0d76046-39a5-11eb-146f-779ffd213ca5
md"
Entonces, a medida que agregamos más, nos damos cuenta de que la representación gráfica es cada vez más parecida a una recta.

Graficando directamente como una recta, lo veremos así:
"

# ╔═╡ 683ac160-39a6-11eb-1038-d9520464f302
begin
	x_recta = collect(-5:0.01:5)
    plot(x_recta, y(x_recta), lab="y(x) = 2x", color=:red)
    plot!([0], seriestype="hline", lab="",color=:black)
    plot!([0], seriestype="vline", lab="",color=:black)
	xlabel!("Eje x")
	ylabel!("Eje y")
    xlims!(-5,5)
    ylims!(-5,5)
end

# ╔═╡ da4cf834-39a8-11eb-35d9-a70e594e792f
md"
Ahora no tenemos un número finito de puntos: tenemos todos valores de $y$ para $x$ entre $-2.5$ y $2.5$. Basta con observar la altura de la recta para un $x$ cualquiera, para obtener su $y$ correspondiente.

Si queremos ver esto en el gráfico, podemos pasar el mouse por arriba de la recta para ver el valor para cada x.
"

# ╔═╡ Cell order:
# ╠═98dde660-39a3-11eb-36ae-1f540bcd1f6e
# ╠═bc86db48-39a1-11eb-3702-5fec3865f699
# ╠═b75d7b04-39a9-11eb-3958-f9e9b67f76c6
# ╠═75278720-39a9-11eb-29e0-3d25c917c1a5
# ╠═ab0792a4-39a9-11eb-29d6-e1c48c4f5357
# ╠═07eb7bb4-39a2-11eb-3966-7fb63826c807
# ╠═1d1e7cb6-39a2-11eb-1441-57d8e1e5f1c2
# ╠═24564a0e-39a2-11eb-03d0-f96c52fbcddd
# ╠═4d98e5e8-39a2-11eb-2521-21cbf3403029
# ╠═5ce13672-39a2-11eb-3943-adbc2ea4df34
# ╠═639b9534-39a2-11eb-1105-9959261a360e
# ╠═c5c72e6c-39a2-11eb-28f2-1bc72645c20c
# ╟─b03534aa-39a6-11eb-3e3b-056e1dce25f7
# ╠═f3929bf6-39a2-11eb-0579-e523f774ab20
# ╠═e00eed60-39a6-11eb-026b-e3034bb33326
# ╠═7419201a-39a6-11eb-3f8d-1d64ed0dd3c6
# ╠═771eff84-39a6-11eb-0da0-991cf8d801cb
# ╠═7a74486a-39a6-11eb-1751-03a59c43534a
# ╠═ff108920-39a2-11eb-31c8-c1da25a851f4
# ╠═1f2cef24-39a7-11eb-1013-4fea26fec72b
# ╟─78d354a0-39a7-11eb-29c3-c95fe549edf3
# ╠═28028400-39a3-11eb-1929-9da042af8605
# ╠═2b1c0e40-39a3-11eb-086a-fd57357fe0b9
# ╟─7a980408-39a1-11eb-2cba-7d91808ef38f
# ╠═bc58643e-39a4-11eb-0b5c-45be59611272
# ╟─b87f16dc-39a4-11eb-0769-b1df0ed6f46c
# ╟─b5a582e2-39a5-11eb-304b-155d747ba3ae
# ╠═06eadb16-39a6-11eb-3e6d-f94904175161
# ╟─b0d76046-39a5-11eb-146f-779ffd213ca5
# ╠═683ac160-39a6-11eb-1038-d9520464f302
# ╠═da4cf834-39a8-11eb-35d9-a70e594e792f
