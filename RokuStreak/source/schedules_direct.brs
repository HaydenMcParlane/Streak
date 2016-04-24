'
'   This document contains an API for use with the Schedules Direct
'   open source television data service.
'   @author: Hayden McParlane
'   @creation-date: 2.18.2016
Function FetchSchedulesDirectData() as void
    ' TODO: Some of these functions will need to be removed and placed elsewhere. I.e, GetSchedulesDirectAccountStatus() should be called
    ' when the application is first launched from the Roku shell (home screen). That way, account status can be checked asynchronously
    ' to ensure it's ready when the user begins to use it (or, if it's not, the user can be prompted to enter updated account info some
    ' how.    
    PopulateSchedulesDirectToken()
    ' TODO: Modify as appropriate. Cable headends may not need fetch. Only specialty call would get cable headends    
    'PopulateCableHeadends("USA", "66103")    
    PopulateStationsFromLineupUri("/lineups/USA-OTA-66103")    
    
    stations = GetSchedulesDirectStations()
    stations = stations["map"]
    temp = CreateObject("roArray", 1, True)
    num = 0    
    for each station in stations
        num = num + 1
        new = CreateObject("roAssociativeArray")
        new.AddReplace("stationID",station["stationID"])
        temp.Push(new)
        
        'if num = TempEntityCount()
        '    exit for
        'end if
                
    end for        
        
    PopulateSchedulesDirectData(temp)
    'PopulateProgramIDFromStationID()
    'PopulateProgramInfoFromProgramID()
    'TODO: Server error on below call. Figure out why and how to fix.
    'PopulateProgramDescription()
End Function

' TODO: PopulateSchedulesDirectAccountStatus()
' TODO: PopulateSchedulesDirectVersionInfo()
' TODO: PopulateSchedulesDirectServiceList()
' TODO: CheckSchedulesDirectAccountStatus()
' TODO: CheckSchedulesDirectClientVersion()

' TODO: Later on, ensure tokenize implements token refresh if needed
Function PopulateSchedulesDirectToken() as void ' This may need to be changed such that it returns something
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
    
        ' 4. Store result in m-hierarchy        
        AddUpdateSchedulesDirectToken(response.json["token"])            
        LogInfo("Tokenize Complete Successfully -> " + GetSchedulesDirectToken())
    end if
End Function

' TODO: What data structure to store for cable headends?
Function PopulateCableHeadends(country as String, zipcode as String)
    LogInfo("Fetching cable headends")    
    headers = CreateObject("roAssociativeArray")
    body = CreateObject("roAssociativeArray")
    
    ' 1. Populate headers and body for network packet    
    headers.AddReplace("User-Agent",SchedulesDirectUserAgentHeader())
    ' TODO: Token may not have been populated here, or may need to be refreshed.
    ' How to implement?
    headers.AddReplace("token",GetSchedulesDirectToken())
    
    ' 2. Make request to API
    response = AsyncGetRequest(SchedulesDirectJSONCableHeadendsUrl(country, zipcode), headers, body)
    
    ' 3. Check server status code (not HTTP status, that's checked in network module)            
    if response.headers["code"] = 3000
        LogErrorObj("Schedules Direct server offline. Try again later.", response.json)
        ' TODO: Program shouldn't be halted. What should be done here?
        stop
    end if          
    
    ' 4. Store result in m-hierarchy        
    AddUpdateSchedulesDirectCableHeadends(response.json)
    
    LogDebug("Fetch cable headends successful")            
End Function

Function PopulateStationsFromLineupUri(lineupUri as String) as void
    LogInfo("Fetching stations")    
    headers = CreateObject("roAssociativeArray")
    body = CreateObject("roAssociativeArray")
    
    ' 1. Populate headers and body for network packet    
    headers.AddReplace("User-Agent",SchedulesDirectUserAgentHeader())
    ' TODO: Token may not have been populated here, or may need to be refreshed.
    ' How to implement?
    headers.AddReplace("token",GetSchedulesDirectToken())
    
    ' 2. Make request to API
    response = GetRequest(SchedulesDirectJSONChannelMapUrl(lineupUri), headers, body)       
    
    ' 3. Check server status code (not HTTP status, that's checked in network module)            
    if response.headers["code"] = 3000 
        LogErrorObj("Schedules Direct server offline. Try again later.", response.json)
        ' TODO: Program shouldn't be halted. What should be done here?
        stop
    end if          
    
    ' 4. Store data
    AddUpdateSchedulesDirectStations(response.json)   
    
    LogDebug("Fetch stations successful")            
End Function

Function PopulateProgramIDsFromStationIDs(stationIDs as Object) as void ' TODO: replace params -> stationIDs as Object
    LogInfo("Fetching programs")    
    headers = CreateObject("roAssociativeArray")    
    station = CreateObject("roAssociativeArray")
    
    ' 1. Populate headers and body for network packet    
    headers.AddReplace("User-Agent",SchedulesDirectUserAgentHeader())
    ' TODO: Token may not have been populated here, or may need to be refreshed.
    ' How to implement?
    headers.AddReplace("token",GetSchedulesDirectToken())
    body = CreateObject("roArray", 4, True)            
    for i = 0 to TempEntityCount()           
        body.Push()
    end for
    tmp = CreateObject("roAssociativeArray")
    tmp.AddReplace("stationID","30912")
    body.Push(tmp)               
 
    ' 2. Make request to API
    response = AsyncPostRequest(SchedulesDirectJSONSchedulesUrl(), headers, body)
    
    ' 3. Check server status code (not HTTP status, that's checked in network module)            
    if response.headers["code"] = 3000
        LogErrorObj("Schedules Direct server offline. Try again later.", response.json)
        ' TODO: Program shouldn't be halted. What should be done here?
        stop
    end if          
    
    '######### NEW CODE ##########
    ' Issue async requests
    for each station in stationIDs
        RequestProgramIDs(station)
    end for
    
    '#############################
    
    'processedJSON = ProcessSchedulesDirectJSONStationPrograms(response.json)
    
    ' 4. Store result
    AddUpdateSchedulesDirectPrograms(response.json)
    
    LogDebug("Fetch programs succeeded")            
End Function

Function PopulateProgramInfoFromProgramID() as void ' TODO replace these params -> aProgramIDs as Object
    LogInfo("Fetching program info")    
    headers = CreateObject("roAssociativeArray")
    body = CreateObject("roArray", 1, True)
    
    body.Push("SH011425150000")
    body.Push("SH019486590000")
    
    ' 1. Populate headers and body for network packet    
    headers.AddReplace("User-Agent",SchedulesDirectUserAgentHeader())
    ' TODO: Token may not have been populated here, or may need to be refreshed.
    ' How to implement?
    headers.AddReplace("token",GetSchedulesDirectToken())
    headers.AddReplace("Accept-Encoding","deflate,gzip") ' TODO: Deplate gzip due to bug, may already be fixed
    
    ' 2. Make request to API
    response = AsyncPostRequest(SchedulesDirectJSONProgramInfoUrl(), headers, body)
    
    ' 3. Check server status code (not HTTP status, that's checked in network module)            
    if response.headers["code"] = 3000
        LogErrorObj("Schedules Direct server offline. Try again later.", response.json)
        ' TODO: Program shouldn't be halted. What should be done here?
        stop
    end if          
    
    ' 4. Store result 
    AddUpdateSchedulesDirectProgramInfo(response.json)
    
    ProcessSchedulesDirectJSONProgramInfo(response.json)        

    LogDebug("Fetch program data successful")            
End Function

Function PopulateProgramDescription() as void
    LogInfo("Fetching program descriptions")    
    headers = CreateObject("roAssociativeArray")
    'body = CreateObject("roAssociativeArray")
    body = CreateObject("roArray", 1, True)
    
    body.Push("SH011425150000")
    body.Push("SH019486590000")
    
    ' 1. Populate headers and body for network packet    
    headers.AddReplace("User-Agent",SchedulesDirectUserAgentHeader())
    'headers.AddReplace("Accept-Encoding","deflate,gzip") ' TODO: Deplate gzip due to bug, may already be fixed
    ' TODO: Token may not have been populated here, or may need to be refreshed.
    ' How to implement?
    headers.AddReplace("token",GetSchedulesDirectToken())
    'headers.AddReplace("Accept-Encoding","deflate,gzip") ' TODO: Deplate gzip due to bug, may already be fixed       
    
    ' 2. Make request to API
    response = AsyncPostRequest(SchedulesDirectJSONProgramDescriptionUrl(), headers, body)
    
    ' 3. Check server status code (not HTTP status, that's checked in network module)            
    if response.headers["code"] = 3000
        LogErrorObj("Schedules Direct server offline. Try again later.", response.json)
        ' TODO: Program shouldn't be halted. What should be done here?
        stop
    end if                    
    
    LogDebug("Fetch program descriptions successful")            
End Function        

'###################################################################################
' The following functions define the applications schedules direct
' data hierarchy present in m (i.e, m.schedulesAPI.data....). 
'###################################################################################
        
        
' TODO: Right now, two changes are required to each change of schedules direct access
' because the names are used here as well as the getter/setter functions. Better way
' to initialize? This function should be called immediately upon app launch.
' TODO: HIGH Remove this initialization in favor of each getter and setting creating object if non-existant.
' Use utility function CreateIfDoesntExistAndReturn etc...to allow for greater code reuse and magnified
' optimization when changes are made to CreateIfDoesntExist(...) if-else comparisons (i.e, hashing types?)
Function InitSchedulesDirectDataStore() as Boolean
    LogDebug("Initializing Schedules Direct data store")
    success = True
    ' !!! NOTE !!! THIS FUNCTION IS EXTREMELY SENSITIVE TO FUNCTION CALL ORDER. ONLY CHANGE
    ' IF YOU UNDERSTAND THE LOGICAL DESIGN OF THE M-HIERARCHY (I.E, m.schedulesAPI.data.... etc)
    base_dir = m.sapi 
    if base_dir = invalid        
        AddUpdateSchedulesDirectBase(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectBase() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop 
        end if
    end if
    
    network_dir = m.sapi.network
    data_dir = m.sapi.data
    
    if network_dir = invalid            
        AddUpdateSchedulesDirectNetwork(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectNetwork() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop 
        end if
    end if    
    if data_dir = invalid
        AddUpdateSchedulesDirectData(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectData() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop 
        end if
    end if
    
    headers_dir = m.sapi.network.headers
    cableHeadends_dir = m.sapi.data.cableHeadends
    stations_dir = m.sapi.data.stations
    programs_dir = m.sapi.data.programs
    programInfo_dir = m.sapi.data.programInfo    
    
    ' TODO: Update to include station table and program table
    
    if headers_dir = invalid        
        AddUpdateSchedulesDirectHeaders(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectHeaders() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop 
        end if
    end if
    if cableHeadends_dir = invalid
        AddUpdateSchedulesDirectCableHeadends(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectCableHeadends() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop 
        end if        
    end if
    if stations_dir = invalid
        AddUpdateSchedulesDirectStations(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectStations() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop
        end if
    end if
    if programs_dir = invalid
        AddUpdateSchedulesDirectPrograms(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectPrograms() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop
        end if
    end if
    if programInfo_dir = invalid
        AddUpdateSchedulesDirectProgramInfo(CreateObject("roAssociativeArray"))
        if GetSchedulesDirectProgramsInfo() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop
        end if
    end if
    
    token_loc = m.sapi.network.headers.token
    
    if token_loc = invalid
        AddUpdateSchedulesDirectToken("")
        if GetSchedulesDirectToken() = invalid
            LogError("Add/Update vs. Getter for data store are inconsistent")
            success = False
            stop 
        end if        
    end if        
    
    LogDebug("Initializing Schedules Direct data store successful")
    return success
End Function

Function AddUpdateSchedulesDirectProgramInfo(aaProgramInfo as Object) as void
    obj = GetSchedulesDirectData()
    obj.programInfo = aaProgramInfo
End Function

Function GetSchedulesDirectProgramsInfo() as Object
    obj= GetSchedulesDirectData()
    return obj.programInfo
End Function

Function AddUpdateSchedulesDirectPrograms(aaPrograms as Object) as void
    obj = GetSchedulesDirectData()
    obj.programs = aaPrograms
End Function

Function GetSchedulesDirectPrograms() as Object
    obj= GetSchedulesDirectData()
    return obj.programs
End Function

Function AppendStation(stationID as String) as Void
    obj = GetSchedulesDirectStations()
    newStation = CreateObject("roAssociativeArray")
    newStation.AddReplace("stationID", stationID)
    obj.Append(newStation)
End Function

Function AddUpdateSchedulesDirectStations(aaStations as Object) as void
    obj = GetSchedulesDirectData()
    obj.stations = aaStations
End Function

Function GetSchedulesDirectStations() as Object
    obj= GetSchedulesDirectData()
    return obj.stations
End Function


Function AddUpdateSchedulesDirectCableHeadends(aaCableHeadends as Object) as void
    obj = GetSchedulesDirectData()
    obj.cableHeadends = aaCableHeadends
End Function

Function GetSchedulesDirectCableHeadends() as Object
    obj= GetSchedulesDirectData()
    return obj.cableHeadends
End Function

Function AddUpdateSchedulesDirectData(aaData as Object) as void
    obj = GetSchedulesDirectBase()
    obj.data = aaData
End Function

Function GetSchedulesDirectData() as Object
    obj = GetSchedulesDirectBase()
    return obj.data
End Function

Function AddUpdateSchedulesDirectToken(newToken as String) as void
    obj = GetSchedulesDirectHeaders()
    obj.token = newToken
End Function

Function GetSchedulesDirectToken() as String
    obj = GetSchedulesDirectHeaders()
    return obj.token
End Function

Function AddUpdateSchedulesDirectHeaders(aaHeaders as Object) as void
    obj = GetSchedulesDirectNetwork()
    obj.headers = aaHeaders
End Function

Function GetSchedulesDirectHeaders() as Object
    obj = GetSchedulesDirectNetwork()  
    return obj.headers
End Function

Function AddUpdateSchedulesDirectNetwork(aaNetwork as Object) as void
    obj = GetSchedulesDirectBase()
    obj.network = aaNetwork
End Function

Function GetSchedulesDirectNetwork() as Object
    ' TODO: HIGH Test out below format and change all getters if good. Apply idea 
    ' to setter as well    
    ' return MGet(GetSchedulesDirectBase(), "network", "roAssociativeArray")
    key = "network"
    base = GetSchedulesDirectBase()
    CreateIfDoesntExist(base, key, "roAssociativeArray")
    return base[key]
End Function

Function AddUpdateSchedulesDirectBase(aaSchedulesDirectBase as Object) as Object
    base = GetSchedulesAPIBase()    
    base = aaSchedulesDirectBase
End Function

Function GetSchedulesDirectBase() as Object    
    return GetSchedulesAPIBase()
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

Function HasSchedulesDirectCableHeadends() as Boolean
    result = False
    if GetSchedulesDirectCableHeadends() = invalid
        ' Do nothing
    else
        result = True
    end if
    return result
End Function

Function SchedulesDirectUserAgentHeader() as String
    return "RokuStreak"
End Function

Function SchedulesDirectBaseJSONUrl() as String
    return "https://json.schedulesdirect.org/20141201"
End Function

Function SchedulesDirectJSONTokenUrl() as String
    return SchedulesDirectBaseJSONUrl() + "/token"
End Function

Function SchedulesDirectJSONCableHeadendsUrl(country as String, zipcode as String) as String
    ' TODO: Validate country entry style? Builder to translate entered strings into required strings?
    return SchedulesDirectBaseJSONUrl() + "/headends?country=" + country + "&" + "postalcode=" + zipcode
End Function

Function SchedulesDirectJSONChannelMapUrl(lineupUri as String) as String
    ' TODO: Validate country entry style? Builder to translate entered strings into required strings?
    return SchedulesDirectBaseJSONUrl() + lineupUri
End Function

Function SchedulesDirectJSONSchedulesUrl() as String
    ' TODO: Validate country entry style? Builder to translate entered strings into required strings?
    return SchedulesDirectBaseJSONUrl() + "/schedules"
End Function

Function SchedulesDirectJSONProgramInfoUrl() as String
    ' TODO: Validate country entry style? Builder to translate entered strings into required strings?
    return SchedulesDirectBaseJSONUrl() + "/programs"
End Function

Function SchedulesDirectJSONProgramDescriptionUrl() as String
    ' TODO: Validate country entry style? Builder to translate entered strings into required strings?
    return SchedulesDirectBaseJSONUrl() + "/metadata/description" 'TODO: Change back to metadata/description !!!
End Function

'###################################################################################
' Helper functions for accessing json formatted by schedules direct
'###################################################################################

Function ProcessSchedulesDirectJSONProgramInfo(json as Object) as Object    
    ' TODO: HIGH - Refactor and redesign such that processing of SD json data is
    ' both asynchronous and more modularized.

    for each program in json
        programID = program.programID
        newAA = CreateObject("roAssociativeArray")        
        newAA.ContentType = "episode"

        ' Append relevant key-value pairs
        AppendIfExists(program, newAA, SchedulesDirectKeyProgramID())         
        AppendIfExists(program.titles[0], newAA, SchedulesDirectKeyTitle("120"))        
        AppendIfExists(program, newAA, SchedulesDirectKeyMD5())
        AppendIfExists(program, newAA, SchedulesDirectKeyHasImageArtwork())
        AppendIfExists(program, newAA, SchedulesDirectKeyShowType())
        
        ' TODO: Refactor hashing here. Where should it occur so that reuse is maximized?
        ' This is crude implementation solely for demonstration soon to come.
        current = GetProgram(programId)
        'Hash results for quick access
        AppendToFilterList(EpisodeFilterTime(), current[SchedulesDirectKeyAirDateTime()], programID)
        'AppendToFilterList(EpisodeFilterGenre(), current[SchedulesDirectKeyGenres()], programID)
        
        if current.DoesExist("ratings")
            current["rating"] = current.ratings.body[0]
        end if      
        
        for each genre in program[SchedulesDirectKeyGenres()]
            AppendToFilterList(EpisodeFilterGenre(), genre, programID)
        end for
        
        progDesc = program.descriptions
        if program.DoesExist("descriptions")
            if progDesc.DoesExist("description100")
                d = program["descriptions"]["description100"]
                if d[0].DoesExist("description")
                    desc = d[0]["description"]
                    AppendIfExists(d[0], newAA, "description")            
                end if            
            else
            desc = "description"            
            end if
        else        
            desc = "description"
            current["description"] = desc
        end if
                        
        AppendIfExists(program, newAA, SchedulesDirectKeyOriginalAirDate())

        actorsArray = CreateObject("roArray", 1, True)
        for each actor in program["cast"]
            actorsArray.Push(actor["name"])
            LogDebug("Actor -> " + actor["name"])
        end for        
        LogDebugObj("Printing newAA in programs -> ", newAA)
        AppendToProgram(programID, newAA)
    end for      
    ' TODO: Better place to do title list update?
    times = GetEpisodes(EpisodeFilterTime())    
    genres = GetEpisodeSubcategory(EpisodeFilterGenre(), EpisodeSubcategoryData())
    timeKeys = times.Keys()
    AddUpdateEpisodeTitles(EpisodeFilterTime(), timeKeys)
    AddUpdateEpisodeTitles(EpisodeFilterGenre(), genres.Keys())
End Function

Function SchedulesDirectKeyProgramID() as String
    return "programID"
End Function

Function SchedulesDirectKeyDuration() as String
    return "duration"
End Function

Function SchedulesDirectKeyTitle(numStr as String) as String
    return "title" + numStr
End Function

Function SchedulesDirectKeyRatings() as String
    return "ratings"
End Function

Function SchedulesDirectKeyOriginalAirDate() as String
    return "originalAirDate"
End Function

Function SchedulesDirectKeyAirDateTime() as String
    return "airDateTime"
End Function

Function SchedulesDirectKeyGenres() as String
    return "genres"
End Function

Function SchedulesDirectKeyHasImageArtwork() as String
    return "hasImageArtwork"
End Function

Function SchedulesDirectKeyShowType() as String
    return "hasImageArtwork"
End Function

Function SchedulesDirectKeyMD5() as String
    return "md5"
End Function

'################################################################################
'   Auth
'################################################################################
Function SetSchedulesDirectAuthData(user as String, pass as String) as Object
    return SetAuthData(SchedulesDirectAuthSecName(), user, pass)
End Function

Function SchedulesDirectUsername() as Dynamic
    return GetAuthUsername(SchedulesDirectAuthSecName())
End Function

Function SchedulesDirectPassword() as Dynamic
    return GetAuthPassword(SchedulesDirectAuthSecName())
End Function

Function GetSchedulesDirectPasswordHashType() as String
    return "sha1"
End Function

Function SchedulesDirectAuthSecName() as String
    return "schedules_direct_auth"
End Function