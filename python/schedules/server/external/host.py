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
import json
import requests as REQ


#####################################################################
#	Module helper functions
#####################################################################
def url_str(lst):
	return "/".join(lst)


#####################################################################
#	Main Module Components
#####################################################################
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
	_BASE = "https://json.schedulesdirect.org"
	_VERSION = "20141201"	
	_TOKEN = "token"
	_USERNAME = "umkcsce"
	_PASSWORD = "umkcsceresearch"
	
	class Services(ENUM):
		TOKEN = "token" 
		HEADENDS = "hends" 
		CHANNELS = "channels"
		SERIES = "sinfo" 
		EPISODES = "einfo"
		
	_URL_CATALOG = {Services.TOKEN : url_str( [_BASE, _VERSION, "token"] ),
					Services.HEADENDS : url_str( [_BASE, _VERSION, "headends?country=usa&postalcode=66103"] ), # TODO: Remove hardcoded country and zip
					Services.CHANNELS : url_str( [_BASE, _VERSION, "lineups", "USA-OTA-66103"] ),
					Services.SERIES : url_str( [_BASE, _VERSION, "programs"] ),
					Services.EPISODES : url_str( [_BASE, _VERSION, "metadata", "description"] )}
	
	def __init__(self):
		super(Server, self).__init__()
		super(STATE, self).__init__()
		
	def _update_token(self):
		if True:#self._token_is_current():
			# TODO: tokenize shouldn't occur automatically here. it should only occur if needed
			url = self._resolve_to_url(self.Services.TOKEN)			
			response = REQ.post(url, data=json.dumps({ "username":self._USERNAME,
										"password":HELPER.hash(self._PASSWORD, hexdigest=True)})).json()			
			STATE.add(self, self._TOKEN, response[self._TOKEN])
		else:
			raise NotImplementedError()
		
	def _token_is_current(self):
		# TODO: Actually implement token current check
		return True
		
	def _catalog(self):
		return self._URL_CATALOG
	
	def _resolve_to_url(self, service):
		c = self._catalog()
		return c[service]
	
	def get(self, service, **kwargs):
		self._update_token()
		headers = { "user-agent":"RokuStreak", "token":STATE.get(self, self._TOKEN), "verbose":True }
		response = REQ.get(self._resolve_to_url(service), headers=headers)
		print response.status_code
		print response.json()
		return response.json()

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
	