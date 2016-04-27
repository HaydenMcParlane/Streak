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
import json as JSON
from schedules import config as CONFIG
from schedules.server.command import command as CMD

# Globals
HOSTNAME = CONFIG.S_HOSTNAME
PORT = CONFIG.S_PORT

RUN_IN_DEBUG = CONFIG.RUN_IN_DEBUG

###########################################################
#    Data
###########################################################

# TODO: Data operations should be dependent on abstract data
# structure to decouple the specific client implementation
# from the data representation model. Therefore, creation of
# optimized data structures for a given application (i.e, )
_EPISODES = "/episodes" 
@app.route(_EPISODES, methods = ["GET"])
def episodes():  
    if request.method == "GET":
        command = CMD.GetEpisodes()        
        episodes = command.invoke()
        return JSON.dumps(episodes)        
    else:
        raise HTTPMethodError()        
    
_SERIES = "/series"
@app.route(_SERIES, methods = ["GET"])
def series():
    return "series"

_CHANNELS = "/channels"
@app.route(_CHANNELS, methods = ["GET"])
def channels():
    return "channels"

_FILTERS = "/filters"
@app.route(_FILTERS, methods=["GET"])
def filter():
    return "filters"
    
###########################################################
#    Management
###########################################################
# TODO: Implement username and password update
_HOME = "/"
@app.route(_HOME, methods=["GET"])
def connection_status():
    return "connection active"

_LOGIN = "/login"
@app.route(_LOGIN, methods=["GET","POST","PUT", "DELETE"])
def login():
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
class HTTPMethodError(TypeError):
    pass


if __name__=="__main__":
    app.run(host=HOSTNAME, port=PORT, debug=RUN_IN_DEBUG)
