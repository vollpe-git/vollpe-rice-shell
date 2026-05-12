#!/usr/bin/env python3

import os

flag = os.getenv('FLAG', 'flag{awefuiwehf}')

enc_flag = ""
chars = ['.', '-']
for i, c in enumerate(flag):
    enc_flag += chars[i % 2] * ord(c)

print(enc_flag)

#for i in 