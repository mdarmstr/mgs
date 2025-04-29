# Minimum Gaussian Separability (MGS)

Minimum Gaussian Separability (MGS) is a statistical metric for determining the resolution between two groups of points in N dimensional space. Currently there is support for 2 dimensions, which is a typical application for statistical analyses in Principal Component Space.

The following code is offered in MATLAB, and includes a demonstration using synthetically generated data, and some rudimentary functions for plotting.

## Theory

MGS finds two vectors from the center of two groups that minimizes the following expression - accounting for the covariance of each group:

$$
\arg\min_{u_1,\,u_2}
\Bigl\||
  \bigl[V_1\Sigma_1u_1^T \big\vert -V_2\Sigma_2u_2^T\bigr]^+
  (m_2 - m_1)
\Bigr\||_F^2
\quad
\text{subject to}\quad
\||u_1\|| = 1,\||u_2\|| = 1
$$

## Usage
Input a matrix X, where the first two columns contain the values of each observation in some 2-dimensional space, and the 3rd column includes class information.
```matlab
  params = mgs(X);
```

```matlab
>>> params
    scrs: [200×3 double]
     mn1: [0.6279 0.2266]
     mn2: [-0.6279 -0.2266]
       U: [2×2 double]
       p: 0.9431
       F: 0.7651

