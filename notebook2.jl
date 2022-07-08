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

# ╔═╡ 93d1e3b0-29a9-11eb-0033-b9b6a0dbc950
begin
	using Colors
	using LaTeXStrings
	using LinearAlgebra
	using Plots
	using PlutoUI
	using PyPlot
	using RowEchelon
	using StatsBase
	pyplot()
end;

# ╔═╡ abe4ea12-29a9-11eb-0767-6fb6acc4f885
md"""
# Linear algebra in a nutshell

*Matt Helm*

#### Part II. Matrices

Now that we understand vectors, understanding matrices will be much easier. In fact, a vector is simply a matrix with one of its dimensions equaling 1. To understand this, let's first look at a $2\times 3$ matrix that we'll call $M$:

$M = \begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix}$

Our matrix $M$ is a $2\times 3$ matrix because it has **2 rows** and **3 columns**. In Part I on vectors, we learned that vectors can be written as row vectors or column vectors. A row vector is a $1\times n$ matrix and a column vector is an $m\times 1$ matrix.

Just as vectors can serve as representations for any number of things, so can matrices. In fact, matrices are often just collections of vectors as we'll see soon.
"""

# ╔═╡ 24d0c0e0-2a6b-11eb-2c46-412bbe82db5a
md"""
#### Transpose

When we transpose a matrix, we simply reshape it. For example, the transpose of our matrix $M$ above, denoted $M^T$ or $M'$ is:

$M^T = \begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix}^T = \begin{bmatrix}
1 & 4\\
2 & 5\\
3 & 6
\end{bmatrix}$

Our $2\times 3$ matrix is now a $3\times 2$ matrix.Transposing row vectors turns them into column vectors, and vice versa.

#### Norm

We can compute the norm of a matrix as

$\| A \| = \sqrt{\sum_{i=1}^m \sum_{j=1}^n A_{ij}^2}$

which, as is the case with vectors, is simply the squareroot of the sum of the squares of its entries. For example,

$M = \begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix} \rightarrow
\| M \| = 9.54$

#### Matrix Addition

We can add together two matrices of the same dimensions by simply summing their corresponding elements:

$\begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix} + \begin{bmatrix}
6 & 5 & 4\\
3 & 2 & 1
\end{bmatrix} = \begin{bmatrix}
7 & 7 & 7\\
7 & 7 & 7
\end{bmatrix}$
"""

# ╔═╡ 96a2c7e0-29b2-11eb-0e54-bd882d690760
md"""
#### Scalar Multiplication

Just as with vectors, we can multiply a matrix by a scalar:

$-2\begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix} = \begin{bmatrix}
-2 & -4 & -6\\
-8 & -10 & -12
\end{bmatrix}$

#### Matrix-Matrix Multiplication

We can multiply a matrix by another matrix *as long as their dimensions are compatible*. To perform the multiplication $AB$, the number of columns in $A$ must equal the number of rows in $B$. For example, we can perform the multiplication

$AB = \begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix}\begin{bmatrix}
3 & 2\\
1 & 6\\
5 & 4
\end{bmatrix} = \begin{bmatrix}
20 & 26\\
47 & 62
\end{bmatrix}$

because we are multiplying a $2\times 3$ matrix by a $3\times 2$ matrix. This results in a $2\times 2$ matrix. However, we would not be able to multiply the two matrices below

$S = \begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix}F = \begin{bmatrix}
6 & 5 & 4\\
3 & 2 & 1
\end{bmatrix}$

In general:

$A_{m\times p}B_{p\times n} = C_{m\times n}$

We can see from this that the number of columns of the first matrix always has to be equal to the number of rows of the second matrix in order for multiplication to take place. We can also see from this that, unlike scalar multiplication, matrix multiplication is not commutative. In other words, $AB \neq BA$.

The procedure for multiplying the above two matrices is as follows:

$AB = \begin{bmatrix}
1 & 2 & 3\\
4 & 5 & 6
\end{bmatrix}\begin{bmatrix}
3 & 2\\
1 & 6\\
5 & 4
\end{bmatrix} = \begin{bmatrix}
1\times 3 + 2\times 1 + 3\times 5 & 1\times 2 + 2\times 6 + 3\times 4\\
4\times 3 + 5\times 1 + 6\times 5 & 4\times 2 + 5\times 6 + 6\times 4
\end{bmatrix}$
"""

# ╔═╡ fc1ef9fe-29b5-11eb-09dc-a39f86544efc
md"""
#### Matrix-Vector Multiplication

Given that vectors are matrices, we can multiply a matrix by a vector as well. If we have the matrix

$M = \begin{bmatrix}
-5 & 2 & -1\\
-6 & 2 & -2
\end{bmatrix}$

and the vector

$v = \begin{bmatrix}
1 \\ 2 \\ -2
\end{bmatrix}$

we can multiply them since the dimensions are compatible:

$Mv = \begin{bmatrix}
-5 & 2 & -1\\
-6 & 2 & -2
\end{bmatrix}\begin{bmatrix}
1 \\ 2 \\ -2
\end{bmatrix} =
\begin{bmatrix}
1 \\ 2
\end{bmatrix}$

This result is very interesting. We can see that multiplying our matrix $M$ by our vector $v$ resulted in a vector, of length 2. In general, $M_{m\times n}v_{n\times 1} = y_{m\times 1}$. What does this look like if we plot our vector before and after the multiplication? Let's see:
"""

# ╔═╡ 6f18c8c0-2a69-11eb-0b27-83756d9e79b3
@bind camera Slider(0:90, default=45)

# ╔═╡ 39485fc0-2a65-11eb-14d2-fddb2c9c1943
begin
	Plots.plot(
		[0, 0, 1],
		[0, 0, 2],
		[0, 0, -2],
		xlims=(-3,3),
		ylims=(-3,3),
		zlims=(-3,3),
		xlabel="x",
		ylabel="y",
		zlabel="z",
		label="Before"
	)
	Plots.plot!(
		[0, 1],
		[0, 2],
		label="After",
		camera=(camera,20)
	)
end

# ╔═╡ 9d9d8190-2a69-11eb-347b-a52f771283af
md"""
First, we can see that the $z$ value is now 0 for all values of $x$ and $y$; it now only requires a 2D vector space for visualization. The matrix-vector multiplication effectively transformed our vector from a 3-vector to a 2-vector. It essentially projected our vector onto a 2D plane. If you can imagine shining a light from underneath the original blue vector, the orange vector is the shadow that the original vector would cast.

This should be a bit of a revelation. Our matrix in this case is acting like a function on our vector. In function notation, we would write this as $f: R^3 \rightarrow R^2$. Our function $f$ is a vector-valued function that operates on a 3-vector and returns a 2-vector and is represented by the matrix $M$. Specifically, $f(v) = Mv$.

Let's look at some more geometric transformations that can be obtained by multiplying matrices by vectors.

**Dilation**

Suppose we have the following *diagonal matrix*:

$D = \begin{bmatrix}
1 & 0\\
0 & 2
\end{bmatrix}$

Let's multiply $Dv$ where $v$ is the column vector

$v = \begin{bmatrix}
1 \\ 2\
\end{bmatrix}$
"""

# ╔═╡ b2b07ed0-2a9f-11eb-1c91-558277788da6
begin
	Plots.plot(
		[0, 1],
		[0, 2],
		line=:arrow,
		framestyle=:origin,
		xlims=(-5,5),
		ylims=(-5,5),
		label=L"v"
	)
	Plots.plot!(
		[0, 1],
		[0, 4],
		line=:arrow,
		label=L"Dv"
	)
end

# ╔═╡ c24f84d0-2a9f-11eb-09cf-91348d914c46
md"""
This transformation effectively stretched our original vector outward and upward; it is now longer than it was before and is at a steeper angle.

**Rotation**

Suppose we have a matrix $R$ that is defined as:

$R = \begin{bmatrix}
cos(\theta) & -sin(\theta)\\
sin(\theta) & cos(\theta)
\end{bmatrix}$

where $\theta$ represents some value in radians. If we multiply $Rv$, we effectively *rotate* $v$ by $\theta$:
"""

# ╔═╡ d0a978f2-2aa5-11eb-0bf4-851cec6ae342
begin
	Plots.plot(
		[0, 1],
		[0, 2],
		line=:arrow,
		framestyle=:origin,
		xlims=(-4.3,4.3),
		ylims=(-3,3),
		label=L"v"
	)
	Plots.plot!(
		[0, -2],
		[0, 1],
		line=:arrow,
		label=L"Rv"
	)
end

# ╔═╡ 30ca8ad0-2aa6-11eb-2a0f-250459a09553
md"""
In this case, we rotated $v$ counter-clockwise by $\approx 1.5708$ radians (90 degrees).

**Reflection**

Let's look at another matrix $M$ defined as:

$M = \begin{bmatrix}
cos(2\theta) & sin(2\theta)\\
sin(2\theta) & -cos(2\theta)
\end{bmatrix}$

Multiplying $M$ by $v$ will result in a reflection of $v$:
"""

# ╔═╡ 2aea1120-2aa7-11eb-37c5-03db9233b9cd
begin
	Plots.plot(
		[0, 1],
		[0, 2],
		line=:arrow,
		framestyle=:origin,
		xlims=(-4.3,4.3),
		ylims=(-3,3),
		label=L"v"
	)
	Plots.plot!(
		[0, -1],
		[0, 2],
		line=:arrow,
		label=L"Mv"
	)
end

# ╔═╡ 2cdd0780-2aa7-11eb-1d9c-59df3bb0a990
md"""
In this case I again chose a value of $\theta = 1.5708$ to perform a $90^\circ$ reflection.
"""

# ╔═╡ bcec39ce-35b6-11eb-1e7d-793f625b0a29
md"""
#### Identity Matrix

An identity matrix is a square matrix (i.e. it has the same number of rows as columns) with ones on the main diagonal, and zeros everywhere else. It looks like this:

$I = \begin{bmatrix}
1 & 0 & 0\\
0 & 1 & 0\\
0 & 0 & 1
\end{bmatrix}$

What makes the identity matrix interesting is that, when multiplied by another matrix of compatible dimesnions, the result is the other matrix. In other words:

$I_{m}A = AI_{n} = A$

For example,

$
\begin{bmatrix}
1 & 0 & 0\\
0 & 1 & 0\\
0 & 0 & 1
\end{bmatrix}\times 
\begin{bmatrix}
3 & 1\\
0 & 2\\
-5 & 4
\end{bmatrix} =
\begin{bmatrix}
3 & 1\\
0 & 2\\
-5 & 4
\end{bmatrix}$

When the identity matrix is the product of two square matrices, the two matrices are said to be the *inverse* of each other.

#### Inverse

The inverse of a scalar $n$ is $\frac{1}{n}$. $\frac{1}{n}$ can also be written as $n^{-1}$. For a matrix $M$, we write the inverse of $M$ as $M^{-1}$. It's important to note that it's never written as a fraction since **you can never divide by a matrix**. For a matrix to be invertible, it must be square. That is, **it must have the same number of rows as it has columns**. Furthermore, if a matrix $A$ is invertible, there must be a matrix $B$ that satisfies $AB = BA = I$ where $I$ is the identity matrix.

For a $2\times 2$ matrix $U$, we compute the inverse as follows:

$U^{-1} =
\begin{bmatrix}
4 & 7\\
2 & 6\end{bmatrix}^{-1} =
\frac{1}{(4\times 6) - (7\times 2)}\begin{bmatrix}
6 & -7\\
-2 & 4\end{bmatrix} =
\frac{1}{10}\begin{bmatrix}
6 & -7\\
-2 & 4\end{bmatrix} =
\begin{bmatrix}
0.6 & -0.7\\
-0.2 & 0.4\end{bmatrix}$

Generally, the inverse of a $2\times 2$ matrix is computed as:

$\begin{bmatrix}
a & b\\
c & d\end{bmatrix}^{-1} =
\frac{1}{ad - bc}\begin{bmatrix}
d & -b\\
-c & a\end{bmatrix}$

Note that, for a $2\times 2$ matrix, $ad - bc$ is called **the determinant** of the matrix. If the determinant of a matrix is zero, it is non-invertible as we cannot divide by zero.
"""

# ╔═╡ 70475210-2b37-11eb-285a-03eab26f3214
md"""
#### Checking Linear Independence With Matrices

In Part I on vectors, we learned about the concept of linear independence. We'll now explore how to check if a collection of vectors is linearly independent. First, suppose we have three vectors $v_1, v_2$ and $v_3$:

$v_1 = \begin{bmatrix}
2\\4\\2\end{bmatrix}
v_2 = \begin{bmatrix}
4\\6\\4\end{bmatrix}
v_3 = \begin{bmatrix}
2\\12\\2\end{bmatrix}$

We can express these vectors as a matrix $V$ where each row consists of one of the above vectors:

$V = \begin{bmatrix}
2 & 4 & 2\\
4 & 6 & 4\\
2 & 12 & 2\end{bmatrix}$
"""

# ╔═╡ 7e00b090-2cd6-11eb-04c9-4d605cac24ae
md"""
#### Guassian Elimination

One way to test for linear independence is to use an algorithm known as *Gaussian elimination*. The goal is simple: if, using the rules of Gaussian elmination, we are able to make one of the rows of our matrix all zeros, the vectors are linearly dependent. If we cannot make one of the rows all zeros, the vectors are linearly independent. So, what are the rules?

* We can swap two rows
* We can scale a row by a non-zero number
* We can add a multiple of one row to another

In order to give ourselves a better understanding of where to start, it's important to note that Gaussian elimination can be used to convert a matrix into **reduced row echelon form**. A matrix is said to be in reduced row echelon form if all of the following conditions hold true:

* All rows consisting of only zeroes are at the bottom
* The leading coefficient (also called the pivot) of a nonzero row is always strictly to the right of the leading coefficient of the row above it
* The leading entry in each nonzero row must be 1
* Each column containing a leading 1 must have zeros in all its other entries

Let's work through this with our matrix $V$ from above:

1. We know we want the first entry to be 1, so we can **multiply the first row by $\frac{1}{2}$**:

$\begin{bmatrix}
\frac{1}{2}(2) & \frac{1}{2}(4) & \frac{1}{2}(2)\\
4 & 6 & 4\\
2 & 12 & 2\end{bmatrix} = 
\begin{bmatrix}
1 & 2 & 1\\
4 & 6 & 4\\
2 & 12 & 2\end{bmatrix}$

2. Now, we want the first element of the second row to be zero, so we can **multiply -4 by row 1, and add the product to row 2**:

$\begin{bmatrix}
1 & 2 & 1\\
(-4\times 1) + 4 & (-4\times 2) + 6 & (-4\times 1) + 4\\
2 & 12 & 2\end{bmatrix} = 
\begin{bmatrix}
1 & 2 & 1\\
0 & -2 & 0\\
2 & 12 & 2\end{bmatrix}$

3. Next, we know that we also need the first element of row 3 to be zero, so let's take care of that by **multiplying row 1 by -2, and adding the product to row 3**:

$\begin{bmatrix}
1 & 2 & 1\\
0 & -2 & 0\\
(-2\times 1) + 2 & (-2\times 2) + 12 & (-2\times 1) + 2\end{bmatrix} = 
\begin{bmatrix}
1 & 2 & 1\\
0 & -2 & 0\\
0 & 8 & 0\end{bmatrix}$

4. At this point, we're getting closer but we still need the first non-zero entry of each row to be 1. For row 2, we need to multiply it by $-\frac{1}{2}$:

$\begin{bmatrix}
1 & 2 & 1\\
-\frac{1}{2}(0) & -\frac{1}{2}(-2) & -\frac{1}{2}(0)\\
0 & 8 & 0\end{bmatrix} = 
\begin{bmatrix}
1 & 2 & 1\\
0 & 1 & 0\\
0 & 8 & 0\end{bmatrix}$

5. Now, we need to make the 8 in row 3 a zero. That's easy enough by simply multiplying row 2 by -8 and subtracting it from row 3:

$\begin{bmatrix}
1 & 2 & 1\\
0 & 1 & 0\\
0 - (-8\times 0) & 1 - (-8\times 1) & 0 - (-8\times 0)\end{bmatrix} =
\begin{bmatrix}
1 & 2 & 1\\
0 & 1 & 0\\
0 & 0 & 0\end{bmatrix}$

6. Finally, we know at this point that **our vectors are linearly dependent because row 3 consists of all zeros**. However, let's perform one final operation to get our matrix into reduced row echelon form:

$\begin{bmatrix}
(-2\times 0) + 1 & (-2\times 1) + 2 & (-2\times 0) + 1\\
0 & 1 & 0\\
0 & 0 & 0\end{bmatrix} =
\begin{bmatrix}
1 & 0 & 1\\
0 & 1 & 0\\
0 & 0 & 0\end{bmatrix}$

If all this seems complicated, don't worry. Fortunately, we use computers to do this kind of thing and we make use of algorithms such as the [Gram-Schmidt algorithm](https://en.wikipedia.org/wiki/Gram%E2%80%93Schmidt_process).
"""

# ╔═╡ 09dfdfe0-3809-11eb-31a0-79e449c89b8a
md"""
#### Matrix Rank

We know now that the rows of a matrix are vectors and we know how to check for linear indepence among rows. With this information, we can define the **rank** of a matrix. 
> The rank of a matrix is defined as 
> * the maximum number of linearly independent column vectors in the matrix or
> * the maximum number of linearly independent row vectors in the matrix.

It turns out that both definitions are equivalent. For our matrix $V$ from above, we would say that its rank is 2, since there were only 2 non-zero rows left after reducing it to row-echelon form.
"""

# ╔═╡ 1481a280-2d91-11eb-1177-39f3314ae707
md"""
#### Systems of Linear Equations

In addition to checking for linear independence, we can use Gaussian elimination to solve systems of linear equations. The process is nearly identical but we add an additional colun to the matrix to form what is referred to as an *augmented matrix*. The additional column represents the solution to each equation. Let's look at a simple example. Suppose we have the following system of linear equations:

$1x + 3y + 1z = 9$

$1x + 1y + 1z = 1$

$3x + 11y + 5z = 35$

We can express this sytem with the following augmented matrix:

$\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
1 & 1 & 1 & 1 \\
3 & 11 & 5 & 35 \\
\end{array}
\right]$

Let's go through the same steps as above but with the left portion of our augmented matrix (everything before the vertical line).
"""

# ╔═╡ ae535510-34f9-11eb-353e-af4e42d00585
md"""
1. In this case, the first entry in the first row is 1 so we'll focus on making the first entry of row 2 equal zero. A simple way to do this is to **multiply the first row by -1 and add the product to the second row**:

$\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
(-1\times 1) + 1 & (-1\times 3) + 1 & (-1\times 1) + 1 & (-1\times 9) + 1 \\
3 & 11 & 5 & 35 \\
\end{array}
\right] = 
\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & -2 & 0 & -8 \\
3 & 11 & 5 & 35 \\
\end{array}
\right]$

2. Now, let's make the first entry of row three equal zero by **multiplying -3 by row 1 and adding the product to row 3**:

$\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & -2 & 0 & -8 \\
(-3\times 1) + 3 & (-3\times 3) + 11 & (-3\times 1) + 5 & (-3\times 9) + 35 \\
\end{array}
\right] = 
\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & -2 & 0 & -8 \\
0 & 2 & 2 & 8 \\
\end{array}
\right]$

3. Let's now make the pivot of row 2 equal zero by **multiplying row 2 by $-\frac{1}{2}$**:

$\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
-\frac{1}{2}(0) & -\frac{1}{2}(-2) & -\frac{1}{2}(0) & -\frac{1}{2}(-8) \\
0 & 2 & 2 & 8 \\
\end{array}
\right] = 
\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & 1 & 0 & 4 \\
0 & 2 & 2 & 8 \\
\end{array}
\right]$

4. The next row operation will make the second element of row 3 equal to zero. We'll **multiply the second row by -2 and add the product to row 3**:

$\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & 1 & 0 & 4 \\
(-2\times 0) + 0 & (-2\times 1) + 2 & (-2\times 0) + 2 & (-2\times 4) + 8 \\
\end{array}
\right] = 
\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & 1 & 0 & 4 \\
0 & 0 & 2 & 0 \\
\end{array}
\right]$
"""

# ╔═╡ dadcd2be-34fc-11eb-136f-0f18e50bd46d
md"""
5. If we **multiply the third row by $\frac{1}{2}$** we'll be finished with it and can then focus on the first row:

$\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & 1 & 0 & 4 \\
\frac{1}{2}(0) & \frac{1}{2}(0) & \frac{1}{2}(2) & \frac{1}{2}(0) \\
\end{array}
\right] = 
\left[
\begin{array}{ccc|c}
1 & 3 & 1 & 9 \\
0 & 1 & 0 & 4 \\
0 & 0 & 1 & 0 \\
\end{array}
\right]$

6. We're getting very close. Let's make the third entry of row 1 equal zero by **multiplying -1 by the third row and adding it to the first row**:

$\left[
\begin{array}{ccc|c}
(-1\times 0) + 1 & (-1\times 0) + 3 & (-1\times 1) + 1 & (-1\times 0) + 9 \\
0 & 1 & 0 & 4 \\
0 & 0 & 1 & 0 \\
\end{array}
\right] = 
\left[
\begin{array}{ccc|c}
1 & 3 & 0 & 9 \\
0 & 1 & 0 & 4 \\
0 & 0 & 1 & 0 \\
\end{array}
\right]$

7. The last row opperation to get our matrix into reduced row echelon form is to **multiply the second row by -3 and add the product to the first row**:

$\left[
\begin{array}{ccc|c}
(-3\times 0) + 1 & (-3\times 1) + 3 & (-3\times 0) + 0 & (-3\times 4) + 9 \\
0 & 1 & 0 & 4 \\
0 & 0 & 1 & 0 \\
\end{array}
\right] = 
\left[
\begin{array}{ccc|c}
1 & 0 & 0 & -3 \\
0 & 1 & 0 & 4 \\
0 & 0 & 1 & 0 \\
\end{array}
\right]$

Now that the left portion of our agumented matrix is in reduced row echelon form, the values that appear in the right-side column are the solutions to our system of linear equations! $x = -3$, $y = 4$, and $z = 0$.
"""

# ╔═╡ a376a3c0-3807-11eb-179a-3dc78c3ec308
md"""
It is also possible to solve systems of linear equations by making use of the matrix inverse. We can actually solve the above system by separating our augmented matrix into a matrix and a vector and then simply multiplying the inverse of the matrix by the vector:

$X = \begin{bmatrix}
1 & 3 & 1\\
1 & 1 & 1\\
3 & 11 & 5\end{bmatrix}$

$Y = \begin{bmatrix}
9\\
1\\
35\end{bmatrix}$

$X^{-1}Y = \begin{bmatrix}
-3\\
4\\
0\end{bmatrix}$
"""

# ╔═╡ b86303d0-3809-11eb-3c44-e7438b8cf5b1
md"""
#### Eigenvalues & Eigenvectors

From *Wikipedia*:

> In linear algebra, an eigenvector, or characteristic vector, of a linear transformation is a nonzero vector that changes by a scalar factor when that linear transformation is applied to it. The corresponding eigenvalue, often denoted by $\lambda$, is the factor by which the eigenvector is scaled.

I would compliment this definition by stating that an eigenvector changes *only* by a scalar factor ($\lambda$) when the linear transformation is applied. In other words, if the vector changes direction, it's not an eigenvector. 

Let's see this in action. Recall from earlier the matrix that we used to perform rotation. We will use the following matrix $M$ to transform our vector space:

$M = \begin{bmatrix}
\text{-}1.5 & 0.75\\
1 & 1.25\end{bmatrix}$

Notice this time, however, that *we are transforming (rotating) the entire  vector space*. You will see that the gridlines themselves are transformed, in addition to our vectors $v_1$ and $v_2$:

$v_1 \approx \begin{bmatrix}
\text{-}0.24\\
\text{-}0.97\end{bmatrix} \ \ \ \ v_2 = 
\begin{bmatrix}
0.5\\
\text{-}1.5\end{bmatrix}$
"""

# ╔═╡ f867d3e0-38a7-11eb-1513-a9a30cc840f1
@bind rot Radio(["Initial", "Transformed"], default="Initial")

# ╔═╡ 25fe1660-389a-11eb-2af5-9dc1a8923816
begin
	M = [-1.5 0.75; 1 1.25]
	R = rot == "Initial" ? Matrix(I, 2, 2) : [-1.5 0.75; 1 1.25]
	vvec = R*[0,4]
	xs = -2:2
	ys = [0 for _ in 1:length(xs)]
	us = repeat([vvec[1]],length(xs))
	vs = repeat([vvec[2]],length(xs))
	X = hcat(xs,ys,us,vs)
	Y = hcat(ys,xs,vs,us)
end;

# ╔═╡ 1fd91dd0-3894-11eb-3c70-a118e42b77a3
begin
	Plots.quiver(
		X[:,1],
		X[:,2],
		quiver=(
			X[:,3],
			X[:,4]
		),
		framestyle=:none,
		color=:black,
		lw=0.2,
		arrow=Plots.arrow(:head),
		xlims=(-2,2),
		ylims=(-1.5,1.5),
		legend=:topright
	)
	Plots.quiver!(
		X[:,1],
		X[:,2],
		quiver=(
			-X[:,3],
			-X[:,4]
		),
		framestyle=:none,
		color=:black,
		lw=0.2,
		arrow=Plots.arrow(:head)
	)
	Plots.quiver!(
		Y[:,1],
		Y[:,2],
		quiver=(
			Y[:,3],
			Y[:,4]
		),
		framestyle=:none,
		color=:black,
		lw=0.2,
		arrow=Plots.arrow(:head)
	)
	Plots.quiver!(
		Y[:,1],
		Y[:,2],
		quiver=(
			-Y[:,3],
			-Y[:,4]
		),
		framestyle=:none,
		color=:black,
		lw=0.2,
		arrow=Plots.arrow(:head)
	)
	v₁ = R*eigvecs(M)[:,2]
	v₂ = R*[0.5,-1.5]
	Plots.plot!(
		[0, v₁[1]],
		[0, v₁[2]],
		line=:arrow,
		label=L"v_1"
	)
	Plots.plot!(
		[0, v₂[1]],
		[0, v₂[2]],
		line=:arrow,
		label=L"v_2"
	)
end

# ╔═╡ 867dd2f0-38ae-11eb-3070-e76c07416bd5
md"""
Did you notice what happened? The entire vector space was transformed but our vector $v_1$ remains pointing in the same direction - it's just a little bit longer now. That's becasue $v_1$ is an eigenvector. How much longer is it? It is exactly 1.5 times longer. In this case, $\lambda = 1.5$ for this particular eigenvector $v_1$! Note that $v_2$ is not an eigenvector of our transformation matrix $M$ because it changes both direction and length.

For a square matrix, the following equation holds true:

$Mv = \lambda v$

where $v$ is an eigenvector and $\lambda$ is its eigenvalue. For our problem above,

$Mv_1 \approx \begin{bmatrix}
\text{-}1.5 & 0.75\\
1 & 1.25\end{bmatrix}\begin{bmatrix}
\text{-}0.24\\
\text{-}0.97\end{bmatrix} \approx \begin{bmatrix}
\text{-}0.36\\
\text{-}1.46\end{bmatrix}$

which is the same as

$\lambda v_1 \approx 1.5\begin{bmatrix}
\text{-}0.24\\
\text{-}0.97\end{bmatrix} \approx \begin{bmatrix}
\text{-}0.36\\
\text{-}1.46\end{bmatrix}$

Some interesting use cases of eigenvalues and eigenvectors are noted [here](https://www.cpp.edu/~manasab/eigenvalue.pdf).
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
RowEchelon = "af85af4c-bcd5-5d23-b03a-a909639aa875"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Colors = "~0.12.8"
LaTeXStrings = "~1.2.1"
Plots = "~1.20.1"
PlutoUI = "~0.7.9"
PyPlot = "~2.9.0"
RowEchelon = "~0.2.1"
StatsBase = "~0.33.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e2f47f6d8337369411569fd45ae5753ca10394c6"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.0+6"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "727e463cfebd0c7b999bbf3e9e7e16f254b94193"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.34.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["JSON", "VersionParsing"]
git-tree-sha1 = "299304989a5e6473d985212c28928899c74e9421"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.5.2"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "92d8f9f208637e8d2d28c664051a00569c01493d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.1.5+1"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "LibVPX_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3cc57ad0a213808473eafef4845a74766242e05f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.3.1+4"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "35895cf184ceaab11fd778b4590144034a167a2f"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.1+14"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "cbd58c9deb1d304f5a245a0b7eb841a2560cfec6"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.1+5"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d59e8320c2747553788e4fc42231489cc602fa50"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.58.1+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "44e3b40da000eab4ccb1aecdc4801c040026aeb5"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.13"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[LibVPX_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "12ee7e23fa4d18361e7c2cde8f8337d4c3101bc7"
uuid = "dd192d2f-8180-539f-9fb4-cc70b1dcf69a"
version = "1.10.0+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "2ca267b08821e86c5ef4376cffed98a46c2cb205"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "501c20a63a34ac1d015d5304da0e645f42d91c9f"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.11"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "8365fa7758e2e8e4443ce866d6106d8ecbb4474e"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.20.1"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "169bb8ea6b1b143c5cf57df6d34d022a7b60c6db"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.3"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "67dde2482fe1a72ef62ed93f8c239f947638e5a2"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.9.0"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "2a7a2469ed5d94a98dea0e85c46fa653d76be0cd"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.4"

[[Reexport]]
git-tree-sha1 = "adcd36e8ba9665c88eb0bd156d4e2a19f9b0d889"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[RowEchelon]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f479526c4f6efcbf01e7a8f4223d62cfe801c974"
uuid = "af85af4c-bcd5-5d23-b03a-a909639aa875"
version = "0.2.1"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "fed1ec1e65749c4d96fc20dd13bea72b55457e62"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.9"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "000e168f5cc9aded17b6999a560b7c11dda69095"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.0"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[VersionParsing]]
git-tree-sha1 = "80229be1f670524750d905f8fc8148e5a8c4537f"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.0"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "acc685bcf777b2202a904cdcb49ad34c2fa1880c"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.14.0+4"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7a5780a0d9c6864184b3a2eeeb833a0c871f00ab"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "0.1.6+4"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d713c1ce4deac133e3334ee12f4adff07f81778f"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2020.7.14+2"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "487da2f8f2f0c8ee0e83f39d13037d6bbf0a45ab"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.0.0+3"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╠═93d1e3b0-29a9-11eb-0033-b9b6a0dbc950
# ╟─abe4ea12-29a9-11eb-0767-6fb6acc4f885
# ╟─24d0c0e0-2a6b-11eb-2c46-412bbe82db5a
# ╟─96a2c7e0-29b2-11eb-0e54-bd882d690760
# ╟─fc1ef9fe-29b5-11eb-09dc-a39f86544efc
# ╟─6f18c8c0-2a69-11eb-0b27-83756d9e79b3
# ╟─39485fc0-2a65-11eb-14d2-fddb2c9c1943
# ╟─9d9d8190-2a69-11eb-347b-a52f771283af
# ╟─b2b07ed0-2a9f-11eb-1c91-558277788da6
# ╟─c24f84d0-2a9f-11eb-09cf-91348d914c46
# ╟─d0a978f2-2aa5-11eb-0bf4-851cec6ae342
# ╟─30ca8ad0-2aa6-11eb-2a0f-250459a09553
# ╟─2aea1120-2aa7-11eb-37c5-03db9233b9cd
# ╟─2cdd0780-2aa7-11eb-1d9c-59df3bb0a990
# ╟─bcec39ce-35b6-11eb-1e7d-793f625b0a29
# ╟─70475210-2b37-11eb-285a-03eab26f3214
# ╟─7e00b090-2cd6-11eb-04c9-4d605cac24ae
# ╟─09dfdfe0-3809-11eb-31a0-79e449c89b8a
# ╟─1481a280-2d91-11eb-1177-39f3314ae707
# ╟─ae535510-34f9-11eb-353e-af4e42d00585
# ╟─dadcd2be-34fc-11eb-136f-0f18e50bd46d
# ╟─a376a3c0-3807-11eb-179a-3dc78c3ec308
# ╟─b86303d0-3809-11eb-3c44-e7438b8cf5b1
# ╟─f867d3e0-38a7-11eb-1513-a9a30cc840f1
# ╟─25fe1660-389a-11eb-2af5-9dc1a8923816
# ╟─1fd91dd0-3894-11eb-3c70-a118e42b77a3
# ╟─867dd2f0-38ae-11eb-3070-e76c07416bd5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
