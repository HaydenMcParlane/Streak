###########################################################
#	Host abstraction providing contract for all host
#	objects to follow. 
#	@author: Hayden McParlane
#	@creation-date: 4.22.2016
#	@description:
#		Host objects make communication with external
#		servers more readable. These objects will
#		facilitate data encapsulation for external
#		hosts that are used by this server system.
###########################################################
from enum import Enum as ENUM
from scram import helper as HELPER
from scram.helper import StateHolder as STATE
from schedules.server.globals import Data as DATA
import json
import requests as REQ
from mate_invest.defs import DATA_DIR


#####################################################################
#	Module helper functions
#####################################################################
def url_str(lst):
	return "/".join(lst)


#####################################################################
#	Main Module Components
#####################################################################	
class HTTPMethods(ENUM):
	POST = "POST"
	GET = "GET"
	PUT = "PUT"
	DELETE = "DELETE"
	
class RequestFactory(object):
	_CATALOG = {HTTPMethods.GET : REQ.get,
				HTTPMethods.POST : REQ.post}
	@classmethod
	def get(cls, method):		
		try:			
			return RequestFactory._CATALOG[method]
		except Exception as e:
			print e
			raise ValueError()
	
class Services(ENUM):
	TOKEN = "token" 
	HEADENDS = "hends" 
	CHANNELS = DATA.CHANNELS
	SERIES = DATA.SERIES 
	EPISODES = DATA.EPISODES

class Service(STATE):
	_URLCOM = "url_components"
	_METHODS = "httpmethods"
	_DATA = "data"
	def __init__(self):
		STATE.__init__(self)
		self._setbody(None)
		self._setheaders(None)
		STATE.add(self, self._URLCOM, list())
		STATE.add(self, self._METHODS, list())
	
	def urlappend(self, value):
		STATE.add(self, self._URLCOM, value, mode="append")
		
	def methodappend(self, value):
		STATE.add(self, self._METHODS, value, mode="replace")
		
	def url(self):
		components = STATE.get(self, self._URLCOM)
		return "/".join(components)
	
	def method(self):
		# TODO: MID Make is so that different methods
		# can be registered and used.
		return STATE.get(self, self._METHODS)
	
	def body(self):
		return self._getbody()
	
	def headers(self):
		return self._getheaders()
	
	def load(self, headers, body):
		self.load_body(body)
		self.load_headers(headers)
	
	def load_body(self, data):
		if not isinstance(data, dict) and not isinstance(data, list):
			raise TypeError()
		else:
			print "loading body: "
			print data
			self._setbody(data)
			
	
	def load_headers(self, headers):			
		if not isinstance(headers, dict):
			raise TypeError()
		else:
			print "loading headers: "
			print headers
			self._setheaders(headers)
	
	def invoke(self, headers, data):		
		self.load(headers, data)		
		httpmethod = RequestFactory.get(self.method())
		print self.url()
		response = httpmethod(self.url(), data=json.dumps(self.body()), headers=self.headers())
		print response.text
		# TODO: Handle response return HTTP status codes
		return response.json()
		
	def ready(self):
		if self._getheaders() is not None and self._getbody() is not None:
			return True
		else:
			return False
	
	def _setheaders(self, headers):
		self.h = headers
	
	def _getheaders(self):
		return self.h
	
	def _setbody(self, body):
		self.b = body
	
	def _getbody(self):
		return self.b

class SchedulesDirectService(Service):
	_BASE = "https://json.schedulesdirect.org"
	_VERSION = "20141201"
	def __init__(self):
		Service.__init__(self)
		Service.urlappend(self, "https://json.schedulesdirect.org") # TODO: LOW separate protocol from domain name
		
class Token(SchedulesDirectService):
	def __init__(self):
		SchedulesDirectService.__init__(self)
		Service.urlappend(self, SchedulesDirectService._VERSION)		
		Service.urlappend(self, "token")
		Service.methodappend(self, HTTPMethods.POST)	
		
class Channels(SchedulesDirectService):
	def __init__(self):
		SchedulesDirectService.__init__(self)
		Service.urlappend(self, SchedulesDirectService._VERSION)		
		Service.urlappend(self, "lineups")
		Service.urlappend(self, "USA-OTA-66103")
		Service.methodappend(self, HTTPMethods.GET)
		
class ChannelInfo(SchedulesDirectService):
	def __init__(self):
		SchedulesDirectService.__init__(self)
		Service.urlappend(self, SchedulesDirectService._VERSION)		
		Service.urlappend(self, "schedules")
		Service.methodappend(self, HTTPMethods.POST)
		
class Series(SchedulesDirectService):
	def __init__(self):
		SchedulesDirectService.__init__(self)
		Service.urlappend(self, SchedulesDirectService._VERSION)		
		Service.urlappend(self, "programs")
		Service.methodappend(self, HTTPMethods.POST)
		
class Episodes(SchedulesDirectService):
	def __init__(self):
		SchedulesDirectService.__init__(self)
		Service.urlappend(self, SchedulesDirectService._VERSION)		
		Service.urlappend(self, "metadata")
		Service.urlappend(self, "description")		
		Service.methodappend(self, HTTPMethods.POST)

class HostType(ENUM):
	SCHEDULES_DIRECT = 1
	
class Host(object):
	pass

class Client(Host):
	def __init__(self):
		super(Host, self).__init__()
		
class Server(Host):
	def __init__(self):
		super(Host, self).__init__()
		
	def get(self, **kwargs):
		raise NotImplementedError()		

class SchedulesDirectServer(Server, STATE):	
	_TOKEN = "token"
	_HEADERS = "headers"	
	_USERNAME = "umkcsce"
	_PASSWORD = "umkcsceresearch"
	
	def __init__(self):
		Server.__init__(self)
		STATE.__init__(self)
		STATE.add(self, self._HEADERS, { "user-agent" : "RokuStreak" , "verbose": True, "token" : "",
										"Accept-Encoding":"identity,deflate,gzip"} )
	
	def consume(self, service, data, **kwargs):
		if not isinstance(service, SchedulesDirectService):
			raise TypeError()
		else:				
			if not self._token_is_current():
				self._update_token()			
			headers = STATE.get(self, self._HEADERS)
			result = self._invoke_service(service, headers, data)			
			return result
		
	def _invoke_service(self, service, headers, data):
		return service.invoke(headers, data)
	
	def _update_token(self):
		if not self._token_is_current():#self._token_is_current():
			# TODO: tokenize shouldn't occur automatically here. it should only occur if needed			
			service = Token()
			body = {"username":self._USERNAME,	
					"password" : HELPER.hash(self._PASSWORD, hexdigest=True)}
			headers = STATE.get(self, self._HEADERS)
			result = self._invoke_service(service, headers, body)
			headers[self._TOKEN] = result["token"]
			STATE.update(self, self._HEADERS, headers, mode="replace")		
	
	def _token_is_current(self):		
		if not STATE.get(self, self._TOKEN) in [None, ""]:
			return True
		else:
			return False		
		
		
class HostFactory(object):
	_HOSTS = { HostType.SCHEDULES_DIRECT : SchedulesDirectServer() }
	
	def __init__(self):
		super(object, self).__init__()
		
	def hosts(self):
		return self._HOSTS
		
	@classmethod
	def get(cls, htype):
		hosts = hosts()
		return hosts[htype]
	
class SchedulesDirectServices(ENUM):
	TOKEN = Token()
	GETCHANNELS = Channels()
	GETSERIES = Series()
	GETEPISODES = Episodes()

##############################################################################
#	Exceptions and Errors
##############################################################################	
class ReadyStateError(IOError):
	pass

