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
import host
from enum import Enum as ENUM

_SD = "SchedulesDirect"

class Collector(object):
    '''Contract which must be adhered to by all collection objects'''
    def __init__(self):
        super(object, self).__init__()
        
    def run(self, **kwargs):
        raise NotImplementedError()            
        
class SchedulesDirectCollector(Collector):    
    def __init__(self):
        super(Collector, self).__init__()
        self.server = HFACTORY.get(HTYPE.SCHEDULES_DIRECT)
        self.service_list = [host.Channels(), host.ChannelInfo(), host.Series()
                             host.Episodes() ]
        
    def run(self, **kwargs):
        data = {}
        data = self.server.consume()
        # TODO: Process raw data
        
        # TODO: Store data
        
        