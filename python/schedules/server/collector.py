#############################################################
#	Module for interacting with external APIs from which
#	data is collected and processed.
#	@author: Hayden McParlane
#	@creation-date: 4.22.2016
#   @description: 
#        The collector is responsible for collecting data from some source
#        to be processed and/or used by the server.
#############################################################
from schedules.server.external.host import HostType as HTYPE
from schedules.server.external.host import HostFactory as HFACTORY
from schedules.server.external.host import SchedulesDirectClient as CLIENT
from enum import Enum as ENUM

_SD = "SchedulesDirect"

class Collector(object):
    '''Contract which must be adhered to by all collection objects'''
    def __init__(self):
        super(object, self).__init__()
        
    def collect(self, **kwargs):
        raise NotImplementedError()            
        
class SchedulesDirectCollector(Collector):
    class DataType(ENUM):
        SERIES = CLIENT.SERIES 
        EPISODES = CLIENT.EPISODES
    
    def __init__(self):
        super(Collector, self).__init__()
        self.server = HFACTORY.get(HTYPE.SCHEDULES_DIRECT)
        
    def collect(self, **kwargs):
        data = self.server.get(self.server.Services.CHANNELS)
        
        
        