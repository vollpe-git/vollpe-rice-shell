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
i = 0
for index in enc_flag.size():
    if index != 0:
        if enc_flag[index] == old:
            i += 1
        else:
            fflag += chr(i+1)
            i = 0
            old = enc_flag[index]
fflag += chr(i+1)
i = 0

print(fflag)