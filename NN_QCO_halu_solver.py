import numpy as np

def qco(X, alpha=2):
    y = 0.0
    for k, block in enumerate(X):
        N_k = sum(x**2 for x in block)
        w_k = alpha ** (-2**k)
        y += w_k * N_k
    return y

B0 = [1.0]
B1 = [0.5]
B2 = [0.3, 0.4]
B3 = np.random.rand(4) * 0.1
B4 = np.random.rand(8) * 10

X1 = [B0, B1, B2, B3, B4]
y1 = qco(X1)

B4_alt = np.random.rand(8) * 20
X2 = [B0, B1, B2, B3, B4_alt]
y2 = qco(X2)

print(f"y1: {y1}")
print(f"y2: {y2}")
print(f"Difference: {abs(y1 - y2)}")
print(f"w_4 = {2 ** (-2**4)}")