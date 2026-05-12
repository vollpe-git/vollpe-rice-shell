#!/usr/bin/env python3

import os

flag = os.getenv('FLAG', 'flag{a}')

enc_flag = ""
chars = ['.', '-']
for i, c in enumerate(flag):
    enc_flag += chars[i % 2] * ord(c)

print(enc_flag)

old = enc_flag[0]
fflag = ""
for val in enc_flag:
    if val == old:
        i += 1
    else:
        fflag += chr(i+1)
        i = 0
        old = val
fflag += chr(i+1)
i = 0

print(fflag)