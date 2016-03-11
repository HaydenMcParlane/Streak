'
'   Commands registered with application and "factory" to retrieve them
'   @author: Hayden McParlane
'   @creation-date: 3.10.2016
' TODO: Return boolean

Function ExecuteCommand(command as String, args as Object) as void
    ' 1. Store arguments in shared data structure. This allows
    ' for dynamic command execution
    SetCommandArguments(args)
    'commands = GetCommandRegistry()
    ' TODO: HIGH Implement dynamic command registry
    'if commands.DoesExist(command)
    '    commands[command]
    if command = CommandRenderKeyboardScreen()
        ExecuteRenderKeyboardScreen()
    else if command = CommandStoreUsername()
        ExecuteStoreUsername()
    else if command = CommandStorePassword()
        ExecuteStorePassword()
    else if command = CommandLogin()
        ExecuteLogin()    
    else
        LogError("Command does not exist -> " + command)
        stop
    end if
End Function

Function GetCommandArguments() as Object
    base = GetCommandBase()
    CreateIfDoesntExist(base, "args", "roAssociativeArray")
    return base.args
End Function

Function SetCommandArguments(args as Object) as void
        base = GetCommandBase()
        LogDebugObj("Printing base in SetCommandArgs -> ", args)
        base.args = args
End Function 

Function GetCommandRegistry() as Object
    CreateIfDoesntExist(m, "commands", "roAssociativeArray")
    return m.commands
End Function

Function SetCommandRegistry(o as Object) as void
    base = GetCommandRegistry()
    base = o
End Function

Function GetCommandBase() as Object
    CreateIfDoesntExist(m, "commands", "roAssociativeArray")
    return m.commands
End Function

Function SetCommandBase(o as Object) as Object
    base = GetCommandBase()    
    base = o
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

'###########################################################################
'#   Commands
'#   Note: All commands should retrieve args using GetCommandArguments()
'#   before executing, unless args aren't passed. Follow command
'#   implementations below.
'###########################################################################
Function CommandRenderKeyboardScreen() as String
    return "RenderKeyboardScreen"
End Function

Function ExecuteRenderKeyboardScreen() as String
    args = GetCommandArguments()
    requiredKeys = CreateObject("roArray", 3, True)
    requiredKeys.Push("title")
    requiredKeys.Push("displayText")
    requiredKeys.Push("buttons")
    success = VerifyKeys(args, requiredKeys)
    if not success
        LogCommandArgsFailedVerify("ExecuteRenderKeyboardScreen")
    end if
    RenderKeyboardScreen(args.title, args.displayText, args.buttons)    
End Function

Function CommandStoreUsername() as String
    return "storeUsername"
End Function

Function ExecuteStoreUsername() as String
    ' Store Username in non-volatile storage
    args = GetCommandArguments()
    stop
    if args.DoesExist("username")
        username = args.username
    else
        LogError("Command called without args stored -> StoreUsername")
        stop
    end if
    reg = CreateObject("roRegistry")
    regList = reg.GetSectionList()
    
    return "storeUsername"
End Function

Function CommandStorePassword() as String
    return "storePassword"
End Function

Function CommandLogin() as String
    return "login"
End Function

Function LogCommandArgsFailedVerify(command as String) as void
    LogError("Command called without args stored -> " + command)
    stop
End Function