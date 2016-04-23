'
'   This document functions as the interface into television schedules for the project.
'   It decouples the screens from the back-end API used to gather TV scheduling information.
'   @author: Hayden McParlane
Function PopulateTVData() as void ' TODO: Change return type to AA for render results
    FetchSchedulesDirectData()    
End Function

Function SetSchedulesAPIAuthData(user as String, pass as String) as Object
    return SetSchedulesDirectAuthData(user, pass)
End Function

Function SchedulesAPIUsername() as Dynamic
    return GetSchedulesDirectAuthUsername()
End Function

Function SchedulesAPIPassword() as Dynamic
    return GetSchedulesDirectAuthPassword()
End Function

Function GetSchedulesAPIBase() as Object
    key = "sapi"
    CreateIfDoesntExist(m, key, "roAssociativeArray")
    return m[key]
End Function

' TODO: May want to do this some other way. Transmitting the algorithm used may be
' unwise. Verify that this is ok.
Function GetSchedulesAPIHashType() as String
    return GetSchedulesDirectPasswordHashType()
End Function