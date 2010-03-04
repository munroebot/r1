import xdrlib

p = xdrlib.Packer()
try:
	p.pack_double(8.01)
	print p.get_buffer()

except xdrlib.ConversionError, instance:
    print 'packing the double failed:', instance.msg
