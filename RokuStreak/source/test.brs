'
'   This document contains testing fixtures for use in this system.
'   @author: Hayden McParlane
Function RunAllTests() as Boolean
    TestSchedulesDirectDataStore()
    TestChannelModule()    
End Function

Function TestChannelModule() as void
    LogDebug("Initializing channel data store and testing for run-time function consistency")
    
    LogDebug("Channel data store initialized")
End Function