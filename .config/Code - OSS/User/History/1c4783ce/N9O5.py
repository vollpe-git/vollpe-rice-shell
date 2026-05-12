#!/usr/bin/env python3

import os

flag = os.getenv('FLAG', 'flag{a}')

enc_flag = ""
chars = ['.', '-']
for i, c in enumerate(flag):
    enc_flag += chars[i % 2] * ord(c)

print(enc_flag)

old = enc_flag[0]
num = 0
for val in enc_flag:
    if val == old:
        i += 1
        fflag[num] = i
    else:
        num += 1
        i = 0
        old = val

for i in fflag.size():
    fflag[i] += 1

for c in fflag:
    print(c)