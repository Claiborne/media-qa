from net.grinder.script import Test
from net.grinder.script.Grinder import grinder
from net.grinder.plugin.http import HTTPRequest

tid = grinder.threadNumber

test1 = Test(1, "view forum thread on new boards")
request1 = test1.wrap(HTTPRequest())

class TestRunner:
	def __call__(self):
		result = request1.GET("http://xenforo.swiessbrod.dev.www.ign.com/boards/threads/profanity.10/")

