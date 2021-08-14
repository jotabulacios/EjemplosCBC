### A Pluto.jl notebook ###
# v0.12.17

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

# ╔═╡ a3658046-3725-11eb-1bb6-e981ac1de371
using Plots

# ╔═╡ 80448600-3763-11eb-0426-071d4c5c2581
using PlutoUI

# ╔═╡ b5ea471a-3725-11eb-09de-eb08414cea0c
plotly()

# ╔═╡ a88df786-376d-11eb-30bf-d36644f2462d
md" ## Bienvenides al maravilloso mundo de Análisis Matemático I "

# ╔═╡ 6783a4fc-376d-11eb-32c9-c16376782b06
snake_math = "https://i.imgur.com/nsrOoqp.png"



# ╔═╡ 920d6d1e-376d-11eb-169d-b7ba0fc2f787
Resource(snake_math)

# ╔═╡ b02439b8-3756-11eb-08fc-a1ab31ae4b9e
md"""
### Función lineal 

Cuando decimos que una función  $y$ es una función lineal de $x$, queremos decir que el gráfico de esta es una linea recta, por lo que podemos utilizar la forma pendiente  $m$ - ordenada  al origen $b$ para describir la funcion:
$y = f(x) = m \cdot x + b$

Una de las características de las funciones lineales es que cambian a una tasa constante. Por ejemplo en la siguiente figura se observa el grafico de una funcion lineal $f(x) = 3 x -2$ , se puede ver que a medida que $x$ aumenta en $1$ , el valor de $y$ lo hace en $3$ , entonces $f(x)$ aumenta su valor tres veces mas rapido que $x$. Si hacemos una tabla con los resultados para un $x$ que aumenta de $1$ en $1$ hasta 10 y otra con un $x$ que varia en $3$ vamos a tener lo siguiente


| $x$  | $f(x) = 3  x - 2$|
|----|------------------|
| 0  | -2             |
| 1  | 1             |
| 2  | 4              |
| 3  | 7              |
| 4  | 10              |
| 5  | 13              |
| 6  | 16              |
| 7  | 19              |
| 8  | 22              |
| 9  | 25              |
| 10 | 28               |



| $x$  | $f(x) = 3 x - 2$ |
|----|------------------|
| 0  | -2              |
| 3  | 7              |
| 6  | 16             |
| 9  | 25              |
| 12  | 34              |
| 15  | 43              |



"""

# ╔═╡ a471660e-398b-11eb-0424-35634d66157a
begin
	
	
xx=collect(0:1:10)
ff = (xx,xx.*3 .-2)
xx1=collect(0:3:15)
ff1 = (xx1,xx1.*3 .-2)		
	
end;


# ╔═╡ afcf8e22-3756-11eb-34ea-5376536fb482
begin
f(x) = 3x - 2
scatter(xx,xx.*3 .-2, label= "Tabla 1")
scatter!(xx1,xx1.*3 .-2, label = "Tabla 2")
plot!(xx1,xx1.*3 .-2,label="f(x)", legend=:topleft)
xlims!(-0.1,17)
ylims!(-4,35)
end

# ╔═╡ 0bbab030-37e9-11eb-2d59-750dcc1389ed
md" ### Buenos Aires - Mar del Plata"

# ╔═╡ 669fff32-37e9-11eb-0a8f-b9965e7fc876
md"
Veamos un ejemplo. Buenos Aires está aproximadamente a 400 kilómetros de Mar del Plata. Si vamos a 100km/h llegaremos en 4 horas, mientras que si vamos a 50km/h llegaremos en 8. ¿Cómo podemos escribir esta relación?

Si llamamos v a la velocidad y t el tiempo que llevamos de viaje, podemos ver que el camino recorrido será: \\[ v \cdot t = (100 \frac{km}{h} \cdot 4 h) = 400 km \\]

Vamos a graficar el recorrido para los dos ejemplos de los que charlamos
"


# ╔═╡ 668188c0-37e9-11eb-2b79-21a9ad8c8045
begin 
x1 = collect(0:0.1:12) 
plot(x1,x1.*100,lab="100km/h") 
plot!(x1,x1.*50,lab="50km/h") 
plot!([400], seriestype="hline", lab="Mar del Plata", linestyle=:dot)

ylims!(0,500)
end

# ╔═╡ a54b80a2-37ef-11eb-1561-ff2eb53d96ff
md"Podemos ver que:

- El recorrido se ve como una recta, porque la velocidad es constante: no importa en qué momento $t_0$ del recorrido me pare, sé que en $t_0 + \Delta t$ habré recorrido $v \cdot \Delta t.$

- La velocidad determina qué tan “empinada” es la recta. Por eso, esta constante de la ecuación se llama “pendiente” y es la que relaciona la posición con el tiempo.

En el ejemplo anterior teníamos dos ecuaciones, una por cada recorrido:

$x_{auto \ rapido} = v_1 \cdot t = 100 \frac{km}{h} \cdot t$
$x_{auto \ lento} = v_2 \cdot t = 50 \frac{km}{h} \cdot t$



En el siguiente gráfico podemos observar que si cambiamos la velocidad, la pendiente de la recta cambia"


# ╔═╡ b9f68ee2-37f0-11eb-32b9-f5f8414a003f
begin
	vslider=  @bind v Slider(0:10:200; default=10, show_value=true)
	md""" Velocidad: v $(vslider)"""

end

# ╔═╡ a59a24ae-37f0-11eb-27a7-4168be79ae76
begin 
x2 = collect(0:0.1:13) 
plot(x2,x2.*v,lab="$v km/h") 
xlabel!("Tiempo [h]")
ylabel!("Distancia [km]")
ylims!(0,500)
xlims!(0,12)
end

# ╔═╡ 1c5b9714-37f2-11eb-2aee-c12c5b3378b6
md"
Dada la velocidad de un auto… podemos predecir cuándo llega a Mar del Plata? Podemos!

$$x(t) = v \cdot t$$
$$\text{Distancia a MDQ} = v \cdot \text{Tiempo de viaje}$$
$$400 km = v \cdot \text{Tiempo de viaje}$$
$$\text{Tiempo de viaje} = v / 400km$$
"

# ╔═╡ 1bb527c8-37f2-11eb-392d-91cd73e93975
md"
##### Saliendo desde Chascomús"

# ╔═╡ fc574524-37f5-11eb-332f-e9240245e01c
md"
Pero esto es poco realista. No todos los autos salen de la capital. Comparemos nuestro viaje original con el de un auto que sale de Chascomús, que está a 120 km más cerca de Mar del Plata que Buenos Aires.

¿Cómo cambia la ecuación si agregamos una posición inicial?

$$x(t) = v \cdot t + x_0$$

$$x_0: \text{Posición inicial} (\text{Chascomus})$$ 
Observemos que la posición inicial es una constante, al igual que la velocidad, para un recorrido determinado. Si yo elijo la posición y la velocidad, eso me determina todo el recorrido de la posición del auto en función del tiempo.

Grafiquemos cómo llega un auto que sale de Buenos Aires vs un auto que sale de Chascomús ambos a $100 \frac{km}{h}$, saliendo en $t=0$.
"

# ╔═╡ 01f8039c-37f6-11eb-3cf1-0fb81e04cd85
begin 
x3 = collect(0:0.1:12) 
plot(x3,x3.*100,lab="Salgo CABA",legend=:bottomright) 
plot!(x3,x3.*100 .+120,lab="Salgo Chascomús")
plot!([400], seriestype="hline", lab="Mar del Plata", linestyle=:dot)
plot!([120], seriestype="hline", lab="Chascomús", linestyle=:dot)
xlims!(0,6)
ylims!(0,500)
end

# ╔═╡ 01d9c8c8-37f6-11eb-2d49-f7767d7422d1
md"Refleccionemos un poco sobre este gráfico. ¿Cómo se relacionan entre sí ambas rectas?

- Ambas rectas tienen la misma pendiente, porque tienen la misma velocidad.
- Una está “más arriba” que la otra. ¿Qué tanto más arriba? Recordemos que el eje vertical es la posición. Si lo pensamos, el auto que sale de Buenos Aires sale del $km=0$, mientras que el otro sale del $km=120$. Esto significa que una recta estará exactamente $120km$ arriba de la otra en todos sus puntos.
Esto último lo podemos ver justamente en las ecuaciones:

$x_{auto\ desde \ BsAs}(t) = 100 \frac{km}{h} \cdot t$
$x_{auto\ desde \ Chascomus}(t) = 100 \frac{km}{h} \cdot t + 120 km$

O sea:

$x_{auto\ desde \ BsAs}(t)  + 120km = x_{auto\ desde \ Chascomus}(t)$

¡Esto es interesante! Esta última ecuación nos dice que independientemente de cómo esté hecha una función, podemos armar otra sumándole un número y que eso nos dará otra función, pero más arriba en el gráfico. 

Vamos a generalizar esto. En el siguiente gráfico incluimos un slider para empezar desde distintos lugares. Pueden moverlo para ver cómo sería salir desde más cerca o más lejos de la capital.
"


# ╔═╡ e340bc70-380e-11eb-2ea0-7d318e0b3b4f
begin
	xinicslider=  @bind xinic Slider(0:10:200; default=120, show_value=true)
	md""" Salgo :  $(xinicslider) kilometros más adelante"""

end

# ╔═╡ e9b6d660-380d-11eb-168f-15b5a4da6e25
begin 
x4 = collect(0:0.1:8) 
plot(x4,x4.*100,lab="Salgo CABA", legend=:bottomright) 
plot!(x4,x4.*100 .+xinic,lab="Salgo $xinic Km más adelante") 
plot!([400], seriestype="hline", lab="Mar del Plata", linestyle=:dot)
plot!([120], seriestype="hline", lab="Chascomús", linestyle=:dot)
xlims!(0,6)
ylims!(0,600)
end

# ╔═╡ 9f37e412-3817-11eb-3013-edf105cc933a
md"

Aquí confirmamos esto que decíamos antes. 

¿Y si quisiéramos ahora predecir en qué tiempo voy a llegar a Mar del Plata? Ahora además de la velocidad, también tenemos que tener en cuenta la posición inicial. Vamos a hacer el mismo procedimiento que antes: escribimos la ecuación de posición en función del tiempo y luego despejamos el tiempo para la posición que queremos.

$x_{auto}(t) = v \cdot t + x_0$

Reemplazamos con nuestros datos y despejamos:

$\text{Distancia a MDQ} = v \cdot \text{Tiempo hasta MDQ} + \text{Distancia hasta Chascomús}$

$\frac{\text{Distancia a MDQ} - \text{Distancia hasta Chascomus}}{v} = \text{Tiempo hasta MDQ}$

Acá lo que vimos es que el tiempo que nos tardó en llegar de Chascomús a Mar del Plata es la distancia recorrida (la resta de la izquierda, $x_{final} - x_0$) sobre la velocidad. En el ejemplo de Buenos Aires, la posición inicial era siempre $0$, entonces esta resta quedaba directamente la $x_{final}$.
"

# ╔═╡ 6310dea6-3819-11eb-1466-977f16bc1521
md" #### Saliendo mas tarde "


# ╔═╡ 6fc7d4ba-3819-11eb-3c75-43f0a52000da
md" Pero ahora estamos saliendo en $t=0$. Las 12 de la noche podría ser un horario incómodo. Imaginemos que queremos salir a las 6 am para llegar a las 10 am, o sea saldremos en $t = 6$… ¿Cómo podemos expresar esto en nuestras ecuaciones?

Antes cuando salíamos desde Chascomús, teníamos que la recta se desplazaba verticalmente en esa diferencia de distancia, ya que el eje vertical era la posición. Ahora lo que nos gustaría que la recta se “mueva” en el eje horizontal, que es el tiempo, para expresar que salimos más tarde.

El truquito en este caso es que antes sumábamos “afuera” la posición inicial, ya que sumábamos posición con posición. Si ahora que queremos sumar 6 horas al tiempo tenemos que hacerlo al tiempo directamente. Antintuitivamente, para que la recta se desplace a la derecha, tenemos que restar en lugar de sumar. En un ratito veremos por qué.

$x_{saliendo\ 6am}(t) = x_{saliendo\ 12am}(t - 6h)$
$x_{saliendo\ 6am}(t) = 100 \frac{km}{h} \cdot (t - 6h)$
$x_{saliendo\ 6am}(t) = 100 \frac{km}{h} \cdot t - 600km$

Vamos a graficarlo.
"

# ╔═╡ 8766aeb8-3819-11eb-0842-2169cb334dff
begin 
x5 = collect(0:0.1:20) 
plot(x5,x5.*100,lab="Salgo a las 12 am", legend=:bottomright) 
plot!(x5,x5.*100 .-600,lab="Salgo a las 6am") 
plot!([400], seriestype="hline", lab="Mar del Plata", linestyle=:dot)
plot!([120], seriestype="hline", lab="Chascomús", linestyle=:dot)
xlims!(0,12)
ylims!(0,600)
end

# ╔═╡ 38b55daa-381a-11eb-23e6-e1fca6acd232
md" 

Lo interesante es que efectivamente nuestra recta está \"más a la derecha\".

Fijémosnos que la ecuación nos dio igual que la de antes, pero como si hubéramos empezado en $-600km$!! Esto si bien no es lo que escribimos, es equivalente. Es decir, salir $6$ horas más tarde es lo mismo que salir $600 km$ más lejos. Por ejemplo, esto saría salir desde Rio Cuarto (Córdoba), viajar hasta Buenos Aires y luego hasta Mar del Plata.

Es más, pongamos a prueba esto último. Extendamos la recta del auto que sale a las 6am hasta las 12am. ¿A dónde habría estado el auto?

"

# ╔═╡ f98ab398-38c8-11eb-23e0-e7d53a94191f
begin 
x6 = collect(0:0.1:20) 
plot(x6,x6.*100,lab="Salgo a las 12 am", legend=:bottomright) 
plot!(x6,x6.*100 .-600,lab="Salgo a las 6am") 
plot!([400], seriestype="hline", lab="Mar del Plata", linestyle=:dot)
plot!([0], seriestype="hline", lab="Capital Federal", linestyle=:dot)
plot!([-600], seriestype="hline", lab="Rio Cuarto (-600km)", linestyle=:dot)
xlims!(0,12)
ylims!(-650,600)
end

# ╔═╡ 333bde28-38c9-11eb-1c13-43497cd11386
md"
Comprobamos entonces lo que sospechábamos: si salimos a las 6 am desde capital, es lo mismo que salir a las 12am, $600km$ más atrás, desde Rio Cuarto, si vamos a $100\frac{km}{h}$.
"

# ╔═╡ d7194f12-381a-11eb-3cca-fbd7dc8882ad
md"
###### Generalizando 

Dejando de pensar un segundo en velocidades y posiciones, las funciones lineales pueden pensarse con la ecuación 

$y = f(x) = m x + b$

donde:

-  $x$ es la variable “de entrada”.
-  $y$ “la de salida”
-  $m$ es la pendiente.
-  $b$ es el valor inicial.

En nuestro ejemplo teníamos:

-  $x$ era el tiempo $t$.
-  $y$ era la posición en función del tiempo, $x(t)$.
-  $m$ era la velocidad $v$.
-  $b$ era la posición inicial $x_0$.


Luego vimos cómo calcular la entrada $x$ conociendo una salida $y$ (\"cuánto tiempo tardamos en llegar a mar del plata\"). A esto lo llamamos la _inversa_ de la función. Para funciones lineales, calcular la inversa es tan sencillo como “despejar” $x$. Más adelante, cuando veamos otras funciones, el cálculo se hará más complicado.

$y(x) = m \cdot x + b$
$x(y) = \frac{(y - b)}{m} = \frac{y}{m} - \frac{b}{m}$

Algo a remarcar, es que la función inversa de una lineal es otra lineal donde $y$ es la variable de entrada. Si lo presentamos como $x(y) = m’y + b’$... ¿Cuáles son nuestras nuevas pendientes y valores iniciales? Basta ver la ecuación anterior:

$m’ = \frac{1}{m}$

$b’ = -\frac{b}{m}$

Esto tiene sentido. Cuanto mayor haya sido la pendiente, menor será la de la inversa. Si nuestra velocidad a Mar del Plata era muy alta, el tiempo que nos tardará recorrer una distancia será más chico.

"

# ╔═╡ d691d366-381a-11eb-2204-6363ae55ff34
md"
Hagamos un ejemplo. Tenemos la función lineal $y(x) = mx - 5$. Si despejamos $x$ llegamos a $x(y) = \frac{y}{m} + \frac{5}{m}$. Grafiquemos estas funciones y variemos la pendiente m.
"

# ╔═╡ 85c0c7cc-38fa-11eb-0f1f-654ee2eb8909
begin
	m_slider=  @bind m1 Slider(-3:0.1:3; default=3, show_value=true)
	md"""Pendiente de la función lineal: $(m_slider)"""
end

# ╔═╡ 9420c8d4-38f8-11eb-2204-77a06514b0c0
begin
	x7 = collect(0:5)
	b2 = 1
	binv = b2/m1
	p1 = plot(x7, x -> m1*x - b2, label="", colour=:red)
	xlabel!("x")
	ylabel!("y")
	title!("$m1 x - $b2")

	p2 = plot(x7, x -> x/m1 + binv, label="", colour=:blue)
	xlabel!("y")
	ylabel!("x")
	title!("y/$m1 + $(round(binv, digits=2))")

	plot(p1, p2, layout=(1,2))
	ylims!(-10,10)
end

# ╔═╡ 5fdedfea-38fe-11eb-154b-b1571a457c74
md"
Podemos ver que en los valores de m más altos el gráfico de la inversa tiene una pendiente pequeña, mientras que en los valores más cercanos al 0, la inversa tiene una pendiente alta y además su desplazamiento se hace mayor.
"

# ╔═╡ af631940-3756-11eb-0744-59341550b719
md"### Ejemplo 2

A medida que aire seco sube, se expande y enfria. Si la temperatura en el nivel del suelo es de $20°C$ y la temperatura a $1km$ es de $10°C$, ¿Cúal será la temperatura (en $°C$) en funcion de la altura $h$ (en kilometros)? 
Asumir que un modelo lineal es apropiado.

------

Como asumimos un modelo lineal podemos asumir que la temperatura viene dada por la ecuacion $T(h) = m \cdot h + b$ . Como sabemos que la temperatura al nivel del suelo es de 20°C podemos escribir $20= m \cdot 0 + b$, de donde obtenemos que $b = 20$, es decir que $20$ es la ordenada al origen.
Además sabemos que a $1km$ la temperatura es de $10°C$ , que en terminos de la ecuacion implica $10 = m \cdot 1 + 20$, por lo que la pendiente resulta $m = 10 -20 = -1$
Finalmente podemos escribir que $T=-10\cdot h +20$ es laa funcion que describe la temperatura del aire en funcion de la altura

Graficando tenemos
"

# ╔═╡ ea967346-37e8-11eb-3708-f7f5c68e008c
begin 
h11 = collect(0:0.1:7)
plot(h11,h11.*-10 .+20,lab="T=-10h+20")
xlims!(0,5)
ylims!(-30,30)
xlabel!("Altura [km]")
ylabel!("Tempeatura [°C]")
title!("Temperatura del aire")

	
end

# ╔═╡ afb7ef92-3756-11eb-0db6-6f726d587a4e
md" #### Acá vas a poder ver como se modifica una funcion lineal al cambiarle los parametros"
#Crea tu propia función lineal!

# ╔═╡ 69df30e4-3999-11eb-3783-598673b8874c
md"
Deslizá para modificar la pendiente y el termino independiente y ver como cambia una funcion genérica

$y = f(x) = m x + b$


"

# ╔═╡ af9a0036-3756-11eb-1581-f7f90b2744a4
begin
	mslider=  @bind m Slider(-10:1:10; default=1, show_value=true)
	bslider = @bind b Slider(-10:0.5:10; default=0, show_value=true)
	md"""
	
	Pendiente: $m$ $(mslider)
	
	Termino independiente: $b$ $(bslider)"""
end

# ╔═╡ af7c90d2-3756-11eb-1e04-d7f1dbd0fa45
begin
#x = collect(-10:0.1:10) 

f2(x) =m*x+b
plot(f2,color=:blue)
xlims!(-3,3)
ylims!(-10,10)
xlabel!("x")
ylabel!("y")
plot!([0], seriestype="hline", lab="",color=:black, linestyle=:dot)
plot!([0], seriestype="vline", lab="",color=:black, linestyle=:dot)
title!(" m: $m  b: $b")

	
end

# ╔═╡ efbac940-3768-11eb-31ed-55e1dc275376
md" ### Funcion cuadrática"

# ╔═╡ b684a1ec-399c-11eb-1c84-e9ebef72563b
md"
Las funciones cuadráticas son de la forma

$f(x) = ax² + bx + c$

con $a,b,c, ∈ \mathbb{R}$ fijos y $a\neq0$


" 


# ╔═╡ aea292ce-3756-11eb-1dfd-1fd920be6ecf
md"

#### Un ejemplo de funcion cuadrática 

Se lanza una pelota desde arriba de una torre muy alta la cual se encuentra a `450m` de altura y la altura de la misma `h` es sensada en intervalos de `1 segundo` (Es decir, cada 1 segundo, \"mido\" donde está la pelota, y lo anoro en la tabla) . Como resultado observan los datos representados en la siguiente tabla

| Tiempo | Metros |
|--------|--------|
| 0      | 450    |
| 1      | 445    |
| 2      | 431    |
| 3      | 408    |
| 4      | 375    |
| 5      | 332    |
| 6      | 279    |
| 7      | 216    |
| 8      | 143    |
| 9      | 61     |

Vamos a tratar de encontrar el mejor modelo para tratar de precedir el tiempo en el cual la pelota tocara el suelo
"

# ╔═╡ ae87bde6-3756-11eb-121a-211c9e728dae
md" 
Primero vamos a graficar los puntos obtenidos"

# ╔═╡ ae6c0470-3756-11eb-3293-37e5e5b7c425
begin
	t=collect(0:1:9)
	h0=[450,445,431,408,375,332,279,216,143,61]
	scatter(t,h0,label="Altura")
	plot!(t,h0,label="curva interpolada")

end

# ╔═╡ ae51af80-3756-11eb-082d-89b9a6c434e1
md"
Se puede inferir que tiene forma de media parábola. Utilizando la técnica de [`cuadrados mínimos`](https://es.wikipedia.org/wiki/M%C3%ADnimos_cuadrados) (no te preocupes esto lo vas a ver más adelante, por ahora solo nos interesa lo que nos devuelve) podemos obtener la siguiente forma cuadratica del modelo 
`h = 449,36 + 0.96 t -4.90t²`
Si queremos encontrar cuando la pelota toca el piso debemos imponer que `h=0=-4.90t²+0.96t+449,39`. Utizando la formula cuadratica $-b \pm \sqrt{b^2 - 4ac} \over 2a$ vamos a obtener que el tiempo aproximado, es decir la raiz es `t~9.96`
"

# ╔═╡ 4f55c706-3822-11eb-0f7e-4d682f126069


# ╔═╡ Cell order:
# ╠═a3658046-3725-11eb-1bb6-e981ac1de371
# ╠═80448600-3763-11eb-0426-071d4c5c2581
# ╠═b5ea471a-3725-11eb-09de-eb08414cea0c
# ╠═a88df786-376d-11eb-30bf-d36644f2462d
# ╟─6783a4fc-376d-11eb-32c9-c16376782b06
# ╟─920d6d1e-376d-11eb-169d-b7ba0fc2f787
# ╟─b02439b8-3756-11eb-08fc-a1ab31ae4b9e
# ╟─a471660e-398b-11eb-0424-35634d66157a
# ╠═afcf8e22-3756-11eb-34ea-5376536fb482
# ╟─0bbab030-37e9-11eb-2d59-750dcc1389ed
# ╟─669fff32-37e9-11eb-0a8f-b9965e7fc876
# ╠═668188c0-37e9-11eb-2b79-21a9ad8c8045
# ╟─a54b80a2-37ef-11eb-1561-ff2eb53d96ff
# ╟─b9f68ee2-37f0-11eb-32b9-f5f8414a003f
# ╠═a59a24ae-37f0-11eb-27a7-4168be79ae76
# ╟─1c5b9714-37f2-11eb-2aee-c12c5b3378b6
# ╟─1bb527c8-37f2-11eb-392d-91cd73e93975
# ╟─fc574524-37f5-11eb-332f-e9240245e01c
# ╠═01f8039c-37f6-11eb-3cf1-0fb81e04cd85
# ╟─01d9c8c8-37f6-11eb-2d49-f7767d7422d1
# ╟─e340bc70-380e-11eb-2ea0-7d318e0b3b4f
# ╠═e9b6d660-380d-11eb-168f-15b5a4da6e25
# ╟─9f37e412-3817-11eb-3013-edf105cc933a
# ╟─6310dea6-3819-11eb-1466-977f16bc1521
# ╟─6fc7d4ba-3819-11eb-3c75-43f0a52000da
# ╠═8766aeb8-3819-11eb-0842-2169cb334dff
# ╟─38b55daa-381a-11eb-23e6-e1fca6acd232
# ╠═f98ab398-38c8-11eb-23e0-e7d53a94191f
# ╟─333bde28-38c9-11eb-1c13-43497cd11386
# ╟─d7194f12-381a-11eb-3cca-fbd7dc8882ad
# ╟─d691d366-381a-11eb-2204-6363ae55ff34
# ╟─85c0c7cc-38fa-11eb-0f1f-654ee2eb8909
# ╠═9420c8d4-38f8-11eb-2204-77a06514b0c0
# ╟─5fdedfea-38fe-11eb-154b-b1571a457c74
# ╟─af631940-3756-11eb-0744-59341550b719
# ╠═ea967346-37e8-11eb-3708-f7f5c68e008c
# ╟─afb7ef92-3756-11eb-0db6-6f726d587a4e
# ╟─69df30e4-3999-11eb-3783-598673b8874c
# ╟─af9a0036-3756-11eb-1581-f7f90b2744a4
# ╠═af7c90d2-3756-11eb-1e04-d7f1dbd0fa45
# ╟─efbac940-3768-11eb-31ed-55e1dc275376
# ╟─b684a1ec-399c-11eb-1c84-e9ebef72563b
# ╟─aea292ce-3756-11eb-1dfd-1fd920be6ecf
# ╟─ae87bde6-3756-11eb-121a-211c9e728dae
# ╠═ae6c0470-3756-11eb-3293-37e5e5b7c425
# ╟─ae51af80-3756-11eb-082d-89b9a6c434e1
# ╠═4f55c706-3822-11eb-0f7e-4d682f126069
