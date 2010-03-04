#!/usr/bin/env python

class Contact(object):
	
	def __init__(self,attrlist=[]):
		for self.x in attrlist:
			setattr(self,self.x,None)
	
	def setAttributes(self,attrlist=[]):
		for self.x in attrlist:
			setattr(self,self.x,None)
				
def main():
	
	c1 = Contact(['fname','lname','email'])
	c1.fname = 'Brian'
	print c1.fname


if __name__ == '__main__':
	main()