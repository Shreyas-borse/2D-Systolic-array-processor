#!/usr/bin/env python
# coding: utf-8

# In[12]:


kij_size = 9
nij_size = 36

output_size = 16
dict = {}

for kij in range(9):
    for nij in range(16):
        nij_prime = int(nij/4)*6 + nij%4;
        kij_prime = kij*36+ int(kij/3)*6 + kij%3;

        dict[kij_prime + nij_prime] = nij
        

print()
print()
for i in range(324):
    if(i not in dict):
        print(i,16)
    else:
        print(i,dict[i])

