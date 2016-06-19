###########################################################
#	Configuration specifications
###########################################################
from schedules.server.storage.mongostore import MongoInterface as _INTERFACE

DATASTORE = _INTERFACE

USERNAME = 'umkcsce' # TODO: CHANGE
PASSWORD = 'somecomplexpassword'

S_HOSTNAME = '0.0.0.0'
S_PORT = 10023

# IMPORTANT - DEBUG MUST BE SET TO FALSE FOR DEPLOYMENTS.
# LEAVING DEBUG AS TRUE MEANS LEAVING A SERIOUS SECURITY
# VULNERABILITY IN THE SYSTEM
RUN_IN_DEBUG=True
