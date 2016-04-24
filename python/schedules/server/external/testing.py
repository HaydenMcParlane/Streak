import host

def main():
	server = host.SchedulesDirectServer()
	service = host.SchedulesDirectServices.GETCHANNELS.value
	data = {}
	json = server.consume(service, data)	
	json = json['map']
	data = list()
	for i in range(len(json) - 1):
		sid = json[i]["stationID"]
		data.append( {"stationID":sid} )	
	service = host.ChannelInfo()
	json = server.consume(service, data)
	return json

if __name__=="__main__":
	main()
