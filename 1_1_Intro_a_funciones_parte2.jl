### A Pluto.jl notebook ###
# v0.12.19

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

# ╔═╡ a76f4600-55d3-11eb-0f6c-1d60f6cae0ed
using Plots

# ╔═╡ 2e2ba646-5c34-11eb-1250-f7cd9e2b5764
using PlutoUI

# ╔═╡ 9e03a302-5da5-11eb-3ef3-bba22ba018fc
begin
	using Pkg   
	Pkg.add.(["CSV", "DataFrames", "PlutoUI", "Shapefile", "ZipFile", "LsqFit", "Plots"])

	using CSV
	using DataFrames
	using Shapefile
	using ZipFile
	using LsqFit
	using Dates
	url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv";
	
	download(url, "covid_data.csv");
	csv_data = CSV.File("covid_data.csv");   
	data = DataFrame(csv_data)   # it is common to use `df` as a variable name
		data_2 = rename(data, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude");   
	rename!(data, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude") ;
	all_countries = data[:, "country"];
	ARG_row = findfirst(==("Argentina"), all_countries);
	data[ARG_row, :];
	data[ARG_row:ARG_row, :];
	ARG_data = Vector(data[ARG_row, 5:end]);
	column_names = names(data);
	date_strings = names(data)[5:end];
	date_format = Dates.DateFormat("m/d/Y");
	dates = parse.(Date, date_strings, date_format) .+ Year(2000);

	
	
end

# ╔═╡ 77915aec-5da6-11eb-33b1-819e3ec8580d
begin
	using Statistics
	daily_cases = diff(ARG_data)
	running_mean = [mean(daily_cases[i-6:i]) for i in 7:length(daily_cases)]
	#plot(daily_cases, label="Casos diarios")
	plot(running_mean, m=:o, label="Promedio semanal", leg=:topleft)
end

# ╔═╡ 0e5215f8-5c34-11eb-399a-0f45b885c428
plotly()

# ╔═╡ 80e98170-55cf-11eb-1728-0b9be9ede10c
md"""
# Funciones Básicas
"""

# ╔═╡ 2e4c413e-55d0-11eb-0743-87da04abc000
md"""
## Función Cuadrática y Función Cúbica

Una de las formas más simples de entender el uso de estas funciones es observando relaciones geométricas. Por ejemplo: la relación que hay entre el radio de una circunferencia o el lado de una cuadrado con sus respectivas áreas serían funciones cuadráticas. Y luego, para el caso de la relación entre el radio de una esfera o los lados de un cubo con respecto a sus volúmenes la función sería cúbica.



#### Y cómo escribimos dichas funciones de forma matemática?


###### Cuadráticas

Área de una circunferencia en función de su radio $r$:

$$Area = π\cdot r^{2}$$


Área de un cuadrado en función sus lados $l$:

$$Area = l^{2}$$



###### Cúbicas

Volumen de una esfera en función de su radio $r$:

$$Vol = π\cdot r^{3}$$


Volumen de un cubo en función sus lados $l$:

$$Vol = l^{3}$$



"""

# ╔═╡ 629dc678-5c36-11eb-205b-3f69bd55edcf
md"""
Ahora veamos cómo varia el área de una circunferencia si modificamos el radio de la misma
Antes de graficar pernsemos un poco. ¿Cuál será el dominio? Sabemos que el radio de una circunsferencia no puede ser negativo (lo cual es totalmente lógico) 
Entonces el dominio será $\mathbb{R}^+$,es decir los numeros reales positivos


"""

# ╔═╡ 26a66ba2-5c36-11eb-2d6b-85be51d9486d
begin
	x1 = collect(0:0.1:3) #x1 es el radio
	f(x1) = π * x1.^2 # Area es  π r²
	y1=f.(x1)
	plot(x1,y1,label="Área",legend=:bottomright)
	xlims!(0,3)
	ylims!(0,30)
	xlabel!("Radio")
	ylabel!("Área")
	title!("Área de una circunsferencia en función del radio")
	 
end

# ╔═╡ d9f5bfb0-55cd-11eb-1b0b-af39e7ae9d07
md""" #### Otro ejemplo de función cuadrática 

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

Vamos a tratar de encontrar el mejor modelo para tratar de precedir el tiempo en el cual la pelota tocará el suelo
"""

# ╔═╡ 75a25b96-5c34-11eb-2260-23d7d48e67ac
begin
	t=collect(0:1:9)
	h0=[450,445,431,408,375,332,279,216,143,61]
	scatter(t,h0,label="Altura")
	plot!(t,h0,label="curva interpolada")
end

# ╔═╡ ed9dc666-5c35-11eb-2abb-b332fea3eb30
md"
Se puede inferir que tiene forma de media parábola. Utilizando la técnica de [`cuadrados mínimos`](https://es.wikipedia.org/wiki/M%C3%ADnimos_cuadrados) (no te preocupes esto lo vas a ver más adelante, por ahora solo nos interesa lo que nos devuelve) podemos obtener la siguiente forma cuadrática del modelo 
$h = 449,36 + 0.96 t - 4.90t²$
"

# ╔═╡ f7397ce2-5c35-11eb-0222-694f145baad3
md"
Las funciones cuadráticas son de la forma
$y = f(x) = ax² + bx + c$
con $a,b,c, ∈ \mathbb{R}$ fijos y $a\neq0$

Si te interesa ver cómo varía un gráfico según cómo varían las constantes $a$, $b$ y $c$, _here you go..._
" 

# ╔═╡ 2be1c936-5cae-11eb-0511-55cac515b4de
begin
	a1_slider=  @bind a1 Slider(-10:1:10; default=1, show_value=true)
	md"""a: $(a1_slider)"""
end

# ╔═╡ 562d2078-5cae-11eb-2934-974dbccdab74
begin
	b1_slider=  @bind b1 Slider(-10:1:10; default=0, show_value=true)
	md"""b: $(b1_slider)"""
end

# ╔═╡ 5cb5ba8e-5cae-11eb-19bf-ebf44ea8f6a6
begin
	c1_slider=  @bind c1 Slider(-1000:1:1000; default=0, show_value=true)
	md"""c: $(c1_slider)"""
end

# ╔═╡ 8e6333ec-5cae-11eb-26c6-f3b094dab970
begin
	xc = collect(-20:20)
	pc = plot(xc, xc -> a1*xc^2 + b1*xc + c1, label="", colour=:red)
	xlabel!("Eje x")
	ylabel!("Eje y")
	title!("$a1 * x^2 + $b1 * x + $c1")
	plot(pc)
	xlims!(-20,20.1)
	ylims!(-100,100)
end

# ╔═╡ 08513d6e-5cf9-11eb-10fb-29fd8cd2dd68
md"""

Si te fijás, esa función tiene el formato $a_{2}*x^{2} + a_{1}*x^{1} + a_{0}*x^{0}$, y si prestás atención te das cuenta que cumple con un patrón.

Si continuamos dicho patrón, obtenemos las llamadas _funciones polinómicas_

$y = f(x) = a_{n}\cdot x^{n} + a_{n-1}\cdot x^{n-1} + ... + a_{2}\cdot x^{2} + a_{1}\cdot x + a_{0}$

En guías futuras entraremos más en detalle en el uso de estas funciones y nuestra aplicación favorita de las mismas con el _Polinomio de Taylor_.

"""

# ╔═╡ 85df8462-5ca9-11eb-0b96-ed23e4415cb1
md"""
.$e$ es un valor que seguro ya tenés en tu calculadora. Si lo buscás vas a ver que vale aproximadamente $2,718$. Fijate cómo se va acercando el valor de $e$ en el gráfico (está debajo a la derecha) a ese valor a medida que aumentás el valor de $n$.
"""

# ╔═╡ ee082e2c-6716-11eb-1f0a-1fae0ed2f74a
md"
## Función Exponencial"

# ╔═╡ 43d3ce80-5d90-11eb-1b5f-bf36a9dea97d
md"
#### Funcion exponencial


La funcion $f(x) = 3^{x}$ se denomina $\textit{funcion\ exponencial}$ ya que la variable, en este caso $x$ es el exponente, es decir \"la que esta arriba\" . Ojo no confundir con una la funcion potencia $g(x) = x^2$ donde la variable es la base

En general una funcion exponencial posee la forma 

$f(x)=a^x$ 
donde  $a$ es una constante positiva. Si $x=n$, es decir un entero positivo, entonces tenemos

$f(x)=a^n= a\cdot a\cdot a ...\cdot  a$ tantas veces como $n$

Si $x=0$, entonces: $a^0 = 1$


y si $x=-n$ donde de nuevo $n$ es un número entero positivo, tenemos:

$b^{-n} = \frac{1}{b^{n}}$

Si $x$ es un número racional, es decir $x=\frac{p}{q}$
 donde $p$ y $q$ son enteros y $q>0$ , enteonces tenemos que
$a^x =a^{\frac{p}{q}} = \sqrt[q]{b^ {p}} =\sqrt[q]{b}= \sqrt[q]{b}^{p}$

Veamos como son los graficos de algunos de los casos que estuvimos explicando:
"

# ╔═╡ 01e8d45c-5d95-11eb-32a2-05703b43541a
begin
	xe = collect(-3:0.1:3)
	fe1(xe) = (1/4).^xe 
	ye1=fe1.(xe)
	plot(xe,ye1,label="(1/4)^x")
	fe2(xe) = (1/2).^xe 
	ye2=fe2.(xe)
	plot!(xe,ye2,label="(1/2)^x")
	fe3(xe) = (1).^xe 
	ye3=fe3.(xe)
	plot!(xe,ye3,label="1^x")
	fe4(xe)= (1.5).^xe 
	ye4=fe4.(xe)
	plot!(xe,ye4,label="1.5^x")
	fe5(xe) = (2).^xe 
	ye5=fe5.(xe)
	plot!(xe,ye5,label="5^x")
	fe6(xe) = (4).^xe 
	ye6=fe6.(xe)
	plot!(xe,ye6,label="4^x")
	fe7(xe) = (10).^xe 
	ye7=fe7.(xe)
	plot!(xe,ye7,label="10^x",legend=:topleft)
	ylims!(0,3)
end

# ╔═╡ c9e2fcf2-5d96-11eb-2561-53b190a409d0
md"

###### Leyes de los exponentes


Sean $a$ y $b$ numeros enteros positivos y $x$ e $y$  cualquier número real, entonces:

$$b^{x+y} = b^{x} b^{y}$$

$$b^{x-y} =  \frac{b^{x}} {b^{y}}$$

$$(b^{x})^y = b^{xy}$$

$$(ab)^x = a^x b^x$$
"

# ╔═╡ 55cf6280-55dd-11eb-117f-f1bf6a29565b
md"""



Ahora sí, comencemos con un ejemplo conocido y reciente: el coronavirus.

Cómo puede ser que de un infectado en una ciudad China hayamos pasado a más de 100 millones de infectados (al día que redactamos esto) esparcidos por todo el mundo? Tardamos alrededor de 10 meses en llegar a esta cantidad de infectados. 

Hagamos de cuenta que no estamos estudiando ingeniería y queremos imaginarnos cómo ese paciente zero en Wuhan infectó a tanta gente. La primer forma que se me ocurre es exagerar. Les propongo un modelo en el que se infecta una persona por segundo a lo largo de 10 meses. Creen que lleguemos a 100 millones de infectados?

La respuesta corta es que no. Hacer la cuenta es fácil. Cuántos segundos hay en 10 meses? 10 meses que tienen 30 días que tienen 24 horas que tienen 60 minutos que tienen 60 segundos.
$10*30*24*60*60=25920000$

O sea, infectando a una persona por segundo por 10 meses no llegamos ni a los 26 millones de infectados.

Entonces, cómo puede ser? Hubo 4 infectados por segundo? Tendría sentido, ahí las cuentas me darían casi perfectamente. Pero la respuesta es que no, la propuesta inicial que planteamos es de crecimiento lineal. Con esta propuesta todos los meses tendremos la misma cantidad de infectados, todos los días lo mismo y todas las horas lo mismo.

Para modelar el Covid se ve que tenemos que pensar de otra forma, y como bien dice el título de esta sección, lo vamos a modelar con una función exponencial.


"""

# ╔═╡ ef349bd0-55eb-11eb-0b53-999cd0ef6167
md"""

### Crecimiento exponencial

##### Modelo exponencial del COVID en Argentina

En el siguiente grafico vemos los datos del COVID desde el 3 de marzo hasta el 5 de abril del 2020. 

Para describir
ir el crecimiento utilizamos la siguiente formula:


$N(t) =2.673\  e^{0.211 x}$


"""

# ╔═╡ 586b3184-5daa-11eb-3868-cf88404f1bf9
begin
	xcovid = collect(0:1:40)
	fcovid1(xcovid) = 2.673 *exp.(0.211xcovid)
	ycovid1=fcovid1.(xcovid)
	plot(xcovid,ycovid1,label="Ajuste potencia")
	
	d1 = [1:1:34]
	datos_covid = [1,1,2,8,9,12,17,19,21,31,34,45,56,65,78,97,128,158,225,266,301,387,503,589,690,745,820,966,1054,1133,1265,1353,1451,1554]
	scatter!(d1,datos_covid,label="Poblacion",legend=:bottomright)
	ylims!(0,1600)
	
end

# ╔═╡ 86161db2-5db2-11eb-19b3-bbeeb5e98e3c
md" 
Vimos que en un principio la curva se pudo modelar mediante una curva exponencial pero a medida que pararon más dias la misma no fue tan excacta. Esto se soluciona utilizando una mayor cantidad de terminos
"

# ╔═╡ a85efa00-55cf-11eb-26ae-ada91c1a547d
md"""

##### Población Mundial

Veamos otro ejemplo. Pensemos en el crecimiento de la población humana en los últimos 120 años.

Como casi todo en la vida, podemos modelarlo con una función, y como te podrás imaginar, nuevamente la función que vamos a usar es la exponencial.

.$P(t)$ es la población mundial en función del tiempo.

Pensemos que en dicha función, $t=0$ corresponde al año 1900.

Toda la información que tenemos la podemos transcribir a una tabla:

| Año  | t   | Población |
|------|-----|-----------|
| 1900 | 0   | 1650000   |
| 1910 | 10  | 1750000   |
| 1920 | 20  | 1860000   |
| 1930 | 30  | 2070000   |
| 1940 | 40  | 2300000   |
| 1950 | 50  | 2560000   |
| 1960 | 60  | 3040000   |
| 1970 | 70  | 3710000   |
| 1980 | 80  | 4450000   |
| 1990 | 90  | 5280000   |
| 2000 | 100 | 6080000   |
| 2010 | 110 | 6870000   |
| 2020 | 120 | 7800000   |

También se puede pasar a un gráfico:


"""

# ╔═╡ b40b45ee-5ca4-11eb-3c06-ab084f0ded65
md"""

Y cómo sería una fórmula que prediga estos datos?

Hasta donde sabemos, es imposible pensar en una fórmula exacta que nos de el crecimiento de la población humana, pero como todo, sí podemos aproximarla.

Por ahí en tu carrera llegás a desarrollar esto en algún momento, pero para este curso no tiene sentido. Solamente veamos cómo quedaría dicha aproximación:

$P(t) = (1,43653*10^{6})*(1,01395)^{t}$

Esto último sería un modelo matemático del crecimiento poblacional mundial.

"""

# ╔═╡ 92dc44fe-5c36-11eb-362e-5b973d643c25
begin
	x2 = collect(0:10:120)
	f2(x2) = (1.43653 * 10^6)* 1.01395.^x2
	y2=f2.(x2)
	plot(x2,y2,label="P(t)")
	t1 = [0,10,20,30,40,50,60,70,80,90,100,110,120]
	p = [1650000,1750000,1860000,2070000,2300000,2560000,3040000,3710000,4450000
		,5280000,6080000,6870000,7800000]
	scatter!(t1,p,label="Poblacion",legend=:bottomright)
	xlims!(0,130)
	xticks!(0:10:120,			["1900","1910","1920","1930","1940","1950","1960","1970","1980","1990","2000","2010","2020"])
	xlabel!("Años")
	ylims!(0,8*10^6)
	ylabel!("Poblacion")
end

# ╔═╡ 7de3a734-5ca6-11eb-314a-b965bb97844e
md"""

## El Número de Euler "$e$"

En general preferimos entrar a ejemplos antes de mostrar la parte algebraica y matemática de los temas. Pero en este caso, para llegar a explicar funciones exponenciales y logarítmicas, nos toca introducir un número famoso que puede ser que no todos hayan visto en el secudario.

En guías futuras se va a desarrollar la importancia de este número y cómo resolver cuentas como ésta, por ahora creenos que su definición es así:

$e= \lim_{n\to\infty} \left(1+\frac{1}{n}\right) ^{n}$

Si tenés curiosidad cómo funciona una cuenta con el límite y no podés esperar a la guía que viene, la idea en este caso es que la "$n$" _tiende_ a infinito. Lo que quiere decir que si escribís esa cuenta en tu calculadora y vas aumentando el valor de $n$, el resultado se irá acercando de a poco al valor de $e$.

Si no tenés ganas de cambiar tanto esa cuenta en la calculadora, no te preocupes que ya lo hicimos por vos. Fijate cómo cambia el gráfico de abajo a medida que vas aumentando $n$.
"""

# ╔═╡ e304e16e-5ca6-11eb-277a-cf504d496670
begin
	e_slider = @bind terminos NumberField(1:200, default=5)
	md"""Valor de $n$: $(e_slider)"""
end

# ╔═╡ eed2e39c-5ca6-11eb-0e5b-11de2ae16846
begin
	e = zeros(terminos)
	n = collect(1:1:terminos)
	for i = 1:terminos
		e[i] = (1 + 1/n[i]) ^ n[i]
		exp = e[i]
	end
	scatter(n,e,label="$exp", legend=:bottomright)
	xlabel!("Valor de n")
	ylabel!("Valor de e")
end

# ╔═╡ d9af9350-55eb-11eb-0d0e-e1932621ab4d
md"""

### Decrecimiento o decaimiento exponencial:


"""

# ╔═╡ 20a6b404-5da4-11eb-0664-c942ae7e07af
md"

El decaimiento exponencial es un proceso que sucede cuando una cantidad esta sujeta a una disminucion proporcional a la cantidad dicha.



Estos procesos los vamos a entender mejor cuando hacia el final de la materia veamos uno de los temas más interesantes de la matemática: $Las\ ecuaciones\ diferenciales$.


Por ahora solo veremos la forma de expresar el decaimiento. Consideremos una cantidad $N$ que depende del tiempo $t$ por lo que será $N(t)$ y tiene la forma:

$N(t) = N_0\  e^{(-\alpha t)}$
Donde $N_0$ es la cantidad inicial y $\alpha$ es una constante que depende del fenomeno a describir
" 

# ╔═╡ 4fb87c40-55ee-11eb-3c0c-e998b5972411
md"""
	
#### Ejemplo de la Reactividad de un Átomo

Un ejemplo bastante simple de visualizar que solo algunos de ustedes van a terminar desarrollando en sus carreras es cómo varía la reactividad de un átomo. Básicamente, existe lo llamado _tiempo de vida media_ que se refiere a lo que tarda una muestra radiactiva en llegar a la mitad de su radiación inicial. Pero donde esto aplica al título de nuestra subsección, es que si dejamos pasar otro _tiempo de vida media_, la radiación se va a dividir en 2 de nuevo, y si dejamos pasar otro tiempo se fraccionará de nuevo, y así sucesivamente.

De esta forma terminaríamos con un gráfico que expresa perfectamente el decaimiento exponencial en la naturaleza. En el siguiente ejemplo se ve el caso del  $_{92}^{238}\textrm{U}$ (Uranio), cuyo _tiempo de vida media_ es de 4.500.000.000 años.

La vida media del uranio 238 viene dada de la siguente manera

$ N(t) = 100\  e^ {(-0.1t t)}$

veamos como es el mismo graficandolo


"""

# http://www7.uc.cl/sw_educ/qda1106/CAP4/4B/index.htm

# ╔═╡ 0eeabf0e-5da5-11eb-3ba4-f31c5481eb49
begin
	N(t) = 100 * exp(-0.15 *t)
	plot(N,0,10,lab="N(t)")
	#scatter!(N,0:24:96, lab="Dias") 
	xlabel!("Tiempo  (Billones de años)")
	ylabel!("Cantidad de Uranio (mg)")

	
end

# ╔═╡ 2b04a32a-5da4-11eb-2fb8-7fae9c509505
md"
Algunas aplicaciones de lo que acabamos de ver son


- Reacciones químicas: Las velocidades de ciertos tipos de reacciones químicas dependen de la concentración de uno u otro reactivo. Las reacciones cuya velocidad depende sólo de la concentración de un reactante (conocidas como reacciones de primer orden) siguen consecuentemente el decaimiento exponencial.
- Geofísica: La presión atmosférica disminuye aproximadamente exponencialmente con el aumento de la altura sobre el nivel del mar, a una tasa de alrededor del 12% por 1000m

- Transferencia de calor: Si un objeto a una temperatura es expuesto a un medio de otra temperatura, la diferencia de temperatura entre el objeto y el medio sigue una decadencia exponencial (en el límite de los procesos lentos; equivalente a una buena conducción de calor dentro del objeto, de modo que su temperatura permanece relativamente uniforme a través de su volumen)
- Espuma de cerveza: Arnd Leike, de la Universidad Ludwig Maximilian de Múnich, ganó un premio Ig Nobel por demostrar que la espuma de la cerveza obedece a de la ley de la decadencia exponencial

- Finanza: Un fondo de retiro se deteriorará exponencialmente al estar sujeto a montos de pago discretos, generalmente mensuales, y a una entrada sujeta a una tasa de interés continua. Una ecuación diferencial dA/dt = entrada - la salida puede ser escrita y resuelta para encontrar el tiempo para alcanzar cualquier cantidad A, que permanezca en el fondo.


"

# ╔═╡ 727655e6-5caa-11eb-1893-3fce87151446
md"""

#### Crecimiento vs decaimiento exponencial

Entonces podemos ver que a las funciones exponenciales podemos separarlas en 2 clasificaciones principales. Las de crecimiento exponencial (como vimos del Covid y del crecimiento poblacional) y las de decaimiento exponencial (reactividad de un átomo).

Si la notación de nuestras funciones exponenciales es de $y = f(x) = a^{x}$

Cómo las diferenciamos?

Es bastante simple, cuando nuestra variable potencia una constante mayor a 1 tenemos crecimiento exponencial. O sea, si $a>1$.
En caso que $0<a<1$, nos encontramos con decaimiento exponencial.

Fijate cómo va cambiando la función a medida que hacemos variar $a$.

"""

# ╔═╡ 3254f9f8-5cb0-11eb-0bef-1de90ded7c4c
begin
	ae_slider=  @bind ae Slider(0:0.05:2; default=1.2, show_value=true)
	md"""a: $(ae_slider)"""
end

# ╔═╡ 4336abb8-5cb0-11eb-2a99-07f1b6245f70
begin
	xexp = collect(-20:0.1:20)
	pe = plot(xexp, xexp -> ae^xexp , label="", colour=:red)
	xlabel!("Eje x")
	ylabel!("Eje y")
	title!("$ae^x")
	plot(pe)
end

# ╔═╡ 4483dfd0-55ef-11eb-31da-31658529f814
md"""

## Logaritmos

Antes de ver la _función logarítmica_ preferimos dar un pequeño repaso. Qué es un logaritmo?

En términos súper simples, sería la función inversa de la exponencial. O tambien se puede pensar como \"por qué  numero tengo que elevar a  $b$ para que me de $a$"\

Decir: $log_{b}(a) = c$ 

Es lo mismo que: $b^{c} = a$

Y se lee _el logaritmo de base $b$ de $a$ es igual a $c$_.

En este curso el logaritmo que más vamos a usar es el de base 10: $log_{10}(x)$

Pero también tenemos un logaritmo importantísimo con base $e$, llamado _logaritmo natural_ o _logaritmo neperiano_

Esto sería: $Ln(x) = log_{n}(x)$

Por lo que el $Ln(e) = 1$, porque se traduce como $e^{x} = e$, por lo que $x=1$.

Aquí pueden cambiar los parámetros que quieran de una función logarítmica genérica y ver cómo queda su gráfico.

"""

# ╔═╡ 830b5508-5cac-11eb-241f-5103abeaee17
begin
	alog_slider=  @bind alog Slider(0:0.1:10; default=2, show_value=true)
	md"""a: $(alog_slider)"""
end

# ╔═╡ 712a3276-5c36-11eb-2c1b-353247409db1
begin
	xlog=collect(0.01:0.01:10)
	
	plot(xlog,log.(alog,xlog),label="",legend=:bottomright)
	xlabel!("Eje x")
	ylabel!("Eje y")
	
	title!("$log $alog x")

end

# ╔═╡ 92d1188e-5bd9-11eb-0934-e59f8142ccde
md"""
#### Escalas

Cuando estabas revisando cuántos casos de COVID hubo ese mismo día, es probable que te hayas cruzado con la frase _escala logarítmica_. En pocas palabras, esta escala permite convertir funciones exponenciales en funciones lineales. Por lo tanto, para aplicaciones como visualizar mejor la cantidad de infectados de COVID suele ser muy útil. Y si ahora te estás preguntando, cuál sería la escala _normal_, a la que me acostumbré a usar (y seguirás usando)? Esa escala se llama _escala lineal_.

Primero veamos un poco el porqué de la escala mencionada

Si encontramos una linea recta en un grafico sem logaritmico, sabemos que:

$$\log(y) \sim \alpha x + \beta,$$

donde el  $\sim$ muestra que es aproximado

Aplicando exponencial a ambos lados de la ecuacion tenemos



$$e^{(log(y))} = y \sim e^{\alpha x + \beta},$$

Por propiedades del exponencial tenemos:

$e^{(\alpha x + \beta)} = e^{(\alpha x)}  e^{(\beta)}$


además $e^{\beta} = Constante = c$ 

Finalmente tenemos:

$$y \sim c \, \mathrm{e}^{\alpha x},$$


donde la constante $\alpha$ es la velocidad de crecimiento exponencial  que se ve como la pendiente de la linea recta en un grafico semi logaritmico


##### Aqui ponemos grafico comparacion de Covid con escala lineal y escala logarítmica.
"""

# ╔═╡ 64cc285a-5da7-11eb-0351-0bce87f950df
md"
A continuacion graficamos el promedio semanal de casos en Argentina en funcion de los dias que pasaron desde que todo comenzó"

# ╔═╡ b420b010-5da7-11eb-146f-7112f516560f
md"
Ahora veamos que apariencia posee el grafico se utilizamos una escala semi logaritmica"

# ╔═╡ c33b39da-5da7-11eb-1f0d-a3106a1cbd00
begin
	plot(replace(daily_cases, 0 => NaN), 
		yscale=:log10, 
		leg=false, m=:o)
	xlabel!("dias")
	ylabel!("Casos confirmados en Argentina")
	title!("")
end

# ╔═╡ e1864d82-5bcf-11eb-04cc-c908a8bc0792
md"""
#### Propiedades de los Logaritmos:

Estas son propiedades que vas a tener que aprender. Vamos a graficarlas e intentar a ayudarte a entender cómo se llega a esa magia, pero si no lo podés ver, creenos que son así y seguí adelante que no entenderlas tampoco te va a generar trabas.

$Log\left ( a * b \right ) = Log(a) + Log(b)$

$Log\left ( \frac{a}{b} \right ) = Log(a) - Log(b)$

$Log\left ( a^{b} \right ) = Log(a) *b$

$Log( \sqrt[b]{a} ) = Log(a) *\frac{1}{b}$


Se pueden graficar?

"""

# ╔═╡ bd351582-6717-11eb-2194-7dd2b34ec07c
md"
### Ejemplos practicos"

# ╔═╡ 194e558c-5bd2-11eb-2c94-d90a9d3655c0
md"""
#### Funciones logarítmicas para el cálculo de la intensidad del sonido con lo llamado _decibeles_.

$L(I)=10*log_{10}\left ( \frac{I}{I_{0}} \right )$

.$I$ sería la intensidad del sonido e $I_{0}$ es un valor de referencia. $L(I)$ sería el nivel de la intensidad del sonido, éste se mide con un número adimensional llamado _decibeles_ (que se abrevia db).

Por ejemplo: Si duplico potencia sonora de mi fuente (de donde sale el sonido), cuántos decibeles creen que va a aumentar la intensidad de dicho sonido?

La solución sería:

$L(2I)=10*log_{10}\left ( \frac{2I}{I_{0}} \right )$

$L(2I)= 10*\left ( log_{10}\left ( \frac{I}{I_{0}} \right ) + log_{10}\left ( 2 \right ) \right )$

$L(2I) = L(I) + 10* log_{10}\left ( 2 \right )$

$L(2I) = L(I) + 3,01 db$

Por lo tanto, duplicar la potencia sonora me genera un aumento de aprox 3 decibeles en mi intensidad del sonido.


"""

# ╔═╡ f3bb80d4-5bd5-11eb-0e63-83ac5284c67e
md"""
#### Funciones logarítmicas para el cálculo de la intensidad de los terremotos.

La escala logarítmica de Richter mide la intensidad de los terremotos a partir de la siguiente fórmula:

$R = log_{10}\left ( \frac{a}{T} \right ) + B$

Donde $a$ es la amplitud del movimiento del suelo, $T$ es el período de la actividad sísmica y $B$ un factor empírico que representa el debilitamiento de la onda sísmica a medida que se aumenta la distancia desde el epicentro del terremoto a la estación receptora.

Por ejemplo, qué magnitud en la escala Ritcher nos daría un terremoto a 10,000 km de la estación receptora (B = 6.8); con el movimiento vertical del suelo $a=10 \text{micrones}$ y el período $T=1 \text{segundo}$.

La magnitud del terremoto es: 
$R = log_{10}\left ( \frac{10}{1} \right ) + 6,8 = 1 + 6,8 = 7,8$

"""

# ╔═╡ a4e57bf2-5c36-11eb-13a2-dbf774b4c79e
md"""
# Funciones Varias

Ya terminamos de darte ejemplos de las funciones más importantes que vas a usar a lo largo de tu carrera. Para cerrar, te dejamos más funciones interactivas para que veas cómo varían según sus parámetros. Eventualmente vas a haber hecho tantos ejercicios con éstas que te las vas a poder imaginar sólo, por ahora te dejamos esta ayuda: 

"""

# ╔═╡ 40e6fec4-5c3d-11eb-1a3c-9bdec6e05121
begin
	nexp_slider=  @bind nexp  NumberField(-10:1:10, default=2)
	md"""Exponente: $(nexp_slider)"""
end

# ╔═╡ 1afba524-5cfe-11eb-36f0-63c0e68da0d7
md"""

Si te genera dudas qué le está pasando a la función cuando elegís un exponente negativo, sería esto:

$x^{-2} = \frac{1}{x^{2}}$

Y claramente cuando elegís que tu exponente sea $0$.

$x^{0} = 1$

Lo que genera una función constante.

Acá te dejo varios ejemplos uno al lado del otro para que compares vos.

"""

# ╔═╡ ae5d3120-5c36-11eb-28a7-8b225824fe58
begin
	x=collect(-5:0.1:5)
	p1 = plot(x, x.^2,title="x²")
	p2 = plot(x, x.^3,title = "x³")
	p3 = plot(x, x.^4, title = "x⁴")
	p4 = plot(x, x.^5,title = "x⁵")
	plot(p1, p2, p3, p4, layout = (2, 2), legend = false)
end

# ╔═╡ 4a81d2f8-5c3d-11eb-2e62-1983b7938e8c
begin
	x11=collect(-5:0.1:5)
	p11 = plot(x, x.^nexp)
	xlabel!("Eje x")
	ylabel!("Eje y")
	title!("x^$nexp")
end

# ╔═╡ b29fea3e-5c36-11eb-2456-b17d52001aa4
begin

	p5 = plot(x, x.^-1,title="1/x") 
	p6 = plot(x, x.^-2,title = "1/x²") 
	p7 = plot(x, x.^-3, title = "1/x³")
	p8 = plot(x, x.^-4,title = "1/x⁴") 
	plot(p5, p6, p7, p8, layout = (2, 2), legend = false)
	ylims!(-10,10)
	
end

# ╔═╡ 0c37373c-5cff-11eb-2f2f-978ac03a1c2d
md"""

Y si el exponente es una fracción?

Fijate qué pasa:

"""

# ╔═╡ 93d9bca0-5cff-11eb-117a-0715987e77d9
begin
	nraiz_slider=  @bind nraiz  NumberField(-2:0.1:3, default=0.5)
	md"""Exponente: $(nraiz_slider)"""
end

# ╔═╡ bcb4a7ca-5cff-11eb-3894-878db1c7e609
begin
	xraiz=collect(0:0.1:5)
	praiz = plot(xraiz, xraiz.^nraiz)
	xlabel!("Eje x")
	ylabel!("Eje y")
	title!("x^$nraiz")
end

# ╔═╡ f2773e60-5cff-11eb-04ea-9d5b30afef65
md"""

Para que entiendas por qué pasa esto:

$x^{\frac{1}{2}} = \sqrt{x}$

$x^{\frac{1}{6}} = \sqrt[6]{x}$

$x^{\frac{2}{5}} = \sqrt[5]{x^{2}}$

"""

# ╔═╡ 3a129cee-5d01-11eb-31a4-31f5f06fac14
md"""

### Función de Valor Absoluto

Seguramente alguna vez la viste, se denota $|x|$ y básicamente lo que hace la función es convertir todos los valores negativos de x en positivos:

$y = f(x) = |x|$

O también puede pasar que convierta todos los valores en negativos:

$y = f(x) = -|x|$

Se puede aplicar el valor absoluto a cualquiera de las funciones que venimos viendo. Te voy a dejar de ejemplo cómo afecta a una función lineal:

$y=f(x)=|2x-3|$

"""

# ╔═╡ 80f00182-5d02-11eb-2f61-897afe2fc02a
begin
	xabs = collect(-20:0.1:20) 
	plot(xabs,((xabs.*2 .- 3).^2).^(1/2))
	xlabel!("Eje x")
	ylabel!("Eje y")
	
	title!("|2x-3|")
end

# ╔═╡ ba7b9e20-5d02-11eb-0d99-c74a3127e1d9
md"""

O mejor aún, cambiale los parámetros que quieras y fijate qué pasa

$y = f(x) = |2m+b|$

"""

# ╔═╡ c8e3a9da-5d02-11eb-0027-dd18a728bad7
begin
	mabs2_slider=  @bind mabs2  NumberField(-5:0.1:5, default=2)
	md"""m: $(mabs2_slider)"""
end

# ╔═╡ df4a0b6a-5d02-11eb-0c5c-e75a1439c1d3
begin
	babs2_slider=  @bind babs2  NumberField(-5:0.1:5, default=3)
	md"""b: $(babs2_slider)"""
end

# ╔═╡ 3a63e190-5d03-11eb-2ab4-93e07cd28762
begin
	xabs2 = collect(-20:0.1:20) 
	plot(xabs,((xabs.*mabs2 .+ babs2).^2).^(1/2))
	xlabel!("Eje x")
	ylabel!("Eje y")
	ylims!(-1,100)
	title!("|2*$mabs2+$babs2|")
end

# ╔═╡ 52934520-55ef-11eb-2ca7-6bf9f9f2b5f9
md"""

## Funciones trigonométricas

Antes de arrancar con éstas, quiero recordarte (o enseñarte) la regla nemotécnica más útil de la historia. Con ésta nunca te vas a olvidar de dónde sale cada una de las 3 principales funciones trigonométricas.

.$SOH.CAH.TOA$

.$SOH$ -> $Seno = \frac{Opuesto}{Hipotenusa}$

.$CAH$ -> $Coseno = \frac{Adyacene}{Hipotenusa}$

.$TOA$ -> $Tangente = \frac{Opuesto}{Adyacente}$

Para que veas cómo varían las funciones trigonométricas, te dejamos la versión más genérica posible de las mismas graficadas junto a funciones cuyos parámetros podés modificar.

"""

# ╔═╡ acb3e132-67f5-11eb-2de1-eff4dab3fe72
triangulos = "https://www.disfrutalasmatematicas.com/algebra/images/adjacent-opposite-hypotenuse.svg";

# ╔═╡ f71fbffc-67f5-11eb-03c5-1bd7320c54e6
Resource(triangulos)

# ╔═╡ 247ff22a-5d04-11eb-2dee-63ff0393f281
md"""

#### Función Seno

$y = f(x) = sen(x)$

Genérica interactiva:

$y = f(x) = a*sen(b*x+\phi)$

"""

# ╔═╡ bdf7ddec-5d05-11eb-0799-6bad270ea692
begin
	asen_slider=  @bind asen Slider(-10:0.1:10; default=1, show_value=true)
	md"""a: $(asen_slider)"""
end

# ╔═╡ c6bb9f40-5d05-11eb-3096-579c534fa5af
begin
	bsen_slider=  @bind bsen Slider(-10:0.1:10; default=1, show_value=true)
	md"""b: $(bsen_slider)"""
end

# ╔═╡ cc8167a0-5d05-11eb-1a70-f5c96dfac04d
begin
	csen_slider=  @bind csen Slider(-10:0.1:10; default=0, show_value=true)
	md"""$ \phi$: $(csen_slider)"""
end

# ╔═╡ 7ce90564-5d04-11eb-17f1-8dd00557cac1
begin
	xsen=collect(-2π:0.01π:2π)
	g1(xsen)= sin.(xsen)
	g1i(xsen)= asen * sin.(xsen * bsen + csen)

	plot(g1,-2π,2π,lab="sen(x)")
	plot!(g1i,-2π,2π,lab="interactiva")
	xlims!(-2π,2π)
	ylims!(-5,5)
end

# ╔═╡ 3adda8fa-5d04-11eb-13c6-55f5fe0f44ac
md"""

#### Función Coseno

$y = f(x) = cos(x)$

Genérica interactiva:

$y = f(x) = a*cos(b*x+\phi )$

"""

# ╔═╡ 596d15a6-5d06-11eb-3015-518510dec087
begin
	acos_slider=  @bind acos Slider(-10:0.1:10; default=1, show_value=true)
	md"""a: $(acos_slider)"""
end

# ╔═╡ 6c1c3ed4-5d06-11eb-338f-d5e87025bcbe
begin
	bcos_slider=  @bind bcos Slider(-10:0.1:10; default=1, show_value=true)
	md"""b: $(bcos_slider)"""
end

# ╔═╡ 769956d0-5d06-11eb-1696-21f883bdab99
begin
	ccos_slider=  @bind ccos Slider(-10:0.1:10; default=0, show_value=true)
	md"""$ \phi$: $(ccos_slider)"""
end

# ╔═╡ da2060f6-5d04-11eb-3a60-03ee847395ad
begin
	xcos=collect(-2π:0.01π:2π)
	g2(xcos)= cos.(xcos)
	g2i(xcos)= acos * cos.(xcos * bcos + ccos)

	plot(g2,-2π,2π,lab="cos(x)")
	plot!(g2i,-2π,2π,lab="interactiva")
	xlims!(-2π,2π)
	ylims!(-5,5)
end

# ╔═╡ 478929bc-5d04-11eb-304e-7b6a97f299da
md"""

#### Función Tangente

$y = f(x) = tan(x)$

Genérica interactiva:

$y = f(x) = a*tan(b*x+\phi)$

"""

# ╔═╡ b605ea40-5d06-11eb-0079-11e8eb264144
begin
	atan_slider=  @bind atan Slider(-10:0.1:10; default=1, show_value=true)
	md"""a: $(atan_slider)"""
end

# ╔═╡ c53831ee-5d06-11eb-393c-d94c605714e6
begin
	btan_slider=  @bind btan Slider(-10:0.1:10; default=1, show_value=true)
	md"""b: $(btan_slider)"""
end

# ╔═╡ ce26374c-5d06-11eb-037f-09b672ab9bb8
begin
	ctan_slider=  @bind ctan Slider(-10:0.1:10; default=0, show_value=true)
	md"""$ \phi$ $: $(ctan_slider)"""
end

# ╔═╡ 4ba74a02-5d05-11eb-3e4b-2dbe1f037dd7
begin
	xtan=collect(-2π:0.01π:2π)
	g3(xtan)= tan.(xtan)
	g3i(xtan)= atan * tan.(xtan * btan + ctan)

	plot(g3,-2π,2π,lab="tan(x)")
	plot!(g3i,-2π,2π,lab="interactiva")
	xlims!(-2π,2π)
	ylims!(-5,5)
end

# ╔═╡ 69c8c20c-5d05-11eb-32ea-51e02354fa0e
md"""

Y si querés ver una al lado de la otra:

"""

# ╔═╡ 5f4f30cc-5d05-11eb-1c2a-2fcd170295ef
begin
	plot(g1,-2π,2π,lab="sen(x)")
	plot!(g2,-2π,2π,lab="cos(x)")
	plot!(g3,-2π,2π,lab="tan(x)")
	xlims!(-2π,2π)
	ylims!(-5,5)
end

# ╔═╡ eacd154e-5da3-11eb-1bad-839fdff53ded
md"

#### Transformacion de funciones
(o como obtener nuevas funciones a partir de viejas)


###### Traslaciones
Supongamos que tenemos un $c > 1$ . Veremos como se puede modificar la funcion $f(x)$
- $y = f(x)+c$ mueve el grafico de $y = f(x)$ verticalmente hacia arriba por una unidad de $c$ 
- $y = f(x)-c$ mueve el grafico de $y = f(x)$ verticalmente hacia abajo por una unidad de $c$
- $y = f(x-c)$ mueve el grafico de $y = f(x)$ horizontalmente hacia la derecha por una unidad de $c$ 
- $y = f(x+c)$ mueve el grafico de $y = f(x)$ horizontalmente hacia la izquierda por una unidad de $c$ 




"

# ╔═╡ 86078f3c-5dbb-11eb-37b1-5d710b4b658e
md"
veamoslo un poco mejor graficando
"

# ╔═╡ e26e74f2-5dbb-11eb-3395-15624d9b306e
begin
	cslider = @bind  c html"<input type=range min=-3 max=10>"
	

		md"""**Deslizá para cambiar el valor de la constante $c$:**
	
		$(cslider)"""
end

# ╔═╡ 960f68a2-5dbb-11eb-2c1a-0d66db2695d0
begin
fmod(xmod)= xmod^2 * sin(xmod)
xmod = collect(-3:0.1:3)
ymod=fmod.(xmod)
plot(xmod,ymod,lab="f(x)")
plot!(xmod,ymod.+c, lab="f(x)+c")
plot!(xmod,ymod.-c,lab="f(x)-c")
plot!(xmod.-c,ymod,lab=" f(x-c)")
plot!(xmod.+c,ymod,lab="c f(x+c)")
end


# ╔═╡ f963a8fe-5dbd-11eb-28b3-db46d5fb3638
md"
###### Estirado y reflejado
Supongamos que tenemos un $c > 1$ . Veremos como se puede modificar la funcion $f(x)$
- $y = c \cdot f(x)$ estira el grafico de $y = f(x)$ verticalmente por un factor de $c$ 
- $y = 1/c \cdot f(x)$ achica el grafico de $y = f(x)$ verticalmente por un factor de $c$ 
- $y = f(c x)$ estira el grafico de $y = f(x)$ horizontalmente por un factor de $c$ 
- $y = f(x/c)$ achica el grafico de $y = f(x)$ horizontalmente por un factor de $c$
- $y = -f(x)$ refleja el grafico de $y = f(x)$ respecto el eje $x$
- $y = f(-x)$ refleja el grafico de $y = f(x)$ respecto el eje $y$
"

# ╔═╡ aaa91f74-5dbe-11eb-0634-3d4f3428cac9
md"
Grafiquemos para terminar de entenderlo 
"

# ╔═╡ bdebb2b8-5dbe-11eb-040f-afbe83855334
begin
	d=4
	fmod2(xmod2)= xmod2^2 + 3xmod2
	xmod2 = collect(-3:0.1:3)
	ymod2=fmod2.(xmod2)
	plot(xmod2,ymod2,lab="f(x)")
	plot!(-xmod2,ymod2, lab="f(-x)")
	plot!(xmod2,-ymod2,lab="-f(x)")
	plot!(1/d * xmod2,ymod2,lab=" f(x/c)")
	plot!(d* xmod2,ymod2,lab="f(cx)")
	xlims!(-3,3)
end



# ╔═╡ d3336728-5dbf-11eb-3c1d-79728396ef42
md"
###### Combinacion de funciones
Sean $f$ y $g$ dos funciones con sus respectivos domminios $D(f)$ y $D(g)$ respectivamente Estas pueden ser sumadas, restadas y multiplicadas en la interseccion de dichos dominions, esto es
- $(f+g)(x) = f(x) + g(x)$ (adicion)
- $(f-g)(x) = f(x) - g(x)$ (sustaccion)
- $(fg)(x) = f(x)  g(x)$ (multiplicacion)
- Y en los puntos $x$ donde $g(x) \neq  0$ ,  $f$ puede ser dividido por $g$ mediante $f/g (x)  = f(x)/g(x)$


"

# ╔═╡ b393562c-5dc0-11eb-1efa-69c1387081ba
md"
### A este ploteo hay que pensarlo distinto para que sea más claro"

# ╔═╡ 9495e74c-5dc0-11eb-1620-e5395a73a3cc
begin

	e1(x)=cos(x)
	r(x)=sin(x)
	t11(x)= e1(x) + r(x)
	t2(x)= e1(x) - r(x)
	t3(x)= e1(x) * r(x)
	t4(x)=r(x) / e(x)


	plot(e1,-2π,2π,lab="e(x)")
	plot!(r,-2π,2π,lab="r(x)")
	plot!(t11,-2π,2π,lab="(e+r)(x)")
	plot!(t2,-2π,2π,lab="(e-r)(x)")
	plot!(t3,-2π,2π,lab="(e*r)(x)")
	#plot!(t4,-2π,2π,lab="(r/e)(x)")
	#xlims!(-0.2,2π+0.2)
	#ylims!(-1.1,1.1)
	xticks!(-2π:π/2:2π,["-π/2", "-π","-3π/2","-2π","0", "π/2", "π","3π/2","2π"])
	yticks!([-1,0,1])
end

# ╔═╡ c294b3a8-5dc0-11eb-07f0-0901a3cc56ac
md"

#### Spoiler de una de las mejores partes de la materia"

# ╔═╡ 9a3657ee-5dc1-11eb-0e69-55693f3f39fe
md"
Supongamos que tenemos una funcion coseno $f(x)= cos(x)$  y un polinomio con la siguiente forma $p(x)=1-\frac{x^2}{2}$. ¿Qué pasa si los graficamos juntos?"

# ╔═╡ 17b5d528-5dc2-11eb-0694-2586b7b91b10
begin
fp(x) = 1 - x^2/2
plot(cos, -pi/2, pi/2,label="f(x)")
plot!(fp, -pi/2, pi/2,label="p(x)")


end

# ╔═╡ 52fcf29c-5dc2-11eb-082c-6b9c2590c1ae
md"
V
vemos que existe una zona donde ambos gráficos se superponen casi en su totalidad. ¿No nos creen? Coloquense sobre el grafico para ver el valores de ambos

Para estar más seguros vamos a hacer un zoom entre -0.5 y 0.5
"

# ╔═╡ 97a180a2-5dc2-11eb-3663-df7215a370a7
begin
	xlims!(-1,1)
	ylims!(-0.1,1.2)
end


# ╔═╡ 6a20b80e-5dc3-11eb-222c-2112df45c955
md"

Ahora podemos corroborar mejor que si entre -0.5 y 0.5 los valores son casi indistinguibles


Veamos que pasa ahora si graficamos $f(x)=seno(x)$ y la recta $p(x)=x$"

# ╔═╡ b4f5cdce-5dc3-11eb-3d5b-2b1cd4389582
begin
fp2(x) = x
plot(sin, -π/2 ,π,label="f(x)")
plot!(fp2, -π/2, π,label="p(x)")


end

# ╔═╡ b514cb16-5dc3-11eb-1a06-617c5b5184fe
md"

De nuevo vemos que en cierto entorno, en este caso en las cercanias del 0 ambas funciones son practicamente iguales. ¿Esto es casualidad?

"


# ╔═╡ 9ef36d18-67f7-11eb-0f73-09cfc4c3105b
url3 = "https://i.pinimg.com/736x/f5/ff/ff/f5ffffa9e9a729c3844fa8dc7f8a04ad.jpg";

# ╔═╡ af01e836-67f7-11eb-35ce-bfa57283a83e
Resource(url3)

# ╔═╡ a17a6130-67f8-11eb-26cf-ad0a0f90e609
md"

Lo que acabamos de utilizar son polinomios de Taylor, unos polinomios que nos permiten aproximar funciones utilizando polinomios que son simples de trabajar. Más adelante vamos a ver como calcularlos y que utilidad tienen. Para despedirnos vamos a mostrar otro , en este caso tenemos $f(x) = e^x$  y $p(x)=1+x - \frac{x^2}{2!}$  "

# ╔═╡ b5338196-5dc3-11eb-157e-85286754e367
begin
	fp3(x) = exp.(x)
	fp4(x) = 1+x+x^2 /factorial(2)
	plot(fp4, -1 ,1,label="f(x)")
	plot!(fp3, -1, 1,label="p(x)")


end

# ╔═╡ Cell order:
# ╠═a76f4600-55d3-11eb-0f6c-1d60f6cae0ed
# ╠═2e2ba646-5c34-11eb-1250-f7cd9e2b5764
# ╠═0e5215f8-5c34-11eb-399a-0f45b885c428
# ╟─80e98170-55cf-11eb-1728-0b9be9ede10c
# ╟─2e4c413e-55d0-11eb-0743-87da04abc000
# ╟─629dc678-5c36-11eb-205b-3f69bd55edcf
# ╠═26a66ba2-5c36-11eb-2d6b-85be51d9486d
# ╟─d9f5bfb0-55cd-11eb-1b0b-af39e7ae9d07
# ╠═75a25b96-5c34-11eb-2260-23d7d48e67ac
# ╟─ed9dc666-5c35-11eb-2abb-b332fea3eb30
# ╟─f7397ce2-5c35-11eb-0222-694f145baad3
# ╟─2be1c936-5cae-11eb-0511-55cac515b4de
# ╟─562d2078-5cae-11eb-2934-974dbccdab74
# ╟─5cb5ba8e-5cae-11eb-19bf-ebf44ea8f6a6
# ╠═8e6333ec-5cae-11eb-26c6-f3b094dab970
# ╟─08513d6e-5cf9-11eb-10fb-29fd8cd2dd68
# ╟─85df8462-5ca9-11eb-0b96-ed23e4415cb1
# ╟─ee082e2c-6716-11eb-1f0a-1fae0ed2f74a
# ╟─43d3ce80-5d90-11eb-1b5f-bf36a9dea97d
# ╠═01e8d45c-5d95-11eb-32a2-05703b43541a
# ╟─c9e2fcf2-5d96-11eb-2561-53b190a409d0
# ╟─55cf6280-55dd-11eb-117f-f1bf6a29565b
# ╟─ef349bd0-55eb-11eb-0b53-999cd0ef6167
# ╠═586b3184-5daa-11eb-3868-cf88404f1bf9
# ╟─86161db2-5db2-11eb-19b3-bbeeb5e98e3c
# ╟─a85efa00-55cf-11eb-26ae-ada91c1a547d
# ╟─b40b45ee-5ca4-11eb-3c06-ab084f0ded65
# ╠═92dc44fe-5c36-11eb-362e-5b973d643c25
# ╟─7de3a734-5ca6-11eb-314a-b965bb97844e
# ╟─e304e16e-5ca6-11eb-277a-cf504d496670
# ╠═eed2e39c-5ca6-11eb-0e5b-11de2ae16846
# ╟─d9af9350-55eb-11eb-0d0e-e1932621ab4d
# ╟─20a6b404-5da4-11eb-0664-c942ae7e07af
# ╟─4fb87c40-55ee-11eb-3c0c-e998b5972411
# ╠═0eeabf0e-5da5-11eb-3ba4-f31c5481eb49
# ╟─2b04a32a-5da4-11eb-2fb8-7fae9c509505
# ╟─727655e6-5caa-11eb-1893-3fce87151446
# ╟─3254f9f8-5cb0-11eb-0bef-1de90ded7c4c
# ╠═4336abb8-5cb0-11eb-2a99-07f1b6245f70
# ╠═4483dfd0-55ef-11eb-31da-31658529f814
# ╠═830b5508-5cac-11eb-241f-5103abeaee17
# ╠═712a3276-5c36-11eb-2c1b-353247409db1
# ╟─92d1188e-5bd9-11eb-0934-e59f8142ccde
# ╟─9e03a302-5da5-11eb-3ef3-bba22ba018fc
# ╟─64cc285a-5da7-11eb-0351-0bce87f950df
# ╠═77915aec-5da6-11eb-33b1-819e3ec8580d
# ╟─b420b010-5da7-11eb-146f-7112f516560f
# ╠═c33b39da-5da7-11eb-1f0d-a3106a1cbd00
# ╟─e1864d82-5bcf-11eb-04cc-c908a8bc0792
# ╟─bd351582-6717-11eb-2194-7dd2b34ec07c
# ╟─194e558c-5bd2-11eb-2c94-d90a9d3655c0
# ╟─f3bb80d4-5bd5-11eb-0e63-83ac5284c67e
# ╟─a4e57bf2-5c36-11eb-13a2-dbf774b4c79e
# ╟─40e6fec4-5c3d-11eb-1a3c-9bdec6e05121
# ╠═4a81d2f8-5c3d-11eb-2e62-1983b7938e8c
# ╟─1afba524-5cfe-11eb-36f0-63c0e68da0d7
# ╠═ae5d3120-5c36-11eb-28a7-8b225824fe58
# ╟─b29fea3e-5c36-11eb-2456-b17d52001aa4
# ╟─0c37373c-5cff-11eb-2f2f-978ac03a1c2d
# ╟─93d9bca0-5cff-11eb-117a-0715987e77d9
# ╠═bcb4a7ca-5cff-11eb-3894-878db1c7e609
# ╟─f2773e60-5cff-11eb-04ea-9d5b30afef65
# ╟─3a129cee-5d01-11eb-31a4-31f5f06fac14
# ╠═80f00182-5d02-11eb-2f61-897afe2fc02a
# ╟─ba7b9e20-5d02-11eb-0d99-c74a3127e1d9
# ╟─c8e3a9da-5d02-11eb-0027-dd18a728bad7
# ╟─df4a0b6a-5d02-11eb-0c5c-e75a1439c1d3
# ╠═3a63e190-5d03-11eb-2ab4-93e07cd28762
# ╟─52934520-55ef-11eb-2ca7-6bf9f9f2b5f9
# ╟─acb3e132-67f5-11eb-2de1-eff4dab3fe72
# ╟─f71fbffc-67f5-11eb-03c5-1bd7320c54e6
# ╠═247ff22a-5d04-11eb-2dee-63ff0393f281
# ╟─bdf7ddec-5d05-11eb-0799-6bad270ea692
# ╟─c6bb9f40-5d05-11eb-3096-579c534fa5af
# ╠═cc8167a0-5d05-11eb-1a70-f5c96dfac04d
# ╠═7ce90564-5d04-11eb-17f1-8dd00557cac1
# ╠═3adda8fa-5d04-11eb-13c6-55f5fe0f44ac
# ╟─596d15a6-5d06-11eb-3015-518510dec087
# ╟─6c1c3ed4-5d06-11eb-338f-d5e87025bcbe
# ╠═769956d0-5d06-11eb-1696-21f883bdab99
# ╠═da2060f6-5d04-11eb-3a60-03ee847395ad
# ╟─478929bc-5d04-11eb-304e-7b6a97f299da
# ╟─b605ea40-5d06-11eb-0079-11e8eb264144
# ╟─c53831ee-5d06-11eb-393c-d94c605714e6
# ╠═ce26374c-5d06-11eb-037f-09b672ab9bb8
# ╠═4ba74a02-5d05-11eb-3e4b-2dbe1f037dd7
# ╟─69c8c20c-5d05-11eb-32ea-51e02354fa0e
# ╠═5f4f30cc-5d05-11eb-1c2a-2fcd170295ef
# ╟─eacd154e-5da3-11eb-1bad-839fdff53ded
# ╟─86078f3c-5dbb-11eb-37b1-5d710b4b658e
# ╟─e26e74f2-5dbb-11eb-3395-15624d9b306e
# ╠═960f68a2-5dbb-11eb-2c1a-0d66db2695d0
# ╟─f963a8fe-5dbd-11eb-28b3-db46d5fb3638
# ╟─aaa91f74-5dbe-11eb-0634-3d4f3428cac9
# ╠═bdebb2b8-5dbe-11eb-040f-afbe83855334
# ╟─d3336728-5dbf-11eb-3c1d-79728396ef42
# ╟─b393562c-5dc0-11eb-1efa-69c1387081ba
# ╠═9495e74c-5dc0-11eb-1620-e5395a73a3cc
# ╟─c294b3a8-5dc0-11eb-07f0-0901a3cc56ac
# ╟─9a3657ee-5dc1-11eb-0e69-55693f3f39fe
# ╠═17b5d528-5dc2-11eb-0694-2586b7b91b10
# ╟─52fcf29c-5dc2-11eb-082c-6b9c2590c1ae
# ╠═97a180a2-5dc2-11eb-3663-df7215a370a7
# ╟─6a20b80e-5dc3-11eb-222c-2112df45c955
# ╠═b4f5cdce-5dc3-11eb-3d5b-2b1cd4389582
# ╟─b514cb16-5dc3-11eb-1a06-617c5b5184fe
# ╟─9ef36d18-67f7-11eb-0f73-09cfc4c3105b
# ╟─af01e836-67f7-11eb-35ce-bfa57283a83e
# ╟─a17a6130-67f8-11eb-26cf-ad0a0f90e609
# ╠═b5338196-5dc3-11eb-157e-85286754e367
