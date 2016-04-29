###########################################################
#	Configuration specifications
###########################################################
from schedules.server.storage.mongostore import MongoInterface as _INTERFACE

DATASTORE = _INTERFACE

USERNAME = 'username'
PASSWORD = 'password'

S_HOSTNAME = '0.0.0.0'
S_PORT = 10023

RUN_IN_DEBUG=True