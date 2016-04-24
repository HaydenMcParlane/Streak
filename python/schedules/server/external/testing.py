import host
from twisted.internet.unix import Client

_MAX = 490

def main():
	client = host.SchedulesDirectClient()
	service = host.SchedulesDirectServices.GETCHANNELS.value
	data = {}
	json = client.consume(service, data)	
	json = json['map']
	data = list()
	for i in range(len(json) - 1):
		sid = json[i]["stationID"]
		data.append( {"stationID":sid} )	
	service = host.ChannelInfo()
	json = client.consume(service, data)
	
	programs = list()
	count = _MAX
	for i in range(len(json) - 1):
		for j in range(len(json[i]['programs']) - 1):
			if count > 0:
				pid = json[i]['programs'][j]['programID']
				programs.append(pid)
				count -= 1
			else:
				break
		
	service = host.Series()
	data = programs
	json = client.consume(service, data)
	
	service = host.Episodes()
	data = programs
	json = client.consume(service, data)
	
	return json

if __name__=="__main__":
	main()
