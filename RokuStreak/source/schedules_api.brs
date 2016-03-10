'
'   This document functions as the interface into television schedules for the project.
'   It decouples the screens from the back-end API used to gather TV scheduling information.
'   @author: Hayden McParlane
Function PopulateTVData() as void ' TODO: Change return type to AA for render results
    FetchSchedulesDirectData()    
End Function