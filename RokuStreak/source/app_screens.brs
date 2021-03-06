'#######################################################################################
'#  App Layout specification
'#
'#  @author: Hayden McParlane
'#  @creation-date: 3.10.2016
'#######################################################################################
Function ConfigureAppScreensAndRun() as void    
    paragraphs = CreateObject("roArray", 2, True)
    buttons = CreateObject("roArray", 1, True)    
    
    'paragraphscreen -> id as String,title as String, headerText as String, buttons as Object, paragraphs as Object
    'button -> title as String, command as Object, args as Object
    ' Welcome page    
    paragraphs.Push("Roku Streak provides a filterable TV schedule allowing users to choose how they want to view listings.")
    buttons.Push(CreateButton("Sign In", ShowNextScreen.GetSub(), "enter_credentials"))    
    buttons.Push(CreateButton("Browse Schedule", RenderTVSchedule.GetSub(), "browse_schedule"))    
    ParagraphScreen("welcome", "Roku Streak", "Browse TV Better", paragraphs, buttons)
    buttons.Clear()
    paragraphs.Clear()
    
    ' Sign in    
    args = CreateObject("roAssociativeArray")
    args.AddReplace(Username(),"")
    args.AddReplace(Password(),"")
    buttons.Push(CreateButton("Username", ShowNextScreen.GetSub(), "user_keyboard"))
    buttons.Push(CreateButton("Password", ShowNextScreen.GetSub(), "pass_keyboard"))
    buttons.Push(CreateButton("Login", ExecuteLogin.GetSub(), args))
    DialogScreen("enter_credentials", "Login to " + ScheduleAPIName(), "Enter your username and password and then select login.", buttons)
    buttons.Clear()
    args.Clear()
        
    ' Username/Password entry keyboard screens   
    'cmds = CreateObject("roArray", 1, True)
    'cmds.Append(StoreKeyboardEntry.GetSub(), ShowNextScreen.GetSub()) 
    args.entry = ""
    args.storageLocation = "username"
    buttons.Push(CreateButton("Finished", StoreKeyboardEntry.GetSub(), args))
    KeyboardScreen("user_keyboard", "Enter Username", "", "[Display text]", buttons, False)
    buttons.Clear()
    args.Clear()
        
    args.entry = ""
    args.storageLocation = "password"
    buttons.Push(CreateButton("Finished", StoreKeyboardEntry.GetSub(), args))
    KeyboardScreen("pass_keyboard", "Enter Password", "", "[Display text]", buttons, True)
    buttons.Clear()        
    args.Clear()      
    
    ' Start at specified screen
    ShowScreen("welcome")
End Function