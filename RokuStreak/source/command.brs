'
'   Commands registered with application and "factory" to retrieve them
'   @author: Hayden McParlane
'   @creation-date: 3.10.2016
' TODO: Return boolean
Function ExecuteCommand(command as String) as void
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

Function SetCommandRegistry(o as Object) as void
    CreateIfDoesntExist(m, "commands", "roAssociativeArray")
    m.commands = o
End Function

Function GetCommandRegistry() as Object
    CreateIfDoesntExist(m, "commands", "roAssociativeArray")
    return m.commands
End Function

Function InitCommandRegistry() as Boolean
    LogDebug("Initializing command registry")
    commandRegistry = CreateObject("roAssociativeArray")
    
    ' TODO: Is storing function in AA possible?
    'commandRegistry.AddReplace("storeUsername", GetSub())
    
    LogDebug("Initializing command registry successful")
End Function