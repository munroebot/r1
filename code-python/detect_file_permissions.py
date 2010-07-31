import os, sys
from stat import *

def mode_matches(mode, file):

    """ int("755", 8) -> 493) """
    filemode = S_IMODE(os.stat(file).st_mode)
    mode = int(mode, 8)
    return filemode == mode

def walktree(top, callback):
    '''recursively descend the directory tree rooted at top,
       calling the callback function for each regular file'''

    for f in os.listdir(top):
        pathname = os.path.join(top, f)
        mode = os.stat(pathname)[ST_MODE]
        if S_ISDIR(mode):
            # It's a directory, recurse into it
            walktree(pathname, callback)
        elif S_ISREG(mode):
            if mode_matches("500",pathname):
                print pathname
        else:
            # Unknown file type, print a message
            print 'Skipping %s' % pathname

if __name__ == '__main__':
    walktree(sys.argv[1], visitfile)

