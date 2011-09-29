from net.grinder.script import Test
from net.grinder.script.Grinder import grinder
from net.grinder.plugin.http import HTTPRequest
from jarray import zeros
from HTTPClient import Codecs, NVPair
from net.grinder.plugin.http import HTTPPluginControl
from HTTPClient import Cookie, CookieModule, CookiePolicyHandler
from HTTPClient import AuthorizationInfo

log = grinder.logger.output
 
# Set up a cookie handler to log all cookies that are sent and received.
class MyCookiePolicyHandler(CookiePolicyHandler):
    	def acceptCookie(self, cookie, request, response):
        	log("accept cookie: %s" % cookie)
        	return 1
 
        def sendCookie(self, cookie, request):
        	log("send cookie: %s" % cookie)
       	 	return 1
 
CookieModule.setCookiePolicyHandler(MyCookiePolicyHandler())

HTTPPluginControl.getConnectionDefaults().useAuthorizationModule = 1

boardpost = Test(2, "post to boards forum thread")
request1 = boardpost.wrap(HTTPRequest())

class TestRunner:
	def __call__(self):
                parameters = (
                  	NVPair("email", "media-qa@ign.com"),
                        NVPair("password","b1x2f3ss"),
                        NVPair("r","http://www.ign.com/boards/threads/profanity.10"),
                        NVPair("al","0"),
            	)
                headers = zeros(1, NVPair) 

                data = Codecs.mpFormDataEncode(parameters, (), headers)
		result = request1.POST("http://my.ign.com/login?al=0", data, headers)
               
                result3 = request1.GET("http://www.ign.com/boards/threads/profanity.10") 
                log("result: %s" % result3.text) 
                parameters1 = ( NVPair("message_html", "<p>test reply</p>"),                             
                               NVPair("_xfRelativeResolver","http://www.ign.com/boards/threads/profanity.10/" ),
                               NVPair("watch_thread_state", "1"),
                               NVPair("last_date", "1316801340"),
                               NVPair("_xfToken", "19,1316810193,49fff39e6fb753eaee4933cb94ac4c49a1cc99e6"),
                               NVPair("_xfRequestUri", "/boards/threads/profanity.10/"),
                               NVPair("_xfNoRedirect","1"),
                               NVPair("_xfToken","19,1316810193,49fff39e6fb753eaee4933cb94ac4c49a1cc9e6"),
                               NVPair("_xfResponseType","json"),
                )
 
                data1 = Codecs.mpFormDataEncode(parameters1, (), headers)

                result2 = request1.POST("http://www.ign.com/boards/threads/profanity.10/add-reply", data1, headers ) 

                 # Get all cookies for the current thread and write them to the log
                 # cookies = CookieModule.listAllCookies(threadContext)
                 # for c in cookies: log("retrieved cookie: %s" % c)
 
                 # grinder.logger.output("post: %s" % result2)

	# Utility method that writes the given string to a uniquely named file
	# using a FilenameFactory.
	def writeToFile(text):
    		filename = grinder.getFilenameFactory().createFilename(
        	"page", "-%d.html" % grinder.runNumber)
 
    		file = open(filename, "w")
    		print >> file, text
    		file.close()
