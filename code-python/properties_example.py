
class Airplane(object):

    def __init__(self, hourValue, minuteValue, secondValue, brand):
        self.__hour = hourValue
        self.__minute = minuteValue
        self.__second = secondValue
        self.__brand = brand

    def __str__(self):
        return "%.2d:%.2d:%.2d" % (self.__hour, self.__minute, self.__second)

    def getHours(self):
        return self.__hour

    def setHours(self,value):
        self.__hour = value * 2

    def deleteHours(self):
        del self.__hour

    def getBrand(self):
        return self.__brand

    def setBrand(self,value):
        self.__brand = value

    def deleteBrand(self):
        del self.__brand

    hour = property(getHours,setHours,deleteHours,"Hour property")
    brand = property(getBrand,setBrand,deleteBrand,"Brand property")

a = Airplane(1,20,20,'Coke')

print
print "Airplane Object toString:\t\t\t", a
print "Airplane Object hour property:\t\t\t",  a.hour
print "Airplane Object brand property:\t\t\t", a.brand

print

print "Setting Airplane Object property hour to 10"
print "Setting Airplane Object property brand to Pepsi"

print

a.hour = 10
a.brand = 'Pepsi'

print "Airplane Object toString:\t\t\t", a
print "Airplane Object hour property:\t\t\t", a.hour
print "Airplane Object brand property:\t\t\t", a.brand
