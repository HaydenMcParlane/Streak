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
from scram import helper as HELPER
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
        self.client.register(self._adapter_episodes, HOST.Services.GET_EPISODES)        
        self.store = STORE()
        # self.client.register(self._adapter_series, HOST.Services.GET_SERIES_INFO)
        # self.client.register(self._adapter_episodes, HOST.Services.GET_EPISODES)
        
    def collect(self, **kwargs):
        # TODO: HIGH call to series corresponds to lengthy paragraph sent by
        # sched. dir. from program_description. The episode info comes first
        # in the request sequence.        
        channel_ids = self.client.consume(HOST.Services.GET_CHANNELS)        
        episode_shard1, program_ids = self.client.consume(HOST.Services.GET_CHANNEL_INFO, channel_ids)                
        episode_shard2 = self.client.consume(HOST.Services.GET_EPISODES, program_ids)        
        # TODO: Make sure  all episodes are included otherwise if episode_shard1.size not equal
        # to episode_shard2 then episodes will be left out. 
        #Combine episode objects
        # TODO: All of this logic needs to be refined to be more maintainable and
        # flexible, separation of concerns
        for key, value in episode_shard1.iteritems():
            episode_shard1[key].update(episode_shard2[key])
            episode = episode_shard1[key]
            self.store.insert("streak", 'episodes', data=episode)
               
        series_info = self.client.consume(HOST.Services.GET_SERIES_INFO, program_ids)

    # TODO: HIGH Use adapters to process data, add default hash filters (i.e,
    # genre, show time, etc) and store processed data.
    
    def _filter_stationID(self, json):        
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
        episodes = dict()
        for station in json:
            for program in station['programs']:
                if count > 0:
                    # TODO: HIGH Find way to map keys to one another so that
                    # mapping isn't hard coded and can be reused.
                    episode = dict()       
                    
                    # Required fields
                    # TODO: MID Construct hashing system to allow for application of obvious
                    # filters such as by channel, time, genre, etc.
                    episode['contenttype'] = "episode"
                    episode['channelID'] = station['stationID']
                    episode['programID'] = program['programID']
                    episode['channel_md5'] = program['md5']
                    
                    # Optional fields
                    episode['length'] = HELPER.value(program, 'duration')
                    episode['audioProperties'] = HELPER.value(program, 'audioProperties')
                    episode['videoProperties'] = HELPER.value(program, 'videoProperties')
                    #episode['new'] = program['new'] or "None"
                    episode['releasedate'] = HELPER.value(program, 'airDateTime')                    
                    
                    episodes[program['programID']] = episode
                    
                    # Process program for next request
                    programs.append(program['programID'])
                    count -= 1
                else:
                    break             
        # TODO: HIGH Append to episode object        
        return ( episodes, programs )
    
    def _adapter_episodes(self, json):
        episodes = dict()
        count = 1
        for ep in json:
            # TODO: Remove if False stmt. DEBUG purposes
            if False:#count >= 1:
                count -= 1
            episode = dict()       
            keys = ['titles', 0, 'title']                 
            title = HELPER.getvalue(ep, keys, verbatim=False)                        
            keys = ['episodetitle']            
            eptitle = HELPER.getvalue(ep, keys, verbatim=False)
            episode['title'] = title
            episode['type'] = HELPER.value(ep, 'eventDetails')            
            keys = ['descriptions', 'description', 0, 'description']
            description = HELPER.getvalue(ep, keys, verbatim=False)
            episode['shortdescriptionline1'] = eptitle
            snum = HELPER.getvalue(ep, ['metadata', 0, 'Gracenote', 'season'], verbatim=False)
            epnum = HELPER.getvalue(ep, ['metadata', 0, 'Gracenote', 'episode'], verbatim=False)            
            episode['releasedate'] = HELPER.value(ep, 'originalAirDate')
            episode['actors'] = list()
            if HELPER.has_key(ep, 'cast'):
                for actor in ep['cast']:
                    episode['actors'].append(actor['name'])
            if HELPER.has_key(ep, 'crew'):
                episode['director'] = ep['crew'][0]['name']
            if HELPER.has_key(ep, 'hasImageArtwork'):
                episode['hasimageartwork'] = ep['hasImageArtwork']
            episode['episode_md5'] = ep['md5']
            episodes[ep['programID']] = episode
        return episodes
    
    def _adapter_series(self, json):
        pass
        
def main():
    coll = SchedulesDirectCollector()
    coll.collect()
        
if __name__=="__main__":
    main()