# Programme permettant de calculer x^n, le resultat est dans le registre $13
ADDI $10, $0, 4 # n
ADDI $11, $0, 0
ADDI $12, $0, 5	# x
ADDI $13, $0, 1
MULT $13, $12

MFLO $13
ADDI $11, $11, 1
SLT $14, $11, $10
BGTZ $14, -12 # avoir jsp
NOP

# EXPECTED_ASSEMBLY
# 200A0004
# 200B0000
# 200C0005
# 200D0001
# 01AC0018
# 00006812
# 216B0001
# 016A702A
# 1DC0FFF4
# 00000000