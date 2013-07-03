import imp

# Dynamic loading of modules "Plugins"

def get_plugin(name):
	fm = imp.find_module(name, ['plugins']) 
	mymod = imp.load_module('plugins.' + name, *fm)
	return mymod

pi = get_plugin("plugin-a")
print pi.hello()

pi = get_plugin("plugin-b")
print pi.hello()
