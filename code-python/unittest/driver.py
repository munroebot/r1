
from doe import ActionPlan
from doe import User
import unittest

class TestStatisticalFunctions(unittest.TestCase):

    def test_StaticFullName(self):
        u1 = User("Brian Munroe")
        self.assertEqual(u1.getFullName(), "Brian Munroe")

    def test_StaticFunnyFullName(self):
        u2 = User("Mark Van Der Puy")
        self.assertEqual(u2.getFullName(), "Mark Van Der Puy")

    def test_FullName(self):
        u1 = User()
        u1.setFullName("Brian Johnson")
        self.assertEqual(u1.getFullName(), "Brian Johnson")

    def test_FunnyFullName(self):
        u1 = User()
        u1.setFullName("Mark Van Der Puy")
        self.assertEqual(u1.getFullName(), "Mark Van Der Puy")

unittest.main() # Calling from the command line invokes all tests
