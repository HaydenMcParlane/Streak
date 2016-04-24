import host

def main():
	server = host.SchedulesDirectServer()
	service = host.SchedulesDirectServices.GETCHANNELS.value
	data = {}
	json = server.consume(service, data)
	return json

if __name__=="__main__":
	main()
