### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ aa0e0390-22cc-11eb-250e-d3273059cf0d
begin
	using Colors
	using LaTeXStrings
	using LinearAlgebra
	using Plots
	using PlutoUI
	using RowEchelon
	using StatsBase
	gr()
end;

# ╔═╡ bdbd61b0-22cc-11eb-03ab-1533954707a1
md"""
# Linear algebra in a nutshell

*Matt Helm*

#### Part I. Vectors & Scalars

To understand vectors and scalars, let's look at the definition of a *vector space* from *Wikipedia*:

> A vector space (also called a linear space) is a collection of objects called vectors, which may be added together and multiplied ("scaled") by numbers, called scalars. Scalars are often taken to be real numbers, but there are also vector spaces with scalar multiplication by complex numbers, rational numbers, or generally any field.

Let's start by looking at a graph of a two-dimensional vector space along with a vector originating from the origin. The vector below can be represented as

$\begin{bmatrix}2 \\2\end{bmatrix}$

where the first element in the vector represents the $x$ value of the end point and the second element represents the $y$ value of the end point.
"""

# ╔═╡ f00883f0-2422-11eb-1270-893bb1f86e9e
begin
	x_vec = [0; 2]
	y_vec = [0; 2]
	
	Plots.plot(
		x_vec,
		y_vec,
		legend=false,
		line=:arrow,
		framestyle=:origin,
		xlims=(-4,4),
		ylims=(-4,4)
	)
end

# ╔═╡ 3d88a832-2428-11eb-1c05-89570375ba09
md"""
We can see that **our vector is simply represented as a list of numbers.** Given that a vector is simply a list of numbers, we can represents all sorts of things as vectors. The vectors below represent the red, green, and blue (RGB) values for the particular shades of red, blue, and green that are displayed:
"""

# ╔═╡ 4b19060e-9edb-4eaf-8106-94ca74f6728c
md"""
$\begin{bmatrix}red \\ green \\ blue\end{bmatrix} = \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} = \ \ \textcolor{red}{\Huge\bullet}$

$\begin{bmatrix}red \\ green \\ blue\end{bmatrix} = \begin{bmatrix}75 \\ 200 \\ 0\end{bmatrix} = \ \ \textcolor{green}{\Huge\bullet}$

$\begin{bmatrix}red \\ green \\ blue\end{bmatrix} = \begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix} = \ \ \textcolor{blue}{\Huge\bullet}$
"""

# ╔═╡ dcab3fa0-2431-11eb-38ab-afa26c6aa82d
md"""
We could also use a vector to represent the prices of homes, in thousands:

$\begin{bmatrix}p_1 \\ p_2 \\ p_3\end{bmatrix} = \begin{bmatrix}275 \\ 300 \\ 295\end{bmatrix}$


Or, we could represent particular attributes of a car; perhaps, miles per gallon, the number of doors, and the price in thousands:

$\begin{bmatrix}mpg \\ doors \\ price\end{bmatrix} = \begin{bmatrix}33 \\ 4 \\ 35\end{bmatrix}$

So far, we've been writing our vectors as column vectors, represented vertically. We can also write them as row vectors, horizontally, like this: $\begin{bmatrix}275 & 300 & 295\end{bmatrix}$. This will be important when we begin looking at matrices.

#### Scalars

Vectors can be *scaled* by multiplying them by values called *scalars*. To see this in action, let's multiply the vector in our graph below by some scalar value and see what happens to it:

scalar: $(@bind scalar Slider(-3:3, default=1, show_value=true))
"""

# ╔═╡ 508222d0-2433-11eb-22c3-41bd4a6ce1d2
md"""

Original Vector: **[2 2]**

New Vector: **[$(2 * scalar) $(2 * scalar)]**
"""

# ╔═╡ 4fd22932-2432-11eb-19b8-7f94dbbab2c9
begin
	x_new = [0; 2 * scalar]
	y_new = [0; 2 * scalar]
	
	Plots.plot(
		x_new,
		y_new,
		legend=false,
		line=:arrow,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6)
	)
end

# ╔═╡ cf54d4a0-2432-11eb-0d70-9f17ebf00eba
md"""
You can see that we are simply multiplying each element in the vector by the value of the scalar. What's interesting about this scalar multiplication is that the only thing that changes about our vector when we multiply by a positive scalar is its length (we are simply *scaling* it up or down). When we multiply our vector by a negative scalar, its length changes *and* it also points in the opposite direction. When multiplying by zero, our vector simply becomes a point located at $(0, 0)$.

What about our vectors that represented colors? What happens if we multiply a vector $v_1$ that yields a color $c_1$ by some scalar value? Let's see:

scalar: $(@bind color_scalar Slider(0:5, show_value=true, default=1))
"""

# ╔═╡ b4ace0a0-2434-11eb-1691-317251748661
md"""
v₁: **[50 0 0]**

v₂: **[$(50*color_scalar) $(0*color_scalar) $(0*color_scalar)]**

c₁: $(RGB(50/255, 0/255, 0/255))

c₂: $(RGB(50*color_scalar/255, 0*color_scalar/255, 0*color_scalar/255))

Both vectors contain only one positive value, which is for the red color. As a result, as we scale the vector up, only the red value increases, resulting in an increasingly red color.

#### Vector Addition & Subtraction

Let's now turn our attention to vector addition and subtraction. Below we have two vectors as well as their sum:
"""

# ╔═╡ e21c5c10-2438-11eb-3e63-1b23b2dbf117
md"""
When adding our blue vector $v_1$ to the orange vector $v_2$, we end up with the green vector $v_{1 + 2}$. At first glance, it might not be apparent how we ended up with the green vector by adding the blue and orange vectors. However, watch what happens if instead of plotting the orange vector from the origin, we shift it so that it begins at the ending point of the blue vector (drag the slider all the way to the right):
"""

# ╔═╡ d8422a40-245f-11eb-114e-6f82d56119ed
@bind shifter1 Slider(0:0.1:2)

# ╔═╡ e28f6930-2438-11eb-0eda-c7014d930476
begin
	x_vec₂ = [0; -1]
	y_vec₂ = [0; 1]
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		label = L"v_{1}"
	)
	Plots.plot!(
		shifter1:-0.1:-1+shifter1,
		x -> shifter1 * 2 - x,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		line=:arrow,
		label = L"v_2"
	)
	Plots.plot!(
		x_vec + x_vec₂,
		y_vec + y_vec₂,
		line=:arrow,
		label = L"v_{1 + 2}"
	)
end

# ╔═╡ 281bfd20-243d-11eb-347f-dd5eaafe89d0
md"""
We can see that the end point of the orange vector is now exactly the same as the end point of the green vector, the sum of the two. It doesn't matter which vector you start with - you could start with the original orange vector and then plot the blue vector from its end point and you would again end up at the end point of the green vector (vector addition is commutative just like regular addition).

Vector subtraction works exactly as you would expect it to:
"""

# ╔═╡ e37cc7b2-243e-11eb-1a2d-232602694088
md"""
Because subtraction is the inverse of addition, the end point of our green vector is now where the origin of the orange vector would be if we plotted it such that it had the same end point as the blue vector. Go ahead and shift the orange vector once again to confirm this.

$(@bind shifter2 Slider(0:0.2:3))
"""

# ╔═╡ ecacd702-243c-11eb-22f8-594c293badcc
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		label = L"v_{1}"
	)
	Plots.plot!(
		shifter2:-0.1:-1+shifter2,
		x -> shifter2 * 1.33 - x,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		line=:arrow,
		label = L"v_2"
	)
	Plots.plot!(
		x_vec - x_vec₂,
		y_vec - y_vec₂,
		line=:arrow,
		label = L"v_{1 - 2}"
	)
end

# ╔═╡ cbdfe640-243f-11eb-0e2c-9fae4d039387
md"""
Let's quickly look at vector addition and subtraction with colors. Suppose we would like to add some red to a color represented by the vector $v_1$. We'll add a vector $v_2$ that contains a postive red value and zero for the green and blue values to obtain our new color represented by the vector $v_3$.
"""

# ╔═╡ cf1c6f45-48a5-477c-9b95-1b1cc516cb45
md"""
$v_{1} = \begin{bmatrix}100 \\ 30 \\ 75\end{bmatrix} = \ \ \textcolor[rgb]{0.39,0.12,0.29}{\Huge\bullet}$

$v_{2} = \begin{bmatrix}100 \\ 0 \\ 0\end{bmatrix} = \ \ \textcolor[rgb]{1,0,0}{\Huge\bullet}$

$v_{3} = \begin{bmatrix}200 \\ 30 \\ 75\end{bmatrix} = \ \ \textcolor[rgb]{0.78,0.12,0.29}{\Huge\bullet}$
"""

# ╔═╡ 65a2d2d0-25b5-11eb-3d1d-af3a757984c2
md"""
In this case, we used vector addition to add some more red to our original color! We can obviously perform the inverse of this and subtract $v_2$ from $v_3$ to end up with our original vector $v_1$.
"""

# ╔═╡ dafffd50-25b5-11eb-0c9e-1d75099b7ded
md"""
#### Norm

In this notebook we will explore only the *Euclidean norm* but readers should be aware that there is also a *Manhattan norm*. The Euclidean norm (or just *norm* as we will refer to it from here on) is defined as:

$\| x\| = \sqrt{\sum_{i=1}^{n} x_{i}^2}$

A vector's norm can be thought of as its length. For example:
"""

# ╔═╡ 403509c0-25b8-11eb-376c-8175fcb30b4a
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-3,3),
		ylims=(-3,3),
		label = L"v_{1}"
	)
	annotate!(1.7, 0.5, Plots.text(L"\Vert v_1 \Vert = \sqrt{2^2 + 2^2} = 2.8284", 11))
end

# ╔═╡ 9e440f10-25b9-11eb-2db2-6983d0e7eb07
md"""
The norm in this example can be easily verified via the Pythagorean Theorem.
"""

# ╔═╡ c8ebe652-267e-11eb-2461-8982b0df4a02
md"""
#### Distance

We can also make use of the norm to define the *Euclidean distance* between two vectors like so:

$dist(a,b) = \| a - b\|$

Revisiting our vectors from the addition example above, we see that $dist(v_1,v_2) = \| v_1 - v_2\| = 3.16$ while $dist(v_{1+2},v_2) = \| v_{1+2} - v_2\| = 2.83$. The resulting vector is *closer* to $v_2$ than the original vector $v_1$ Review the plot again and think about this as you view the vectors.
"""

# ╔═╡ 4dbe5240-2680-11eb-0ba3-47dfc5ce8307
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		label = L"v_{1}"
	)
	Plots.plot!(
		shifter1:-0.1:-1+shifter1,
		x -> shifter1 * 2 - x,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		line=:arrow,
		label = L"v_2"
	)
	Plots.plot!(
		x_vec + x_vec₂,
		y_vec + y_vec₂,
		line=:arrow,
		label = L"v_{1 + 2}"
	)
end

# ╔═╡ d259f6c0-2681-11eb-1a0c-c79fc34f1d25
md"""
Let's now look at an example of vector distance with our vectors that represent RGB values for different colors:
"""

# ╔═╡ e14f7399-81ef-46ab-88d1-42102d2db6b0
md"""
$v_{r} = \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} = \ \ \textcolor[rgb]{1,0,0}{\Huge\bullet}$

$v_{g} = \begin{bmatrix}75 \\ 200 \\ 0\end{bmatrix} = \ \ \textcolor[rgb]{0.29,0.78,0}{\Huge\bullet}$

$v_{o} = \begin{bmatrix}255 \\ 150 \\ 0\end{bmatrix} = \ \ \textcolor[rgb]{1,0.59,0}{\Huge\bullet}$
"""

# ╔═╡ d5c280ae-2682-11eb-3e9b-e91fee1a1ec1
md"""
Which of these vectors do you expect to be closest to the vector that represents red? Does orange *look* closer to red than green does? Let's compute the distances:

$dist(v_r,v_g) = 269.07$

$dist(v_r,v_o) = 150.0$

Indeed, $v_o$ is closer to $v_r$ than $v_g$ is!

> **An important note about computing vector distances**
>
> In the examples above, we used our vectors as-is when computing distances between them. That's fine when the unit of measurement represented by each element in the vectors is the same. However, if our vector has multiple units of measurement, we should probably *normalize* or *standardize* our vectors.
>
> Let's look at three vectors that contain information about three different houses where the first entry corresponds to the square footage figure, the second corresponds to the number of rooms, and the third corresonds to the price, in thousands.
>
> $house_1 = \begin{bmatrix}1650 \\ 4 \\ 258\end{bmatrix}$
>
> $house_2 = \begin{bmatrix}1500 \\ 2 \\ 235\end{bmatrix}$
>
> $house_3 = \begin{bmatrix}2025 \\ 4 \\ 315\end{bmatrix}$
>
> In this case, $dist(house_1,house_2) = 151.77$ while $dist(house_1,house_3) = 379.30$. As you can see, the magnitude of the square footage units has a disproportionate effect. The two 4-bedroom homes would probably be considered more equivalent in the eyes of most shoppers. Let's see what happens now when we transform the values into z-scores:
>
> $house_1 = \begin{bmatrix}1.14278 \\ -0.714709 \\ -0.428072\end{bmatrix}$
>
> $house_2 = \begin{bmatrix}1.14258 \\ -0.715816 \\ -0.426761\end{bmatrix}$
>
> $house_3 = \begin{bmatrix}1.14285 \\ -0.71432 \\ -0.428531\end{bmatrix}$
>
> Now, $dist(house_1,house_2) = 0.001727$ and $dist(house_1,house_3) = 0.00061$. The z-score transform gives the expected result!
"""

# ╔═╡ 411b8412-25b6-11eb-267e-a5ce2ffa77c8
md"""
#### Dot Product

The *dot product* of two vectors is defined as:

$x \cdot y = \sum_{i=1}^{n} x_{i}y_{i}$

This very simple operation allows us to do some very interesting things with vectors. 

* Suppose we have a vector $p$ that represents the prices of certain products, and another vector $q$ that represents quantities of those products. The dot product $p \cdot q$ yields the total cost of the products:

$p \cdot q = \begin{bmatrix}10 \\ 2 \\ 7\end{bmatrix} \cdot \begin{bmatrix}5 \\ 15 \\ 4\end{bmatrix} = 108$

* Suppose we have a vector $p$ that describes the probability of the occurrence of some events that are represented by the vector $e$. If the events represent cash flows, for example, the expected value is the dot product $p \cdot e$:

$p \cdot e = \begin{bmatrix}0.5 \\ 0.3 \\ 0.2\end{bmatrix} \cdot \begin{bmatrix}12 \\ 9 \\ 34\end{bmatrix} = 15.5$

#### Angles & Orthogonality

We can also check the *angle* (represented by $\theta$, "theta") between two vectors ($v_1$ and $v_2$) by dividing their dot product by the product of their norms, and then calculating the inverse cosine of the resulting value:

$\theta = arccos\left( \frac{v_1 \cdot v_2}{\| v_1\| \| v_2\|} \right)$
"""

# ╔═╡ c71deae0-25bf-11eb-1346-6521ce812c53
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		xlims=(-3,3),
		ylims=(-3,3),
		label = L"v_{1}"
	)
	Plots.plot!(
		[0; -2],
		[0; 2],
		line=:arrow,
		framestyle=:origin,
		xlims=(-4.5,4.5),
		ylims=(-3,3),
		label = L"v_{2}",
		xaxis=-4:4
	)
end

# ╔═╡ c063c820-25c2-11eb-25d2-e16795ddf3e0
md"""
In the above case, $\theta = 1.571$, or $90^{\circ}$ ($\theta$ is expressed in radians). Since the angle between the two vectors is $90^{\circ}$, the vectors are said to be **orthogonal** to one another. We can check that two vectors are orthogonal by simply taking their dot product - **if it is equal to zero, they are indeed orthogonal**. Expressing this in mathematical notation yields:

$a \cdot b = 0 \rightarrow a \perp b$

which simply states that, if the dot product of vectors $a$ and $b$ is equal to 0, then $a$ and $b$ are orthogonal.

We can find a vector that is orthogonal to another in a 2D space by utilizing the dot product and some simple algebra. For example, if given the following vector $a$, how can we find a vector $b$ that satisfies $a \perp b$?

$a = \begin{bmatrix}-2 \\ 2 \end{bmatrix}$

All we need to do is set up the equation $a \cdot b = 0$ and solve for $b$:

$-2b_1 + 2b_2 = 0$

In this case, there are an infinite number of solutions but let's just pick $b_1 = 2$ and $b_2 = 2$. You'll see that this indeed results in a dot product of zero and yields the same orthogonal vectors form the graph above.
"""

# ╔═╡ 33602bc0-28e3-11eb-2bec-0b1b4380cf9e
md"""
#### Cross Product

The cross product is another way to multiply two vectors. Rather than yielding a scalar value though, as the dot product does, the cross product yields a brand new vector that is actually orthogonal to the two vectors being multiplied. First, let's talk about **unit vectors**. A unit vector is simply a vector of length 1. Now that we know that, we can define the cross product as

$a\times b = \| a\| \|b\| sin(\theta) n$

where $n$ is the unit vector at right angles to both $a$ and $b$ and $\theta$ is the angle between $a$ and $b$. The plot below demonstrates this:
"""

# ╔═╡ 511aaf90-28e4-11eb-0a70-0bc42d4d9244
begin
	Plots.plot([0 0 0; 2 2 0], [0 0 0; 2 -2 0], [0 0 0; 0 0 8], linewidth = 1.5, labels = [L"a" L"b" L"a\times b"], camera=(20,20), xlabel="x", ylabel="y", zlabel="z", xlims=(-2,2), ylims=(-2,2))
	
end

# ╔═╡ 25d1a450-28e5-11eb-3162-cfa568dac8cc
md"""
Here we can see that

$a \times b = \begin{bmatrix}2 \\ 2\\ 0\end{bmatrix}\times \begin{bmatrix}-2 \\ 2 \\0\end{bmatrix} = \begin{bmatrix}0 \\ 0 \\8\end{bmatrix}$

which is indeed orthogonal to both $a$ and $b$.
"""

# ╔═╡ 71eb8ede-2526-11eb-06ed-6553035bfbcb
md"""
#### Linear Combinations & Linear Independence

From *StatTrek*:

> If one vector is equal to the sum of scalar multiples of other vectors, it is said to be a linear combination of the other vectors.
>
> For example, suppose $a = 2b + 3c$, as shown below.
>
> $\underbrace{\begin{bmatrix}11 \\ 16\end{bmatrix}}_a = 2\underbrace{\begin{bmatrix}1 \\ 2 \end{bmatrix}}_b + 3\underbrace{\begin{bmatrix}3 \\ 4 \end{bmatrix}}_c = \begin{bmatrix}2\times 1 + 3\times 3 \\ 2\times 2 + 3\times 4 \end{bmatrix}$
>
> Note that **2b** is a scalar multiple and **3c** is a scalar multiple. Thus, **a** is a linear combination of **b** and **c**.

Let's go back to the graph from the previous section and examine our vectors:
"""

# ╔═╡ e7d74100-2466-11eb-0d85-2b25048be7d8
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		label = L"v_{1}"
	)
	Plots.plot!(
		x_vec₂,
		y_vec₂,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		line=:arrow,
		label = L"v_2"
	)
	Plots.plot!(
		x_vec + x_vec₂,
		y_vec + y_vec₂,
		line=:arrow,
		label = L"v_{1 + 2}"
	)
end

# ╔═╡ 68014ffe-2467-11eb-0a54-a520349cd162
md"""
We know in this case that the green vector $v_{1 + 2}$ is a linear combination of $v_1$ and $v_2$ because

$1\underbrace{\begin{bmatrix}2 \\ 2 \end{bmatrix}}_{v_1} + 1\underbrace{\begin{bmatrix}-1 \\ 1 \end{bmatrix}}_{v_2} = \underbrace{\begin{bmatrix}1 \\ 3\end{bmatrix}}_{v_{1 + 2}}$

but what about vectors $v_1$ and $v_2$ by themselves? Is it possible to obtain $v_1$ via some linear combination of $v_2$? The answer is no because all we can do in this case is scale $v_2$; there is no third vector to combine it with (add to it) to arrive at $v_1$. In this case, we say that $v_1$ and $v_2$ are linearly *independent*.

Below is a very simple case where two vectors $v_a$ and $v_b$ are linearly *dependent* because we can easily obtain either vector by simply scaling the other:

$\underbrace{\begin{bmatrix}2 \\ 2 \end{bmatrix}}_{v_a} = -2\underbrace{\begin{bmatrix}-1 \\ -1 \end{bmatrix}}_{v_b}$

Confirm this visually by changing the value of the following scalar via the slider:

$(@bind scalar2 Slider(-3:3, show_value=true, default=1))
"""

# ╔═╡ f72e56a0-2468-11eb-0b47-056b10869e57
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		label = L"v_{a}"
	)
	Plots.plot!(
		[0; -1*scalar2],
		[0; -1*scalar2],
		line=:arrow,
		label = L"v_{b}"
	)
end

# ╔═╡ 442af3f2-2527-11eb-3163-b9a8e5ec875c
md"""
Let's now think about linear independence in terms of our color vectors. We'll start with three vectors representing the RGB values for red, blue, and purple. 
"""

# ╔═╡ cfb84b41-7b13-4250-aa4c-cddf78406f2b
md"""
$v_{1} = \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} = \ \ \textcolor[rgb]{1,0,0}{\Huge\bullet}$

$v_{2} = \begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix} = \ \ \textcolor[rgb]{0,0,1}{\Huge\bullet}$

$v_{3} = \begin{bmatrix}150 \\ 0 \\ 255\end{bmatrix} = \ \ \textcolor[rgb]{0.59,0,1}{\Huge\bullet}$
"""

# ╔═╡ f35ce6d0-2469-11eb-3ce8-3b4a11aa09cd
md"""
This set of vectors is linearly dependent because the purple vector is a linear combination of the red and blue vectors:

$0.5882\underbrace{\begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix}}_{red} + 1\underbrace{\begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix}}_{blue} = \underbrace{\begin{bmatrix}150 \\ 0 \\ 255\end{bmatrix}}_{purple}$

Let's swap purple for yellow now and see what happens:
"""

# ╔═╡ 53f799a0-2527-11eb-16f1-b76c2a95965a
md"""
$v_{1} = \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} = \ \ \textcolor[rgb]{1,0,0}{\Huge\bullet}$

$v_{2} = \begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix} = \ \ \textcolor[rgb]{0,0,1}{\Huge\bullet}$

$v_{3} = \begin{bmatrix}255 \\ 255 \\ 0\end{bmatrix} = \ \ \textcolor[rgb]{1,1,0}{\Huge\bullet}$
"""

# ╔═╡ 9377c940-2529-11eb-2bba-cdfb27757251
md"""
This set of vectors is linearly independent because you cannot create any one of them from a linear combination of the remaining two (without having to multiply by zero). In the section on matrices, we'll look at a couple of ways to prove this.
"""

# ╔═╡ 8a457c50-25b5-11eb-23f5-732125003943
md"""
#### Span & Basis

Now that we understand linear combinations and linear independence, we can understand the concepts of *span* and *basis*. Let's look at the following set of vectors $S$:

$S = \left\{ \begin{bmatrix}2 \\ 2\end{bmatrix},\begin{bmatrix}-1 \\ 1\end{bmatrix},\begin{bmatrix}1 \\ 3\end{bmatrix} \right\}$

These are the same vectors from above:
"""

# ╔═╡ 3ebab970-2863-11eb-35b3-dd7128f4ce15
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		label = L"s_{1}"
	)
	Plots.plot!(
		x_vec₂,
		y_vec₂,
		framestyle=:origin,
		xlims=(-6,6),
		ylims=(-6,6),
		line=:arrow,
		label = L"s_2"
	)
	Plots.plot!(
		x_vec + x_vec₂,
		y_vec + y_vec₂,
		line=:arrow,
		label = L"s_3"
	)
end

# ╔═╡ 46d723ee-2863-11eb-12f6-3f91e4d5bb50
md"""
**The span of this set is simply the set of all finite linear combinations of the elements (vectors) of $S$**. So, what are *all* of the finite linear combinations of the elements of this set? Let's just start by looking at a few (arbitrary) linear combinations of this set:

$\begin{align}
& s_4 = -2\begin{bmatrix}2 \\ 2\end{bmatrix} + -1\begin{bmatrix}-1 \\ 1\end{bmatrix} + -2\begin{bmatrix}1 \\ 3\end{bmatrix} = \begin{bmatrix}-5 \\ -11\end{bmatrix} \\

& s_5 = 3\begin{bmatrix}2 \\ 2\end{bmatrix} + -2\begin{bmatrix}-1 \\ 1\end{bmatrix} + -2\begin{bmatrix}1 \\ 3\end{bmatrix} = \begin{bmatrix}6 \\ -2\end{bmatrix} \\

& s_6 = 3\begin{bmatrix}2 \\ 2\end{bmatrix} + 2\begin{bmatrix}-1 \\ 1\end{bmatrix} + -1\begin{bmatrix}1 \\ 3\end{bmatrix} = \begin{bmatrix}3 \\ 5\end{bmatrix} \\

& s_7 = -2\begin{bmatrix}2 \\ 2\end{bmatrix} + 0.5\begin{bmatrix}-1 \\ 1\end{bmatrix} + 1.75\begin{bmatrix}1 \\ 3\end{bmatrix} = \begin{bmatrix}-2.75 \\ 1.75\end{bmatrix}
\end{align}$

Let's add these to our plot:
"""

# ╔═╡ 9d821240-2864-11eb-062c-0986e5ed9fc9
begin
	Plots.plot(
		x_vec,
		y_vec,
		line=:arrow,
		framestyle=:origin,
		xlims=(-11,11),
		ylims=(-11,11),
		label = L"s_{1}"
	)
	Plots.plot!(
		x_vec₂,
		y_vec₂,
		framestyle=:origin,
		line=:arrow,
		label = L"s_2"
	)
	Plots.plot!(
		x_vec + x_vec₂,
		y_vec + y_vec₂,
		line=:arrow,
		label = L"s_3"
	)
	Plots.plot!(
		[0; -5],
		[0; -11],
		line=:arrow,
		label = L"s_4"
	)
	Plots.plot!(
		[0; 6],
		[0; -2],
		line=:arrow,
		label = L"s_5"
	)
	Plots.plot!(
		[0; 3],
		[0; 5],
		line=:arrow,
		label = L"s_6"
	)
	Plots.plot!(
		[0; -2.75],
		[0; 1.75],
		line=:arrow,
		label = L"s_7"
	)
end

# ╔═╡ f8328dd0-2866-11eb-340b-e339ff07ed7a
md"""
We can see that each of our four linear combinations of the elements of $S$ above produces a vector in each of the four quadrants of our vector space. What does this suggest? Is it possible that with our set of vectors above we can span the entire $xy$ plane?

As it turns out, the span of any two non-parallel vectors in a two-dimensional space (like our $xy$ plane) is indeed the entire $xy$ plane. We actually don't even need $s_3$ to be able to span the entire $xy$ plane in this example since $s_3$ is just the sum of $s_1$ and $s_2$ (in other words, it's a linear combination of $s_1$ and $s_2$). 

Another way to state this is that $s_1$ and $s_2$ form a *basis* for our set $S$. **A basis is simply a collection of linearly-independent vectors!** Since $s_1$ and $s_2$ are the two linearly independent vectors in our set $S$, they are the basis of $S$.

Let's now add a third dimension to $s_1$ and $s_2$ and plot them in a three-dimensional space:

$s_1 = \begin{bmatrix}2 \\ 2 \\ 4\end{bmatrix}$
$s_2 = \begin{bmatrix}-1 \\ 1 \\ 0\end{bmatrix}$

All we have done here is add a third element to our vectors that represents the z value in our new 3D space:
"""

# ╔═╡ 266e7670-286a-11eb-3c6a-45d604f1a212
@bind camera Slider(-180:180)

# ╔═╡ c856be90-2868-11eb-0022-a73ee5be381e
begin
	f(x, y) = 1x + 1y
	# lines to vectors
	x_vec3d = [0 0; 2 -1]
	y_vec3d = [0 0; 2 1]
	z_vec = [0 0; f(2,2) f(-1,1)]

	# draw the plane
	wireframe(-3:1:3,-3:1:3,[f(x,y) for x in -3:1:3, y in -3:1:3], color=:purple, linewidth=0.5)
	plot!(x_vec3d, y_vec3d, z_vec, color = [:blue :orange], linewidth = 1.5, labels = ["s1" "s2"], camera=(camera,20), xlabel="x", ylabel="y", zlabel="z")
end

# ╔═╡ a8dc4cc0-28df-11eb-3dff-71363f7e8eb7
md"""
The idea of span is a little more clear in this example. The span of the set consisting of $s_1$ and $s_2$ is represented by the 2D plane (the purple grid) in our 3D space.
"""

# ╔═╡ ec87b2ae-28e5-11eb-1093-d1a92a1568a4
md"""
#### Orthonormal Vectors

A set of vectors is said to be *othonormal* if each vector in the set is orthogonal to all the others and is a unit vector. If the vectors also form a basis, they are said to form an **orthonormal basis**. The plot below shows three vectors that satisfy the conditions of an orthonormal basis.
"""

# ╔═╡ 2e6321c0-34ac-11eb-251c-a7b26523c080
@bind camera2 Slider(-180:180)

# ╔═╡ dd03ae2e-34ab-11eb-27b9-59084dd2582d
begin
	Plots.plot(
		[0 0 0; 1 0 0],
		[0 0 0; 0 0 1],
		[0 0 0; 0 1 0],
		color = [:blue :orange :green],
		linewidth = 1.5,
		labels = ["s1" "s2" "s3"],
		camera=(camera2,20),
		xlabel="x",
		ylabel="y",
		zlabel="z",
		xlims=(-2,2),
		ylims=(-2,2),
		zlims=(0,2)
	)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
RowEchelon = "af85af4c-bcd5-5d23-b03a-a909639aa875"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Colors = "~0.12.8"
LaTeXStrings = "~1.3.0"
Plots = "~1.30.2"
PlutoUI = "~0.7.39"
RowEchelon = "~0.2.1"
StatsBase = "~0.33.17"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9489214b993cd42d17f44c36e359bf6a7c919abf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "3a233eeeb2ca45842fe100e0413936834215abf5"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.4+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d0a61518267b44a70427c0b690b5e993a4f5fe01"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.30.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.RowEchelon]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f479526c4f6efcbf01e7a8f4223d62cfe801c974"
uuid = "af85af4c-bcd5-5d23-b03a-a909639aa875"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "a9e798cae4867e3a41cae2dd9eb60c047f1212db"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.6"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "2bbd9f2e40afd197a1379aef05e0d85dba649951"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2c11d7290036fe7aac9038ff312d3b3a2a5bf89e"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.4.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "642f08bf9ff9e39ccc7b710b2eb9a24971b52b1a"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.17"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "9abba8f8fb8458e9adf07c8a2377a070674a24f1"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.8"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╠═aa0e0390-22cc-11eb-250e-d3273059cf0d
# ╟─bdbd61b0-22cc-11eb-03ab-1533954707a1
# ╟─f00883f0-2422-11eb-1270-893bb1f86e9e
# ╟─3d88a832-2428-11eb-1c05-89570375ba09
# ╟─4b19060e-9edb-4eaf-8106-94ca74f6728c
# ╟─dcab3fa0-2431-11eb-38ab-afa26c6aa82d
# ╟─508222d0-2433-11eb-22c3-41bd4a6ce1d2
# ╟─4fd22932-2432-11eb-19b8-7f94dbbab2c9
# ╟─cf54d4a0-2432-11eb-0d70-9f17ebf00eba
# ╟─b4ace0a0-2434-11eb-1691-317251748661
# ╟─e28f6930-2438-11eb-0eda-c7014d930476
# ╟─e21c5c10-2438-11eb-3e63-1b23b2dbf117
# ╟─d8422a40-245f-11eb-114e-6f82d56119ed
# ╟─281bfd20-243d-11eb-347f-dd5eaafe89d0
# ╟─ecacd702-243c-11eb-22f8-594c293badcc
# ╟─e37cc7b2-243e-11eb-1a2d-232602694088
# ╟─cbdfe640-243f-11eb-0e2c-9fae4d039387
# ╟─cf1c6f45-48a5-477c-9b95-1b1cc516cb45
# ╟─65a2d2d0-25b5-11eb-3d1d-af3a757984c2
# ╟─dafffd50-25b5-11eb-0c9e-1d75099b7ded
# ╟─403509c0-25b8-11eb-376c-8175fcb30b4a
# ╟─9e440f10-25b9-11eb-2db2-6983d0e7eb07
# ╟─c8ebe652-267e-11eb-2461-8982b0df4a02
# ╟─4dbe5240-2680-11eb-0ba3-47dfc5ce8307
# ╟─d259f6c0-2681-11eb-1a0c-c79fc34f1d25
# ╟─e14f7399-81ef-46ab-88d1-42102d2db6b0
# ╟─d5c280ae-2682-11eb-3e9b-e91fee1a1ec1
# ╟─411b8412-25b6-11eb-267e-a5ce2ffa77c8
# ╟─c71deae0-25bf-11eb-1346-6521ce812c53
# ╟─c063c820-25c2-11eb-25d2-e16795ddf3e0
# ╟─33602bc0-28e3-11eb-2bec-0b1b4380cf9e
# ╟─511aaf90-28e4-11eb-0a70-0bc42d4d9244
# ╟─25d1a450-28e5-11eb-3162-cfa568dac8cc
# ╟─71eb8ede-2526-11eb-06ed-6553035bfbcb
# ╟─e7d74100-2466-11eb-0d85-2b25048be7d8
# ╟─68014ffe-2467-11eb-0a54-a520349cd162
# ╟─f72e56a0-2468-11eb-0b47-056b10869e57
# ╟─442af3f2-2527-11eb-3163-b9a8e5ec875c
# ╟─cfb84b41-7b13-4250-aa4c-cddf78406f2b
# ╟─f35ce6d0-2469-11eb-3ce8-3b4a11aa09cd
# ╟─53f799a0-2527-11eb-16f1-b76c2a95965a
# ╟─9377c940-2529-11eb-2bba-cdfb27757251
# ╟─8a457c50-25b5-11eb-23f5-732125003943
# ╟─3ebab970-2863-11eb-35b3-dd7128f4ce15
# ╟─46d723ee-2863-11eb-12f6-3f91e4d5bb50
# ╟─9d821240-2864-11eb-062c-0986e5ed9fc9
# ╟─f8328dd0-2866-11eb-340b-e339ff07ed7a
# ╟─266e7670-286a-11eb-3c6a-45d604f1a212
# ╟─c856be90-2868-11eb-0022-a73ee5be381e
# ╟─a8dc4cc0-28df-11eb-3dff-71363f7e8eb7
# ╟─ec87b2ae-28e5-11eb-1093-d1a92a1568a4
# ╟─2e6321c0-34ac-11eb-251c-a7b26523c080
# ╟─dd03ae2e-34ab-11eb-27b9-59084dd2582d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
