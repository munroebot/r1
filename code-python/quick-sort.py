def quick_sort(myList):

	if myList == []: return []
		
	pivot = myList[0]
	beforePivot = [x for x in myList[1:] if x <= pivot]
	afterPivot = [x for x in myList if x > pivot]
	return quick_sort(beforePivot) + [pivot] + quick_sort(afterPivot)

bob = [2,5,6,43,8,5,1,2,2,3,3,45,56,6,4,5,6,6,7,3,3,3,3,6,4,3,3,6,7,8,89,3,3,3,3,3,3,3,3,3,3]
print quick_sort(bob)