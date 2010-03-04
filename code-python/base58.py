ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"         

def base58_encode(n=1):

    result = ""
    base = len(ALPHABET)

    while n > 0:
        remainder = n % base
        n = n / base
        result = ALPHABET[remainder] + result
  
    return result

def base58_decode(encoded_string=None):

    value = 0
    base = len(ALPHABET)
    x = list(encoded_string)
    
    for token in x:
        value = value * base + ALPHABET.find(token)
    
    return value 

try:
    assert base58_encode(2010) == 'bf', "Warning: base58_encode() is broken"
    assert base58_decode('bf') == 2010, "Warning: base58_decode() is broken"
except AssertionError as inst:
    print inst
    
