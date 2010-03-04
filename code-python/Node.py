class Node(object):
	def __init__(self,cargo=None, next=None):
		self.cargo = cargo
		self.next = next
	
	def __str__(self):
		return str(self.cargo)

node3 = Node(3,None)
node2 = Node(2,node3)
node1 = Node(1,node2)

def printList(node):
	x = "["
	while(node):
		if (node.next != None):
			x += str(node) + ","
		else:
			x += str(node)
		
		node = node.next
		
	x += "]"
	print x
	
printList(node1)