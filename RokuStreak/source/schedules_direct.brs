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
    InitSchedulesDirectCommunication()
    SchedulesDirectTokenize()
End Function

Function SchedulesDirectTokenize() as void ' This may need to be changed such that it returns something
                            ' such as an associative array
    if HasSchedulesDirectToken()        
        LogInfo("Token already present. Skipping tokenize.")
    else          
        LogInfo("Tokenizing with Schedules Direct")
        headers = CreateObject("roAssociativeArray")
        body = CreateObject("roAssociativeArray")
        
        ' 1. Populate headers and body for network packet
        headers.AddReplace("User-Agent",SchedulesDirectUserAgentHeader())
        body.AddReplace("username", SchedulesDirectUsername())
        body.AddReplace("password", SchedulesDirectPassword())        
        
        ' 2. Make request to API
        response = PostRequest(SchedulesDirectJSONTokenUrl(), headers, body)
        
        ' 3. Check server status code (not HTTP status, that's checked in network module)            
        if response.headers["code"] = 3000
            LogErrorObj("Schedules Direct server offline. Try again later.", response.json)
            ' TODO: Program shouldn't be halted. What should be done here?
            stop
        else if response.json["code"] <> 0
            LogErrorObj("Schedules Direct response status code non-zero (Abnormal).", response.json)
            stop
        end if
    
        ' 4. Store token in system variable        
        AddUpdateSchedulesDirectToken(response.json["token"])        
    ' TODO: *** NEXT MAIN TASK *** extract information from response, store token, proceed with communication
    ' with schedules direct to receive data to display in TV Schedule "view"
        LogInfo("Tokenize Complete Successfully -> " + GetSchedulesDirectToken())
    end if   
End Function

' TODO: Right now, two changes are required to each change of schedules direct access
' because the names are used here as well as the getter/setter functions. Better way
' to initialize?
Function InitSchedulesDirectCommunication() as void
    if m.schedulesAPI = invalid
        m.schedulesAPI = CreateObject("roAssociativeArray")
    end if
    if m.schedulesAPI.headers = invalid
        m.schedulesAPI.headers = CreateObject("roAssociativeArray")
    end if    
    if m.schedulesAPI.headers.token = invalid
        m.schedulesAPI.headers.token = ""
    end if
End Function

Function AddUpdateSchedulesDirectToken(newToken as String) as void
    m.schedulesAPI.headers.token = newToken
End Function

Function GetSchedulesDirectToken() as String
    return m.schedulesAPI.headers.token
End Function

Function AddUpdateSchedulesDirectHeaders(aaHeaders as Object) as Object        
    m.schedulesAPI.headers = headers
End Function

Function GetSchedulesDirectHeaders() as Object        
    return m.schedulesAPI.headers
End Function

Function AddUpdateSchedulesDirectObj(aaSchedulesDirectBase as Object) as Object    
    m.schedulesAPI = aaSchedulesDirectBase
End Function

Function GetSchedulesDirectObj(aaBasePath as Object) as Object    
    return m.schedulesAPI
End Function

Function HasSchedulesDirectToken() as Boolean
    result = False    
    if GetSchedulesDirectToken() = ""
        ' Do nothing
    else
        result = True
    end if
    return result
End Function

Function SchedulesDirectUsername() as String
    return Username()
End Function

Function SchedulesDirectPassword() as String
    return Sha1Digest(RawPassword())
End Function

Function SchedulesDirectUserAgentHeader() as String
    return "RokuStreak"
End Function