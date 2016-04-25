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
import schedules.server.external.host as HOST
from schedules.server.storage.mongostore import MongoInterface as STORE
from enum import Enum as ENUM

_SD = "SchedulesDirect"

class Collector(object):
    '''Contract which must be adhered to by all collection objects'''
    def __init__(self):
        super(object, self).__init__()
        
    def collect(self, **kwargs):
        raise NotImplementedError()            
        
class SchedulesDirectCollector(Collector):
    _MAX_REQUESTS = 490    
    
    def __init__(self):
        super(Collector, self).__init__()
        self.client = HFACTORY.get(HTYPE.SCHEDULES_DIRECT)        
        self.client.register(self._filter_stationID, HOST.Services.GET_CHANNELS)
        self.client.register(self._filter_programID, HOST.Services.GET_CHANNEL_INFO)
        self.store = STORE()
        # self.client.register(self._adapter_series, HOST.Services.GET_SERIES_INFO)
        # self.client.register(self._adapter_episodes, HOST.Services.GET_EPISODES)
        
    def collect(self, **kwargs):        
        stations = self.client.consume(HOST.Services.GET_CHANNELS)        
        series = self.client.consume(HOST.Services.GET_CHANNEL_INFO, stations)                
        series_info = self.client.consume(HOST.Services.GET_EPISODES, series)        
        episode_info = self.client.consume(HOST.Services.GET_SERIES_INFO, series)

    # TODO: HIGH Use adapters to process data, add default hash filters (i.e,
    # genre, show time, etc) and store processed data.
    
    def _filter_stationID(self, json):
        with self.store as mongo:
            stations = list()
            count = self._MAX_REQUESTS          
            for station in json['map']:
                if count > 0:
                    sid = station['stationID']
                    stations.append({ 'stationID': sid})
                    count -= 1
                else:
                    break        
        return stations
    
    def _filter_programID(self, json):
        programs = list()
        count = self._MAX_REQUESTS
        print json            
        for station in json:
            for program in station['programs']:
                if count > 0:                
                    programs.append(program['programID'])
                    count -= 1
                else:
                    break                    
        return programs
    
    def _adapter_series(self, json):
        pass
    
    def _adapter_episodes(self, json):
        pass
        
def main():
    coll = SchedulesDirectCollector()
    coll.collect()
        
if __name__=="__main__":
    main()