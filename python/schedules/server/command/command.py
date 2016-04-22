###########################################################
#	Server-side commander interface
#	@author: Hayden McParlane
#	@creation-date: 4.21.2016
#	@description:
#		This interface is used by public server APIs to deliver
#		reusable, atomic transactions.
###########################################################
from pypatterns.commander import Command as CMD
from schedules.data import episode as EP

class ServerCommand(CMD):
    def __init__(self):
        super(CMD, self).__init__()

###########################################################
#    Data manipulation
###########################################################
class GetEpisodes(ServerCommand):    
        
    def execute(self, **kwargs):
        