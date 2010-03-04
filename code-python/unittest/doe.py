class ActionPlan(object):
    def __init__(self):
        self.title = ""

    def toString(self):
        return self.title + "!"

class User(object):
    def __init__(self,fullName=None):
        self.fullName = fullName

    def setFullName(self,fullname):
        self.fullName = fullname

    def getFullName(self):
        return self.fullName