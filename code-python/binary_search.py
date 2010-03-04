def chop(needle, haystack):
    """
    Takes an integer target (needle) and a sorted list of integers (haystack),
    and performs a binary search for the target. Return the integer index of the
    target in the array, or -1 if it's not found.
    """
    lo = haystack[0]
    hi = len(haystack)
   
    while lo < hi:

        mid = (lo+hi)/2
        midval = haystack[mid]

        if needle < midval:
            hi = mid
        elif needle > midval:
            lo = mid
        else:
            print "Found %d at index %d" % (needle, mid)
            break

chop(1,[1,2,3,4,5])
