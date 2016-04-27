###########################################################
#	Server-side commander interface
#	@author: Hayden McParlane
#	@creation-date: 4.21.2016
#	@description:
#		This interface is used by public server APIs to deliver
#		reusable, atomic transactions.
###########################################################
from pypatterns.commander import Command as CMD
from schedules.server.storage.mongostore import MongoInterface as CLIENT

class ServerCommand(CMD):
    def __init__(self):
        super(CMD, self).__init__()

###########################################################
#    Data manipulation
###########################################################
class GetEpisodes(ServerCommand):    
        
    def execute(self, **kwargs):
        # TODO: Modify so that options are specifiable in kwargs (not hardcoded - find() returns directly
        # from database=streak, collection=episodes.        
        return CLIENT().find()        

if __name__=="__main__":
    pass