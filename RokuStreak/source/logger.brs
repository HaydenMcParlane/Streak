'
'   This document contains the logging system for this component
'   of the software system
'   @author: Hayden McParlane
'   @creation-date: 2.18.2016
Function LogDebug(msg as String) as void
    print FormatLogString("--DEBUG    : " + msg)    
End Function

Function LogDebugObj(msg as String, o as Object) as void
    print FormatLogString("--DEBUG    : " + msg)
    LogObject(o)
End Function

Function LogInfo(msg as String) as void
    print FormatLogString("--INFO     : " + msg)    
End Function

Function LogInfoObj(msg as String, o as Object) as void
    print FormatLogString("--INFO     : " + msg)    
    LogObject(o)
End Function

Function LogWarning(msg as String) as void
    print FormatLogString("--WARNING  : " + msg)    
End Function

Function LogWarningObj(msg as String, o as Object) as void
    print FormatLogString("--WARNING  : " + msg)
    LogObject(o)
End Function

Function LogError(msg as String) as void
    print FormatLogString("--ERROR    : " + msg)
End Function

Function LogErrorObj(msg as String, o as Object) as void
    print FormatLogString("--ERROR    : " + msg)
    LogObject(o)
End Function

Function LogCritical(msg as String) as void
    print FormatLogString("--CRITICAL : " + msg)
End Function

Function LogCriticalObj(msg as String, o as Object) as void
    print FormatLogString("--CRITICAL : " + msg)
    LogObject(o)
End Function

Function LogObject(o as Object) as void    
    print FormatLogString("")
    print o
End Function

Function FormatLogString(msg as String) as String
    return NewLine() + msg
End Function