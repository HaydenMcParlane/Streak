###########################################################
#	Restful API for user (public facing)
#	@author: Hayden McParlane
#	@creation-date: 4.20.2016
#	@description: 
#		Defined restful interface operations are imported
#		into this module to allow the publicly facing
#		interface to be flexible (i.e, composable from
#		different restful interface modules such as security,
#		etc.
###########################################################
from flask import Flask
app = Flask(__name__)

import flask
from flask import request
from schedules.server.command import command as CMD

# Access URL Configurations
_HOME = "/" # Flask interprets this as the home url
_EPISODES = "/episodes"
_SERIES = "/series"
_CHANNELS = "/channels"

# Runtime configurations
_RUN_IN_DEBUG = False

###########################################################
#    Data
###########################################################

# TODO: Data operations should be dependent on abstract data
# structure to decouple the specific client implementation
# from the data representation model. Therefore, creation of
# optimized data structures for a given application (i.e, )
 
@app.route(_EPISODES, methods = ["GET"])
def episodes():
    '''Get episode(s)'''  
    if request.method == "GET":
        command = CMD.GetEpisodes()
        options = dict()
        command.invoke(options)
    else:
        raise HTTPMethodError()        
    
@app.route(_SERIES, methods = ["GET"])
def series():
    return "series"

@app.route(_CHANNELS, methods = ["GET"])
def channels():
    return "channels"
    
###########################################################
#    Management
###########################################################
# TODO: Implement username and password update

@app.route(_HOME, methods=["GET"])
def connection_status():
    return "connection active"

@app.route(_CREDENTIALS, methods=["GET","POST","PUT", "DELETE"])
def credentials():
    if request.method == "GET":
        raise NotImplementedError()
    elif request.method == "POST":
        raise NotImplementedError()
    elif request.method == "PUT":
        raise NotImplementedError()
    elif request.method == "DELETE":
        raise NotImplementedError()
    else:
        raise HTTPMethodError()
    
###########################################################
#    Exceptions/Errors
###########################################################
class HTTPMethodError(Error):
    pass


if __name__=="__main__":
    app.run(host="localhost", port=10023, debug=_RUN_IN_DEBUG)
