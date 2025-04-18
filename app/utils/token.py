# app/utils/token.py
import random
import string

def generate_verification_code(length=6):
    return ''.join(random.choices(string.digits, k=length))
