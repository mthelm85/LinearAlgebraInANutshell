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

# ╔═╡ 93d1e3b0-29a9-11eb-0033-b9b6a0dbc950
begin
	using Pkg
	Pkg.add(["Colors","LaTeXStrings","Plots","PlutoUI","RowEchelon","StatsBase"])
	using Colors
	using LaTeXStrings
	using LinearAlgebra
	using Plots
	using PlutoUI
	using RowEchelon
	using StatsBase
	gr()
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

\$M$ is a $2\times 3$ matrix because it has **2 rows** and **3 columns**. In Part I on vectors, we learned that vectors can be written as row vectors or column vectors. A row vector is a $1\times n$ matrix and a column vector is an $m\times 1$ matrix.

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
@bind camera Slider(-180:180, default=70)

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
		camera=(camera,30)
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

If all this seems complicated, don't worry. Fortunately, there are algorithms that we can make use of to determine if a set of vectors is linearly independent. One such algorithm is the [Gram-Schmidt algorithm](https://en.wikipedia.org/wiki/Gram%E2%80%93Schmidt_process).
"""

# ╔═╡ 09dfdfe0-3809-11eb-31a0-79e449c89b8a
md"""
#### Matrix Rank

We know now that the rows of a matrix are vectors and we know how to check for linear indepence among rows. With this information, we can define the **rank** of a matrix. 
> The rank of a matrix is defined as 
> * the maximum number of linearly independent column vectors in the matrix or
> * the maximum number of linearly independent row vectors in the matrix.
>
> It turns out that both definitions are equivalent.

For our matrix $V$ from above, we would say that its rank is 2, since there were only 2 non-zero rows left after reducing it to row-echelon form.
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
@bind rotate Radio(["Initial", "Transformed"], default="Initial")

# ╔═╡ 25fe1660-389a-11eb-2af5-9dc1a8923816
begin
	M = [-1.5 0.75; 1 1.25]
	R = rotate == "Initial" ? Matrix(I, 2, 2) : [-1.5 0.75; 1 1.25]
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

# ╔═╡ Cell order:
# ╟─93d1e3b0-29a9-11eb-0033-b9b6a0dbc950
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
