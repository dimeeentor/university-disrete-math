import math
import struct

# Question 1
def bin_to_hex(bin_str):
    """
    Convertit une chaîne binaire en sa représentation hexadécimale.

    Paramètres :
    bin_str (str) : La chaîne binaire à convertir.

    Retourne :
    str : La représentation hexadécimale de la chaîne binaire.
    """
    # Définit les caractères hexadécimaux
    hex_chars = '0123456789ABCDEF'
    hex_repr = ''
    # Itère sur la chaîne binaire par groupes de 4 bits
    for i in range(0, len(bin_str), 4):
        # Convertit le groupe de 4 bits en entier
        value = int(bin_str[i:i+4], 2)
        # Ajoute le caractère hexadécimal correspondant à la représentation hexadécimale
        hex_repr += hex_chars[value]
    return hex_repr

# Question 2
def sign_bit(float_value):
    """
    Détermine le bit de signe d'un nombre à virgule flottante.

    Paramètres :
    float_value (float) : Le nombre à virgule flottante.
    
    Retourne :
    str : Le bit de signe ("1" pour négatif, "0" pour non-négatif).
    """
    # Retourne "1" si le nombre est négatif, "0" sinon
    return "1" if float_value < 0 else "0"

# Question 3
def get_exponent(float_value):
    """
    Calcule les bits de l'exposant d'un nombre à virgule flottante.
    
    Paramètres :
    float_value (float) : Le nombre à virgule flottante.
    
    Retourne :
    str : Les bits d'exposant de la représentation IEEE 754.
    """
    # Calcule l'exposant du nombre
    exp = int(math.log(abs(float_value), 2))
    # Convertit l'exposant en binaire et ajuste avec le biais IEEE 754 (127)
    exp_bits = bin(exp + 127)[2:].zfill(8)
    return exp_bits

# Question 4
def get_mantissa(float_value):
    """
    Calcule les 23 bits de la mantisse d'un nombre à virgule flottante.
    
    Paramètres :
    float_value (float) : Le nombre à virgule flottante.
    
    Retourne :
    str : Les 23 bits de la mantisse de la représentation IEEE 754.
    """
    # Convertit le nombre en binaire IEEE 754
    float_bin = struct.pack('>f', float_value)
    float_bytes = bytearray(float_bin)
    float_bits = ''.join(f'{byte:08b}' for byte in float_bytes)

    # Extrait les bits de la mantisse
    sign_bit = float_bits[0]
    exponent_bits = float_bits[1:9]
    mantissa_bits = float_bits[9:]

    # Ajuste la mantisse en fonction de l'exposant
    exponent = int(exponent_bits, 2) - 127
    if exponent == -127:
        # Cas spécial : dénormalisé
        mantissa = '0' + mantissa_bits
    else:
        # Cas normal : normalisé
        mantissa = mantissa_bits

    # Retourne les 23 premiers bits de la mantisse
    return mantissa[:23]

# Question 5
def ieee754_representation(float_value):
    """
    Convertit un nombre à virgule flottante en sa représentation IEEE 754.
    
    Paramètres :
    float_value (float) : Le nombre à virgule flottante à convertir.
    
    Retourne :
    tuple : Un tuple contenant la représentation binaire et la représentation hexadécimale.
    """
    # Calcule le bit de signe, les bits d'exposant et les bits de mantisse
    sign_bit_value = sign_bit(float_value)
    exp_bits = get_exponent(float_value)
    mantissa_bits = get_mantissa(float_value)

    # Construit la représentation binaire
    bin_repr = sign_bit_value + exp_bits + mantissa_bits
    # Convertit la représentation binaire en hexadécimale
    hex_repr = bin_to_hex(bin_repr)

    return bin_repr, hex_repr

# Question 6
def binary_to_float(bin_repr):
    """
    Convertit la représentation binaire d'un nombre à virgule flottante au format IEEE 754 en sa valeur décimale.
    
    Paramètres :
    bin_repr (str) : La représentation binaire du nombre à virgule flottante.
    
    Retourne :
    float : La valeur décimale du nombre à virgule flottante.
    """
    # Détermine le signe à partir du bit de signe
    sign = -1 if bin_repr[0] == '1' else 1
    # Calcule l'exposant à partir des bits d'exposant
    exp = int(bin_repr[1:9], 2) - 127
    # Calcule la mantisse à partir des bits de mantisse
    mantissa = 1 + sum(int(bit) * 2 ** (-i) for i, bit in enumerate(bin_repr[9:], start=1))
    # Calcule la valeur décimale à partir du signe, de l'exposant et de la mantisse
    return sign * mantissa * (2 ** exp)