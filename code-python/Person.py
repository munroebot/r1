class Person(object):

	def __init__(self):
		pass
		
	def newAttribute(self,name,value=None):
   		setattr(self,name, value)

	def dump(self):
		for self.y in self.__dict__.keys():
			yield self.y + " = " + getattr(self,self.y)
			
	def __str__(self):
		return getattr(self,'fname') + " " + getattr(self,'lname')
				
p1 = Person()
p1.newAttribute('fname','Brian')
p1.newAttribute('lname','Munroe')

print p1

for x in p1.dump():
	print x
	