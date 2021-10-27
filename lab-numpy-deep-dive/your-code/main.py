#1. Import the NUMPY package under the name np.
import numpy as np

#2. Print the NUMPY version and the configuration.
print('Numpy version: ', np.__version__, '\n\n', '-' * 30, '\n',)
print('Numpy configuraton: ', np.show_config(), '\n\n', '-' * 30, '\n')

#3. Generate a 2x3x5 3-dimensional array with random values. Assign the array to variable "a"
# Challenge: there are at least three easy ways that use numpy to generate random arrays. How many ways can you find?

    # Generates random number with the specified shape 
    # from a uniform distribution over [0, 1)
a = np.random.randn(2, 3, 5)

    # Generates random number with the specified shape 
    # from a normal distribution
a = np.random.rand(2, 3, 5)

    # Returns random floats in the half-open interval [0.0, 1.0)
a = np.random.random((2,3,5))

    # Generates random number based on a range 
a = np.random.randint(99, size=(2, 3, 5))

#4. Print a.
print('a: ', a)

#5. Create a 5x2x3 3-dimensional array with all values equaling 1.
#Assign the array to variable "b"

    # Return an array of given shape filled with ones.
b = np.ones((5, 2, 3))

    # Return an array of given shape filled with fill_value
b = np.full((5, 2, 3), 1)

    # Última opción
b = np.random.randint(1, 2, size=(5, 2, 3))

#6. Print b.
print(b)


#7. Do a and b have the same size? How do you prove that in Python code?

    # Ojo: nos están pidiendo "size" (elementos totales), no "shape". 
print(a.size == b.size)

    # Otra opción con una built-in function
print(np.array_equal(a,b))


#8. Are you able to add a and b? Why or why not?

# Opción 1: a + b
# Opción 2: np.add(a, b)

# I was not able to because their shapes are different. 


#9. Transpose b so that it has the same structure of a (i.e. become a 2x3x5 array). Assign the transposed array to varialbe "c".

    # Opción con .transpose()
c = b.transpose()

    # Opción con .T
c = b.T

    # Opción con .reshape()
c = b.reshape(2,3,5)

print(a.shape)
print(c.shape)

#10. Try to add a and c. Now it should work. Assign the sum to varialbe "d". But why does it work now?

    # It works because both arrays have the same shape.
d = a + c


#11. Print a and d. Notice the difference and relation of the two array in terms of the values? Explain.
print('a: ', a)
print('d: ', d)

    # Each element in d equals each element in a plus one.


#12. Multiply a and c. Assign the result to e.
e = a * c


#13. Does e equal to a? Why or why not?
print(a == e)

"""
Yes, it equals to e because array c consists only of one's, so 
we are multiplying array a by 1.
"""

#14. Identify the max, min, and mean values in d. Assign those values to variables "d_max", "d_min", and "d_mean"

    # The two options are below
d_max = np.max(d)
d_max = d.max()
print(d_max)

d_min = np.min(d)
d_min = d.min()
print(d_min)

d_mean = np.mean(d)
d_mean = d.mean()
print(d_mean)


#15. Now we want to label the values in d. First create an empty array "f" with the same shape (i.e. 2x3x5) as d using `np.empty`.
f = np.empty((2, 3, 5))

"""
#16. Populate the values in f. For each value in d, if it's larger than d_min but smaller than d_mean, assign 25 to the corresponding value in f.
If a value in d is larger than d_mean but smaller than d_max, assign 75 to the corresponding value in f.
If a value equals to d_mean, assign 50 to the corresponding value in f.
Assign 0 to the corresponding value(s) in f for d_min in d.
Assign 100 to the corresponding value(s) in f for d_max in d.
In the end, f should have only the following values: 0, 25, 50, 75, and 100.
Note: you don't have to use Numpy in this question.
"""

for d1 in range(len(f)):
    for d2 in range(len(f[d1])):        
        for d3 in range(len(f[d1, d2])):
           
            d_value = d[d1, d2, d3] 

            if d_min < d_value < d_mean:
                f[d1, d2, d3]  = 25

            elif d_value == d_mean:
                f[d1, d2, d3] = 50

            elif d_mean < d_value < d_max:
                f[d1, d2, d3] = 75

            elif d_value == d_min:
                f[d1, d2, d3] = 0

            elif d_value == d_max:
                f[d1, d2, d3] = 100

"""
#17. Print d and f. Do you have your expected f?
For instance, if your d is:
array([[[1.85836099, 1.67064465, 1.62576044, 1.40243961, 1.88454931],
        [1.75354326, 1.69403643, 1.36729252, 1.61415071, 1.12104981],
        [1.72201435, 1.1862918 , 1.87078449, 1.7726778 , 1.88180042]],

       [[1.44747908, 1.31673383, 1.02000951, 1.52218947, 1.97066381],
        [1.79129243, 1.74983003, 1.96028037, 1.85166831, 1.65450881],
        [1.18068344, 1.9587381 , 1.00656599, 1.93402165, 1.73514584]]])

Your f should be:
array([[[ 75.,  75.,  75.,  25.,  75.],
        [ 75.,  75.,  25.,  25.,  25.],
        [ 75.,  25.,  75.,  75.,  75.]],

       [[ 25.,  25.,  25.,  25., 100.],
        [ 75.,  75.,  75.,  75.,  75.],
        [ 25.,  75.,   0.,  75.,  75.]]])
"""

print('d: ', d)
print('f: ', f)


"""
#18. Bonus question: instead of using numbers (i.e. 0, 25, 50, 75, and 100), how to use string values 
("A", "B", "C", "D", and "E") to label the array elements? You are expecting the result to be:
array([[[ 'D',  'D',  'D',  'B',  'D'],
        [ 'D',  'D',  'B',  'B',  'B'],
        [ 'D',  'B',  'D',  'D',  'D']],

       [[ 'B',  'B',  'B',  'B',  'E'],
        [ 'D',  'D',  'D',  'D',  'D'],
        [ 'B',  'D',   'A',  'D', 'D']]])
Again, you don't need Numpy in this question.
"""
g = np.empty((2, 3, 5), dtype='str')

for d1 in range(len(g)):
    for d2 in range(len(g[d1])):        
        for d3 in range(len(g[d1, d2])):
           
            d_value = d[d1, d2, d3]  

            if d_min < d_value < d_mean:
                g[d1, d2, d3] = 'B'

            elif d_value == d_mean:
                g[d1, d2, d3] = 'C'

            elif d_mean < d_value < d_max:
                g[d1, d2, d3] = 'D'

            elif d_value == d_min:
                g[d1, d2, d3] = 'A'

            elif d_value == d_max:
                g[d1, d2, d3] = 'E'