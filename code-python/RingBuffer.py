class Ring:

	def __init__(self, l):
		self.__data = l

	def __repr__(self):
 		return repr(self.__data)

	def __len__(self):
		return len(self.__data)

	def __getitem__(self, i):
		return self.__data[i]

	def turn(self):
		last = self.__data.pop(-1)
		self.__data.insert(0, last)

	def first(self):
		return self.__data[0]

	def last(self):
		return self.__data[-1]

def main():
	l = [{1:1}, {2:2}, {3:3}]
	r = Ring(l)
	r.turn()
	print r.first()
	r.turn()
	print r.first()
   
if __name__ == "__main__":
	main()