##########
# import #
##########
import re

#############
# Assembler #
#############
class Assembler:

	############
	# __init__ #
	############
	def __init__(self, file_in):
		# registers
		self.registers = set(['r0', 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7'])
		# instruction set
		self.instruction_set = set(['load', 'store', 'jump', 'beq', 'bne', 'blt', 'ble', 'add', 'sub', 'and', 'or', 'xor', 'shl', 'shr'])
		# source code
		self.src = open(file_in).read()
		# tokens
		self.tokens = []
		# instructions
		self.instructions = []
		# labels
		self.labels = {}
		# debug info for instructions
		self.debug_info = []
		# machine code
		self.instructions_binary = []

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
		self.BRANCH__BEQ = 0x0
		self.BRANCH__BNE = 0x1
		self.BRANCH__BLT = 0x2
		self.BRANCH__BLE = 0x3
		self.FUNC__ADD = 0x0
		self.FUNC__SUB = 0x1
		self.FUNC__AND = 0x2
		self.FUNC__OR = 0x3
		self.FUNC__XOR = 0x4
		self.FUNC__SHL = 0x5
		self.FUNC__SHR = 0x6

		# list of functions
		self.func = {'add': self.FUNC__ADD, 'sub': self.FUNC__SUB, 'and': self.FUNC__AND, 'or': self.FUNC__OR, 'xor': self.FUNC__XOR, 'shl': self.FUNC__SHL, 'shr': self.FUNC__SHR}
		self.branch = {'beq': self.BRANCH__BEQ, 'bne': self.BRANCH__BNE, 'blt': self.BRANCH__BLT, 'ble': self.BRANCH__BLE}


	########
	# save #
	########
	def save(self, file_name):
		if bool(re.match('[A-z_]+[A-z_0-9]*\.coe', file_name)):
			self.save__coe(file_name)

	def save__coe(self, file_name):
		file = open(file_name, 'w')
		file.write('memory_initialization_radix=2;\n')
		file.write('memory_initialization_vector=\n')

		for i in range(len(self.instructions_binary)):
			binary = self.instructions_binary[i]
			if i == len(self.instructions_binary) - 1:
				file.write('{:016b};\n'.format(binary))
			else:
				file.write('{:016b},\n'.format(binary))

	#######
	# run #
	#######
	def run(self):
		self.tokenize()
		print(self.tokens)
		self.parse_tokens()
		self.assemble()
		
	############
	# tokenize #
	############
	def tokenize(self):
		self.tokens = []
		for line in re.split('\n', self.src):
			# make string all lower case
			line = line.lower()
			# remove comments
			line = re.sub('//.*', '', line)
			# convert tabs to spaces
			line = re.sub('\t+', ' ', line)
			# replace multiple spaces with a single space
			line = re.sub(' +', ' ', line)
			# remove any spaces before the begining of the line
			line = re.sub('^ *', '', line)
			# add a single spaces before ':' character
			line = re.sub(' *:', ' :', line)
			# remove any spaces before the end of the line
			line = re.sub(' $', '', line)
			# tokenize line
			line = re.split(' |, ', re.sub('\n', '', line))
			# add tokenized line to tokens
			self.tokens.append(line)

	################
	# parse_tokens #
	################
	def parse_tokens(self):
		# source file line number
		line_number = 0
		# instruction index
		n = 0
		for line in self.tokens:
			# blank line
			if line == ['']:
				pass

			# line contains a label
			elif len(line) == 2 and bool(re.match('[A-z_]+', line[0])) and bool(re.match(':', line[1])):
				label = line[0]
				if label in self.instruction_set.union(self.registers):
					print(f'[ERROR] Reserved words cannot be used as labels')
				elif label in self.labels:
					print(f'[ERROR] The label "{label}" has already been defined')
				else:
					self.labels[label] = n

			# line is an instruction
			elif line[0] in self.instruction_set:
				instr = line
				self.instructions.append(instr)
				n += 1

			# increment line number
			line_number += 1

	############
	# assemble #
	############
	def assemble(self):
		for n in range(len(self.instructions)):
			instr = self.instructions[n]
			op = instr[0]

			if op in self.func:
				binary = self.instr__func(instr)
			elif op == 'jump':
				binary = self.instr__jump(instr, n)
			elif op == 'store':
				binary = self.instr__store(instr)
			elif op == 'load':
				binary = self.instr__load(instr)
			elif op in self.branch:
				binary = self.instr__branch(instr, n)

			self.instructions_binary.append(binary)

	###############
	# instr__func #
	###############
	def instr__func(self, instr):
		# check instruction length
		if len(instr) != 4:
			print(f'[ERROR] Invalid op')

		# make assignments
		op, r_2, r_0, r_1 = instr

		# convert register token to address
		addr_0 = self.token_to_addr(r_0)
		addr_1 = self.token_to_addr(r_1)
		addr_2 = self.token_to_addr(r_2)

		# check if format matches the instruction
		if op not in self.func:
			print(f'[ERROR] Instruction is not supported in this format')

		# check if valid register values were given
		if (addr_0 == None) or (addr_1 == None) or (addr_2 == None):
			print(f'[ERROR] Invalid arguments')

		# get function encoding
		func = self.func[op]
		# build binary
		binary = self.build__func(addr_0, addr_1, addr_2, func)
		return binary

	#################
	# instr__branch #
	#################
	def instr__branch(self, instr, n):
		# check instruction length
		if len(instr) != 4:
			print(f'[ERROR] Invalid op')

		# make assignments
		op, r_0, r_1, temp = instr

		# convert register token to address
		addr_0 = self.token_to_addr(r_0)
		addr_1 = self.token_to_addr(r_1)
		imm = self.token_to_imm(temp)
		if imm == None:
			if temp in self.labels:
				imm = self.labels[temp] - n

		# check if format matches the instruction
		if op not in self.branch:
			print(f'[ERROR] Instruction is not supported in this format')

		# check if valid register values were given
		if (addr_0 == None) or (addr_1 == None) or (imm == None):
			print(f'[ERROR] Invalid arguments')

		# get function encoding
		branch = self.branch[op]
		# build binary
		binary = self.build__branch(addr_0, addr_1, imm, branch)
		return binary


	###############
	# instr__jump #
	###############
	def instr__jump(self, instr, n):
		# check instruction length
		if len(instr) != 3:
			print(f'[ERROR] Invalid op')

		# make assignments
		op, r_2, temp = instr
		# convert register token to address
		addr_0 = self.token_to_addr(temp)
		addr_2 = self.token_to_addr(r_2)
		imm = self.token_to_imm(temp)
		if imm == None:
			if temp in self.labels:
				imm = self.labels[temp] - n

		if op != 'jump':
			print(f'[ERROR] Invalid op')

		# check if valid register values were given
		if addr_2 == None:
			print(f'[ERROR] Invalid argument')
		
		# indirect jump
		if (addr_0 != None):
			binary = self.build__jump_indirect(addr_0, addr_2)
		elif (imm != None):
			binary = self.build__jump_relative(addr_2, imm)
		else:
			print(f'[ERROR] Invalid argument')

		return binary

	###############
	# instr__load #
	###############
	def instr__load(self, instr):
		# check instruction length
		if len(instr) != 3:
			print(f'[ERROR] Invalid op')

		# make assignments
		op, r_2, temp = instr
		# convert register token to address
		addr_0 = self.token_to_addr(temp)
		addr_2 = self.token_to_addr(r_2)
		imm = self.token_to_imm(temp)

		if op != 'load':
			print(f'[ERROR] Invalid op')

		# load from memory
		if (addr_0 != None):
			binary = self.build__load_mem(addr_0, addr_2)
		# load immediate
		elif (imm != None):
			binary = self.build__load_imm(addr_2, imm)
		else:
			print(f'[ERROR] Invalid argument')
		
		return binary

	################
	# instr__store #
	################
	def instr__store(self, instr):
		# check instruction length
		if len(instr) != 3:
			print(f'[ERROR] Invalid op')

		# make assignments
		op, r_1, r_0 = instr
		# convert register token to address
		addr_0 = self.token_to_addr(r_0)
		addr_1 = self.token_to_addr(r_1)

		if op != 'store':
			print(f'[ERROR] Invalid op')

		# check if valid register values were given
		if (addr_0 == None) or (addr_1 == None):
			print(f'[ERROR] Invalid argument')
		
		binary = self.build__store(addr_0, addr_1)
		return binary

	#################
	# token_to_addr #
	#################
	def token_to_addr(self, token):
		# check if token is a valid register
		if token in self.registers:
			return int(token[1:])
		else:
			return None

	################
	# token_to_imm #
	################
	def token_to_imm(self, token):
		# check if token is a decimal number
		if bool(re.match('^-?[0-9]+$', token)):
			return int(token)
		# check if number has hex base
		elif bool(re.match('^0x[0-9a-f]+$', token)):
			return int(token, base = 16)
		# check if number has binary base
		elif bool(re.match('^0b[0-1]+$', token)):
			return int(token, base = 2)
		
		return None

	###############
	# build__func #
	###############
	def build__func(self, addr_0, addr_1, addr_2, func):
		return (((func & 0x7) << 11) | ((addr_0 & 0x7) << 8) | ((addr_1 & 0x7) << 5) | ((addr_2 & 0x7) << 2) | (self.OP__FUNC & 0x3)) & 0x3fff

	########################
	# build__jump_relative #
	########################
	def build__jump_relative(self, addr_2, imm):
		return (((imm & 0xff) << 8) | ((self.OP_EXT_0__JUMP_RELATIVE & 0x7) << 5) | ((addr_2 & 0x7) << 2) | (self.OP__JUMP & 0x3)) & 0xffff

	########################
	# build__jump_indirect #
	########################
	def build__jump_indirect(self, addr_0, addr_2):
		return (((addr_0 & 0x7) << 8) | ((self.OP_EXT_0__JUMP_INDIRECT & 0x7) << 5) | ((addr_2 & 0x7) << 2) | (self.OP__JUMP & 0x3)) & 0x07ff

	################
	# build__store #
	################
	def build__store(self, addr_0, addr_1):
		return (((addr_0 & 0x7) << 8) | ((addr_1 & 0x7) << 5) | (self.OP__STORE & 0x3)) & 0x07fe3

	###################
	# build__load_imm #
	###################
	def build__load_imm(self, addr_2, imm):
		return (((imm & 0xff) << 8) | ((self.OP_EXT_0__LOAD_IMM & 0x7) << 5) | ((addr_2 & 0x7) << 2) | (self.OP__LOAD & 0x3)) & 0xffff

	###################
	# build__load_mem #
	###################
	def build__load_mem(self, addr_0, addr_2):
		return (((addr_0 & 0x7) << 8) | ((self.OP_EXT_0__LOAD_MEM & 0x7) << 5) | ((addr_2 & 0x7) << 2) | (self.OP__LOAD & 0x3)) & 0x07ff

	#################
	# build__branch #
	#################
	def build__branch(self, addr_0, addr_1, imm, branch):
		return (((imm & 0x1f) << 11) | ((addr_0 & 0x7) << 8) | ((addr_1 & 0x7) << 5) | (((imm >> 5) & 0x1) << 4) | ((branch & 0x3) << 2) | (self.OP__BRANCH & 0x3)) & 0xffff


assembler = Assembler('t_0.txt')
assembler.run()
assembler.save("t_0.coe")


