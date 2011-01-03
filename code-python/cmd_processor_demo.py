# @h:\python25\python -x %~f0 %* & exit /b

import cmd
import string, sys

class CLI(cmd.Cmd):

    def __init__(self):
        cmd.Cmd.__init__(self)
        self.prompt = 'pybue> '
        
    def do_hello(self, arg = None):
        print "hello again, " + arg + "!"

    def help_hello(self):
        print "syntax: hello [message]",
        print "-- prints a hello message"

    def do_quit(self, arg):
        sys.exit(1)

    def help_quit(self):
        print "syntax: quit",
        print "-- terminates the application"

    # shortcuts
    do_q = do_quit

if __name__ == '__main__':
	cli = CLI()
	cli.cmdloop()
