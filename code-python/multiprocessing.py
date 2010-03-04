#!/usr/bin/env python
from multiprocessing import Process
import os
import time, random

def sleeper(name, seconds):
    #print 'starting child process with id: ', os.getpid()
    #print 'parent process:', os.getppid()
    #print 'parent process:', os.getppid()
    
    s = random.randint(1, 15)
    print '%s sleeping for %s ' % (name,s)
    time.sleep(s)
    print "Done sleeping " + name


if __name__ == '__main__':

   p1 = Process(target=sleeper, args=('p1', 5))
   p2 = Process(target=sleeper, args=('p2', 5))
   p3 = Process(target=sleeper, args=('p3', 5))
   p4 = Process(target=sleeper, args=('p4', 5))

   p1.start()
   p2.start()
   p3.start()
   p4.start()

   p1.join()
   p2.join()
   p3.join()
   p4.join()

