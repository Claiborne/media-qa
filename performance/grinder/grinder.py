from net.grinder.script.Grinder import grinder

scripts = ["boards_post_thread", "boards_get_thread"]

for script in scripts: exec("import %s" % script)

def createTestRunner(script):
	exec("x = %s.TestRunner()" % script)
	return x

class TestRunner:
	def __init__(self):
		tid = grinder.threadNumber

		if tid % 10 == 1:
			self.testRunner = createTestRunner(scripts[0])
		else:
  			self.testRunner = createTestRunner(scripts[0])
	def __call__(self):
		self.testRunner()

