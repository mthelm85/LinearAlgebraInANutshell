### A Pluto.jl notebook ###
# v0.12.16

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

# ╔═╡ aa0e0390-22cc-11eb-250e-d3273059cf0d
begin
	using Pkg
	Pkg.activate(".")
	using Colors
	using LaTeXStrings
	using LinearAlgebra
	using Plots
	using PlutoUI
	using PyPlot
	using RowEchelon
	using StatsBase
	pyplot()
end

# ╔═╡ bdbd61b0-22cc-11eb-03ab-1533954707a1
md"""
# Linear algebra in a nutshell

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

# ╔═╡ bbcaae92-242e-11eb-0402-776eb6fc951b
html"""
<table class="no-border">
<tbody>
<tr>
<td>$\begin{bmatrix}red \\ green \\ blue\end{bmatrix} = \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} =$</td>
<td class="red"></td>
</tr>
<tr>
<td>$\begin{bmatrix}red \\ green \\ blue\end{bmatrix} = \begin{bmatrix}75 \\ 200 \\ 0\end{bmatrix} =$</td>
<td class="green"></td>
</tr>
<tr>
<td>$\begin{bmatrix}red \\ green \\ blue\end{bmatrix} = \begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix} =$</td>
<td class="blue"></td>
</tr>
</tbody>
</table>

<style>
.no-border {
	border-width: 0px;
}
.blue {
	background-color: rgb(0, 0, 255);
}
.green {
	background-color: rgb(75,200,0);
}
.red {
	background-color: rgb(255,0,0);
}
</style>
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

# ╔═╡ f12c92de-2525-11eb-051e-fd96402b22fb
html"""
<table class="no-border">
<tbody>
<tr>
<td>$v_1 = \begin{bmatrix}100 \\ 30 \\ 75\end{bmatrix} =$</td>
<td class="plum"></td>
</tr>
<tr>
<td>$v_2 = \begin{bmatrix}100 \\ 0 \\ 0\end{bmatrix} =$</td>
<td class="brown"></td>
</tr>
<tr>
<td>$v_3 = \begin{bmatrix}200 \\ 30 \\ 75\end{bmatrix} =$</td>
<td class="candy"></td>
</tr>
</tbody>
</table>

<style>
.plum {
	background-color: rgb(100, 30, 75);
}
.brown {
	background-color: rgb(100,0,0);
}
.candy {
	background-color: rgb(200,30,75);
}
table, th, td {
  border: 1px solid white;
}
</style>
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

# ╔═╡ 979db070-2682-11eb-080d-cb5b42f5c382
html"""
<table class="no-border">
<tbody>
<tr>
<td>$v_r= \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} =$</td>
<td class="red"></td>
</tr>
<tr>
<td>$v_g = \begin{bmatrix}75 \\ 200 \\ 0\end{bmatrix} =$</td>
<td class="green"></td>
</tr>
<tr>
<td>$v_o = \begin{bmatrix}255 \\ 150 \\ 0\end{bmatrix} =$</td>
<td class="orange"></td>
</tr>
</tbody>
</table>

<style>
.orange {
	background-color: rgb(255,150,0);
}
</style>
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
> $house_1 = \begin{bmatrix}1500 \\ 2 \\ 235\end{bmatrix}$
>
> $house_1 = \begin{bmatrix}2025 \\ 4 \\ 315\end{bmatrix}$
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
	Plots.plot([0 0 0; 2 2 0], [0 0 0; -2 2 0], [0 0 0; 0 0 8], linewidth = 1.5, labels = [L"a" L"b" L"a\times b"], camera=(20,20), xlabel="x", ylabel="y", zlabel="z", xlims=(-2,2), ylims=(-2,2))
	
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

# ╔═╡ fd4c8ed2-2526-11eb-01f1-611f80a82aa6
html"""
<table class="no-border">
<tbody>
<tr>
<td>$v_1 = \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} =$</td>
<td class="red"></td>
</tr>
<tr>
<td>$v_2 = \begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix} =$</td>
<td class="blue"></td>
</tr>
<tr>
<td>$v_3 = \begin{bmatrix}150 \\ 0 \\ 255\end{bmatrix} =$</td>
<td class="purple"></td>
</tr>
</tbody>
</table>

<style>
.purple {
	background-color: rgb(150,0,255);
}
</style>
"""

# ╔═╡ f35ce6d0-2469-11eb-3ce8-3b4a11aa09cd
md"""
This set of vectors is linearly dependent because the purple vector is a linear combination of the red and blue vectors:

$0.5882\underbrace{\begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix}}_{red} + 1\underbrace{\begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix}}_{blue} = \underbrace{\begin{bmatrix}150 \\ 0 \\ 255\end{bmatrix}}_{purple}$

Let's swap purple for yellow now and see what happens:
"""

# ╔═╡ 53f799a0-2527-11eb-16f1-b76c2a95965a
html"""
<table class="no-border">
<tbody>
<tr>
<td>$v_1 = \begin{bmatrix}255 \\ 0 \\ 0\end{bmatrix} =$</td>
<td class="red"></td>
</tr>
<tr>
<td>$v_2 = \begin{bmatrix}0 \\ 0 \\ 255\end{bmatrix} =$</td>
<td class="blue"></td>
</tr>
<tr>
<td>$v_3 = \begin{bmatrix}255 \\ 255 \\ 0\end{bmatrix} =$</td>
<td class="yellow"></td>
</tr>
</tbody>
</table>

<style>
.yellow {
	background-color: rgb(255,255,0);
}
</style>
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
		label = L"s_5"
	)
	Plots.plot!(
		[0; -2.75],
		[0; 1.75],
		line=:arrow,
		label = L"s_5"
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

# ╔═╡ Cell order:
# ╟─aa0e0390-22cc-11eb-250e-d3273059cf0d
# ╟─bdbd61b0-22cc-11eb-03ab-1533954707a1
# ╟─f00883f0-2422-11eb-1270-893bb1f86e9e
# ╟─3d88a832-2428-11eb-1c05-89570375ba09
# ╟─bbcaae92-242e-11eb-0402-776eb6fc951b
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
# ╟─f12c92de-2525-11eb-051e-fd96402b22fb
# ╟─65a2d2d0-25b5-11eb-3d1d-af3a757984c2
# ╟─dafffd50-25b5-11eb-0c9e-1d75099b7ded
# ╟─403509c0-25b8-11eb-376c-8175fcb30b4a
# ╟─9e440f10-25b9-11eb-2db2-6983d0e7eb07
# ╟─c8ebe652-267e-11eb-2461-8982b0df4a02
# ╟─4dbe5240-2680-11eb-0ba3-47dfc5ce8307
# ╟─d259f6c0-2681-11eb-1a0c-c79fc34f1d25
# ╟─979db070-2682-11eb-080d-cb5b42f5c382
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
# ╟─fd4c8ed2-2526-11eb-01f1-611f80a82aa6
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
