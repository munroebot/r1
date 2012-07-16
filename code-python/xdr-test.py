import xdrlib

p = xdrlib.Packer()

try:
	p.pack_double(8.01)
	print p.get_buffer()

except xdrlib.ConversionError, instance:
    print 'packing the double failed:', instance.msg

class Person(object):
    def __init__(self):
        self.first_name = None
        self.last_name = None

    def get_first_name(self):
        return self.first_name

