##########
# import #
##########
import re

OP__FUNC = 0x0
OP__LOAD = 0x1
OP__JUMP = 0x1
OP__STORE = 0x2
OP__BRANCH = 0x3
OP_EXT_0__LOAD_IMM = 0x0
OP_EXT_0__LOAD_MEM = 0x2
OP_EXT_0__JUMP_RELATIVE = 0x1
OP_EXT_0__JUMP_INDIRECT = 0x3
OP_EXT_1__BEQ = 0x0
OP_EXT_1__BNE = 0x1
OP_EXT_1__BLT = 0x2
OP_EXT_1__BLE = 0x3
FUNC__ADD = 0x0
FUNC__SUB = 0x1

def instr__load_imm(r_2, imm):
	return (((imm & 0xff) << 8) | ((OP_EXT_0__LOAD_IMM & 0x7)<< 5) | ((r_2 & 0x7) << 2) | (OP__LOAD & 0x3)) & 0xffff

def instr__load_mem(r_0, r_2):
	return (((r_0 & 0x7) << 8) | ((OP_EXT_0__LOAD_IMM & 0x7)<< 5) | ((r_2 & 0x7) << 2) | (OP__LOAD & 0x3)) & 0x07ff

def instr__add(r_0, r_1, r_2):
	return (((FUNC__ADD & 0x7) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | ((r_2 & 0x7) << 2) | (OP__FUNC & 0x3)) & 0x3fff

def instr__sub(r_0, r_1, r_2):
	return (((FUNC__SUB & 0x7) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | ((r_2 & 0x7) << 2) | (OP__FUNC & 0x3)) & 0x3fff

def instr__jump_relative(r_2, imm):
	return (((imm & 0xff) << 8) | ((OP_EXT_0__JUMP_RELATIVE & 0x7) << 5) | ((r_2 & 0x7) << 2) | (OP__JUMP & 0x3)) & 0xffff

def instr__jump_indirect(r_0, r_2):
	return (((r_0 & 0x7) << 8) | ((OP_EXT_0__JUMP_INDIRECT & 0x7) << 5) | ((r_2 & 0x7) << 2) | (OP__JUMP & 0x3)) & 0x07ff

def instr__store(r_0, r_1):
	return (((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (OP__STORE & 0x3)) & 0x07fe3

def instr__beq(r_0, r_1, imm):
	return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((OP_EXT_1__BEQ & 0x3) << 2) | (OP__BRANCH & 0x3)) & 0xffff

def instr__bne(r_0, r_1, imm):
	return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((OP_EXT_1__BNE & 0x3) << 2) | (OP__BRANCH & 0x3)) & 0xffff

def instr__blt(r_0, r_1, imm):
	return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((OP_EXT_1__BLT & 0x3) << 2) | (OP__BRANCH & 0x3)) & 0xffff

def instr__ble(r_0, r_1, imm):
	return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((OP_EXT_1__BLE & 0x3) << 2) | (OP__BRANCH & 0x3)) & 0xffff


def token_to_imm(token):
	#print(bool(re.match('^[0-9]+$', token)))
	# check if token is a decimal number
	if bool(re.match('^-*[0-9]+$', token)):
		imm = int(token) & 0xff
		return imm 
	# check if token is a hex or binary number
	elif len(token) > 2:
		if token[0:2] == '0x' and bool(re.match('^[0-9a-f]+$', token[2:])):
			imm = int(token, base = 16) & 0xff
			return imm
		if token[0:2] == '0b' and bool(re.match('^[0-1]+$', token[2:])):
			imm = int(token, base = 2) & 0xff
			return imm
	return None

file = open('t_0.txt')
hex_file = open('a.txt', 'w')
coe = open('t_0.coe', 'w')
coe.write('memory_initialization_radix=2;\n')
coe.write('memory_initialization_vector=\n')


#regs = set(['r' + str(i) for i in range(8)])
regs = {'r0': 0x0, 'r1': 0x1, 'r2': 0x2, 'r3': 0x3, 'r4': 0x4, 'r5': 0x5, 'r6': 0x6, 'r7': 0x7}
regs = set(['r' + str(i) for i in range(8)])

#instr = set(['add', 'sub', 'load', 'store'])
instr_len = {'add': 4, 'sub': 4, 'load': 3, 'store': 3, 'jump': 3, 'beq': 4, 'bne': 4, 'blt': 4,'ble': 4}

labels = {}


def token_to_reg(token):
	if token in regs:
		return int(token[1:])
	else:
		return None


instr_list = []
line_number = 1
instr_number = 1
for line in file:
	#line = "the dog// when"
	if line[-1] == '\n':
		line = line[:-1]
	line = re.sub(r'//', ' // ', line)
	line = re.sub('\t', '  ', line)
	if bool(re.match(' ', line)):
		continue
	if line == '':
		continue
	#print(line)
	tokens = re.split(', *|\s *', line.lower())
	instr = []
	for i in range(len(tokens)):
		token = tokens[i]
		if i == 0 and bool(re.match('^[A-z].*:', token)):
			labels[token[0:-1]] = instr_number
		elif token == '//':
			break
		else:
			instr.append(token)
	
	if instr != []:
		instr_list.append((instr, instr_number))
		instr_number += 1

	line_number += 1

for i in range(len(instr_list)):
	instr, instr_number = instr_list[i]
	op = instr[0]
	print(instr)

	if op not in instr_len:
		continue
	if len(instr) != instr_len[op]:
		continue

	r_0 = None
	r_1 = None
	r_2 = None
	imm = None

	#print('r_0: {}, r_1: {}, r_2: {}, imm: {}'.format(r_0, r_1, r_2, imm))

	binary = None
	if op == 'add':
		r_0 = token_to_reg(instr[2])
		r_1 = token_to_reg(instr[3])
		r_2 = token_to_reg(instr[1])
		if (r_0 == None) or (r_1 == None) or (r_2 == None):
			continue
		binary = instr__add(r_0, r_1, r_2)
	elif op == 'sub':
		r_0 = token_to_reg(instr[2])
		r_1 = token_to_reg(instr[3])
		r_2 = token_to_reg(instr[1])
		if (r_0 == None) or (r_1 == None) or (r_2 == None):
			continue
		binary = instr__sub(r_0, r_1, r_2)
	elif op == 'load':
		r_0 = token_to_reg(instr[2])
		r_2 = token_to_reg(instr[1])
		imm = token_to_imm(instr[2])
		if (r_2 == None) or ((r_0 == None) and (imm == None)):
			continue
		if imm != None:
			binary = instr__load_imm(r_2, imm)
		else:
			binary = instr__load_mem(r_0, r_2)
	elif op == 'store':
		r_0 = token_to_reg(instr[1])
		r_1 = token_to_reg(instr[2])
		if (r_0 == None) or (r_1 == None):
			continue
		binary = instr__store(r_0, r_1)
	elif op == 'jump':
		r_0 = token_to_reg(instr[2])
		r_2 = token_to_reg(instr[1])
		imm = token_to_imm(instr[2])
		if (imm == None):
			if instr[2] in labels:
				offset = labels[instr[2]] - instr_number
				imm = offset & 0xff
		if (r_2 == None) or ((r_0 == None) and (imm == None)):
			continue
		if imm != None:
			binary = instr__jump_relative(r_2, imm)
		else:
			binary = instr__jump_indirect(r_0, r_2)
	elif op == 'beq':
		r_0 = token_to_reg(instr[1])
		r_1 = token_to_reg(instr[2])
		imm = token_to_imm(instr[3])
		if (imm == None):
			if instr[3] in labels:
				offset = labels[instr[3]] - instr_number
				imm = offset & 0xff
		if (r_0 == None) or (r_1 == None) or (imm == None):
			continue
		binary = instr__beq(r_0, r_1, imm)
	elif op == 'bne':
		r_0 = token_to_reg(instr[1])
		r_1 = token_to_reg(instr[2])
		imm = token_to_imm(instr[3])
		if (imm == None):
			if instr[3] in labels:
				offset = labels[instr[3]] - instr_number
				imm = offset & 0xff
		if (r_0 == None) or (r_1 == None) or (imm == None):
			continue
		binary = instr__bne(r_0, r_1, imm)
	elif op == 'blt':
		r_0 = token_to_reg(instr[1])
		r_1 = token_to_reg(instr[2])
		imm = token_to_imm(instr[3])
		if (imm == None):
			if instr[3] in labels:
				offset = labels[instr[3]] - instr_number
				imm = offset & 0xff
		if (r_0 == None) or (r_1 == None) or (imm == None):
			continue
		binary = instr__blt(r_0, r_1, imm)
	elif op == 'ble':
		r_0 = token_to_reg(instr[1])
		r_1 = token_to_reg(instr[2])
		imm = token_to_imm(instr[3])
		if (imm == None):
			if instr[3] in labels:
				offset = labels[instr[3]] - instr_number
				imm = offset & 0xff
		if (r_0 == None) or (r_1 == None) or (imm == None):
			continue
		binary = instr__ble(r_0, r_1, imm)

	hex_file.write('{:016b}\n'.format(binary))
	if i == len(instr_list) - 1:
		coe.write('{:016b};\n'.format(binary))
	else:
		coe.write('{:016b},\n'.format(binary))

	# if op == 'add':
	# 	if (instr[1] not in regs) or (instr[1] not in regs) or (instr[1] not in regs):
	# 		continue
	# 	r_0, r_1, r_2 = regs[instr[1]], regs[instr[2]], regs[instr[3]]
	# 	binary = instr__add(r_0, r_1, r_2)

	# if op == 'load':
	# 	if (instr[1] not in regs):
	# 		continue 
	# 	r_2 = regs[instr[1]]
	# 	imm = token_to_imm(instr[2])
	# 	if imm != None:
	# 		binary instr__load_imm(r_2, imm)
	# 	elif 

	# if op == 'add':
	# 	if (instr[1] in regs):
	# 		r_2 = regs[instr[1]]


		# r_2 = regs[instr[1]]
		# imm = token_to_imm(instr[2])
		# if imm != None:
		# 	binary instr__load_imm(r_2, imm)
		# elif 

	# print(instr)
	# print('{:016b}'.format(binary))




word = 'L:'
# print(bool(re.match('^[A-z].*:', word)))


	# remove any comments
	# for i in range(len(line)):
	# 	token = line[i]

	#print(line)




#print(registers)

# for i in range(len(s)):
# 	token = s[i]
# 	if token not in instr_len:
# 		continue
# 	tokens = s[i:i + 1 + instr_len[token]]
# 	print(tokens)
# 	if tokens[0] == 'load':
# 		if tokens[2] in regs:
# 			pass
# 		elif len(tokens[2]) >= 3 and tokens[2][0:2] in {'0x', '0b', '0d'}:
# 			print(tokens[2])
	# 	token_1 
	# 	#s[i + 2]
	# 	print(s[i + 2][0:2])
	#print(token)

def token_to_imm(token):
	#print(bool(re.match('^[0-9]+$', token)))
	# check if token is a decimal number
	if bool(re.match('^-*[0-9]+$', token)):
		imm = int(token) & 0xff
		return imm 
	# check if token is a hex or binary number
	elif len(token) > 2:
		if token[0:2] == '0x' and bool(re.match('^[0-9a-f]+$', token[2:])):
			imm = int(token, base = 16) & 0xff
			return imm
		if token[0:2] == '0b' and bool(re.match('^[0-1]+$', token[2:])):
			imm = int(token, base = 2) & 0xff
			return imm
	return None

	#if len(stoken)


imm = token_to_imm('-3')

instr = ['load', 'r7', '0x00']
imm = 0xff
r_2 = 0x0
r_0 = 0x5
binary = instr__load_imm(r_2, imm)
#print('{:016b}'.format(binary))
binary = instr__load_mem(r_2, r_0)
#print('{:016b}'.format(binary))

r_2 = 0x2
r_1 = 0x1
r_0 = 0x0
func = 0x7
binary = instr__add(r_0, r_1, r_2)
#print('{:016b}'.format(binary))

r_2 = 0x7
imm = 0x0
binary = instr__jump_relative(r_2, imm)
#print('{:016b}'.format(binary))


r_1 = 0x7
r_0 = 0x7

binary = instr__store(r_0, r_1)
# print('{:016b}'.format(binary))

r_1 = 0x7
r_0 = 0x7
imm = 0x31
binary = instr__beq(r_0, r_1, imm)
# print('{:016b}'.format(binary))

# print(int('0x00'))

#############
# Assembler #
#############
class Assembler:
	def __init__(self):
		# registers
		self.registers = set(['r' + str(i) for i in range(8)])
		# instruction set
		self.instruction_set = set(['load', 'store', 'jump', 'beq', 'bne', 'blt', 'ble', 'add', 'sub'])
		# constants
		self.OP__FUNC = 0x0
		self.OP__LOAD = 0x1
		self.OP__JUMP = 0x1
		self.OP__STORE = 0x2
		self.OP__BRANCH = 0x3
		self.OP_EXT_0__LOAD_IMM = 0x0
		self.OP_EXT_0__LOAD_MEM = 0x2
		self.OP_EXT_0__JUMP_RELATIVE = 0x1
		self.OP_EXT_0__JUMP_INDIRECT = 0x3
		self.OP_EXT_1__BEQ = 0x0
		self.OP_EXT_1__BNE = 0x1
		self.OP_EXT_1__BLT = 0x2
		self.OP_EXT_1__BLE = 0x3
		self.FUNC__ADD = 0x0
		self.FUNC__SUB = 0x1


		# print(self.registers)
		# print(self.instruction_set)

	def Run(input_file, output_file = 'a.txt'):
		# file = open('t_0.txt')
		# file = open('a.txt', 'w')
		pass

	def instr__load_imm(r_2, imm):
		return (((imm & 0xff) << 8) | ((self.OP_EXT_0__LOAD_IMM & 0x7)<< 5) | ((r_2 & 0x7) << 2) | (self.OP__LOAD & 0x3)) & 0xffff

	def instr__load_mem(r_0, r_2):
		return (((r_0 & 0x7) << 8) | ((self.OP_EXT_0__LOAD_IMM & 0x7)<< 5) | ((r_2 & 0x7) << 2) | (self.OP__LOAD & 0x3)) & 0x07ff

	def instr__add(r_0, r_1, r_2):
		return (((self.FUNC__ADD & 0x7) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | ((r_2 & 0x7) << 2) | (self.OP__FUNC & 0x3)) & 0x3fff

	def instr__add(r_0, r_1, r_2):
		return (((FUNC__SUB & 0x7) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | ((r_2 & 0x7) << 2) | (self.OP__FUNC & 0x3)) & 0x3fff

	def instr__jump_relative(r_2, imm):
		return (((imm & 0xff) << 8) | ((self.OP_EXT_0__JUMP_RELATIVE & 0x7) << 5) | ((r_2 & 0x7) << 2) | (self.OP__JUMP & 0x3)) & 0xffff

	def instr__jump_indirect(r_0, r_2):
		return (((r_0 & 0x7) << 8) | ((self.OP_EXT_0__JUMP_INDIRECT & 0x7) << 5) | ((r_2 & 0x7) << 2) | (self.OP__JUMP & 0x3)) & 0x07ff

	def instr__store(r_0, r_1):
		return (((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (self.OP__STORE & 0x3)) & 0x07fe3

	def instr__beq(r_0, r_1, imm):
		return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((self.OP_EXT_1__BEQ & 0x3) << 2) | (self.OP__BRANCH & 0x3)) & 0xffff

	def instr__bne(r_0, r_1, imm):
		return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((self.OP_EXT_1__BNE & 0x3) << 2) | (self.OP__BRANCH & 0x3)) & 0xffff

	def instr__blt(r_0, r_1, imm):
		return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((self.OP_EXT_1__BLT & 0x3) << 2) | (self.OP__BRANCH & 0x3)) & 0xffff

	def instr__ble(r_0, r_1, imm):
		return (((imm & 0x1f) << 11) | ((r_0 & 0x7) << 8) | ((r_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((self.OP_EXT_1__BLE & 0x3) << 2) | (self.OP__BRANCH & 0x3)) & 0xffff


assembler = Assembler()



