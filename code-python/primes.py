#!/usr/bin/env python

import sys
import math
import thread

def dowork(tn): # thread number tn
    global n,prime,nexti,nextilock,nstarted,nstartedlock,donelock
    nstartedlock.acquire()
    nstarted += 1
    nstartedlock.release()
    donelock[tn].acquire()
    lim = math.sqrt(n)
    nk = 0
    while 1:
        nextilock.acquire()
        k = nexti
        nexti += 1
        nextilock.release()
        if k > lim: break
        nk += 1
        if prime[k]:
            r = n / k
            for i in range(2,r+1):
                prime[i*k] = 0

    print 'thread', tn, 'exiting; processed', nk, 'values of k'
    donelock[tn].release()

def main():
    global n,prime,nexti,nextilock,nstarted,nstartedlock,donelock
    n = int(sys.argv[1])
    prime = (n+1) * [1]
    nthreads = int(sys.argv[2])
    nstarted = 0
    nexti = 2
    nextilock = thread.allocate_lock()
    nstartedlock = thread.allocate_lock()
    donelock = []
    for i in range(nthreads):
        d = thread.allocate_lock()
        donelock.append(d)
        thread.start_new_thread(dowork,(i,))
    while nstarted < 2: pass
    for i in range(nthreads):
        donelock[i].acquire()
    print 'there are', reduce(lambda x,y: x+y, prime) - 2, 'primes'

if __name__ == '__main__':
    main()