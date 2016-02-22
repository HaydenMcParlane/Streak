'
'   This document contains an API for use with the Schedules Direct
'   open source television data service.
'   @author: Hayden McParlane
'   @creation-date: 2.18.2016
Function SchedulesDirectBaseJsonUrl() as String
    return "https://json.schedulesdirect.org/20141201"
End Function

Function SchedulesDirectJSONTokenUrl() as String
    return SchedulesDirectBaseJsonUrl() + "/token"
End Function

Function SearchSchedulesDirect() as void
    Tokenize()
End Function

Function Tokenize() as void ' This may need to be changed such that it returns something
                            ' such as an associative array
    
    ' Need to check to make sure token isn't already defined *** TODO
    LogInfo("Tokenizing with Schedules Direct")
    body = CreateObject("roAssociativeArray")
    body.AddReplace("username", Username())
    body.AddReplace("password", Password())        
    
    response = PostRequest(SchedulesDirectJSONTokenUrl(), invalid, body)  
    LogDebug("Value of response.body -> " + response.jsonString)
    LogDebugObj("Value of response.json -> ", response.json)
    for each header in response.headers    
        LogDebugObj("Value of response.headers -> ", header)           
    end for
    LogInfo("Tokenize Complete Successfully")    
End Function
