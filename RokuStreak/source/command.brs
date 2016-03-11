'
'   Commands registered with application and "factory" to retrieve them
'   @author: Hayden McParlane
'   @creation-date: 3.10.2016
' TODO: Return boolean
Function ExecuteCommand(command as String, args as Object) as void
    
    commands = GetCommandRegistry()
    ' TODO: HIGH Implement dynamic command registry
    'if commands.DoesExist(command)
    '    commands[command]
    if command = "StoreUsername"
        StoreUsername()
    else if command = "StorePassword"
        StorePassword()
    else
        LogError("Command does not exist -> " + command)
        stop
    end if    
End Function

sdfa
Function GetCommandArguments(command as String) as Object
End Function

Function SetCommandArguments(command as String, args as Object) as Object
End Function 

Function SetCommandRegistry(o as Object) as void
    CreateIfDoesntExist(m, "commands", "roAssociativeArray")
    m.commands = o
End Function

Function GetCommandRegistry() as Object
    CreateIfDoesntExist(m, "commands", "roAssociativeArray")
    return m.commands
End Function

' TODO: HIGH possible implementation of data passing from caller to command
' -> use m getter and setter methods to standardize interface in same way
' as "get command' interface. Same method signature.
Function InitCommandRegistry() as Boolean
    LogDebug("Initializing command registry")
    commandRegistry = CreateObject("roAssociativeArray")
    
    ' TODO: Is storing function in AA possible?
    'commandRegistry.AddReplace("storeUsername", GetSub())
    
    LogDebug("Initializing command registry successful")
End Function