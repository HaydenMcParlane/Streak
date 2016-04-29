'
'   Client for consuming schedules API
'   @author: Hayden McParlane
'   @creation-date: 4.28.2016
Function SchedulesClientEpisodes() as object
    body = CreateObject("roAssociativeArray")
    headers = CreateObject("roAssociativeArray")
    
    response = GetRequest(EpisodesUrl(), headers, body)
    
    ' TODO: Check status codes
    return response.json    
End Function

Function EpisodesUrl() as String
    return ServerHost() + "/episodes"
End Function

Function ServerHost() as String
    return ServerHostName() + ":" + ServerHostPort()
End Function

Function ServerHostName() as String ' TODO: CHANGE
    return "192.168.1.118"
End Function

Function ServerHostPort() as String
    return "10023"
End Function