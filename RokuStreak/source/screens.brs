'#######################################################################################
'#  Application screens. All application screens are dynamically generated allowing
'#  for highly reusable code. 
'#
'#  @author: Hayden McParlane
'#  @creation-date: 3.10.2016
'#######################################################################################

'#######################################################################################
'#  roDialogScreen
'#######################################################################################
Function RenderDialogScreen(title as String, text as String, buttons as Object) As Void
    port = CreateObject("roMessagePort")
    screen = CreateObject("roMessageDialog")
    screen.SetMessagePort(port)
    screen.SetTitle(title)
    screen.SetText(text)    
    ' TODO: HIGH Is this pass by reference? Verify.
    AddButtons(screen, buttons)
    LogDebugObj("Printing screen back in render dialog -> ", screen)
    'screen.AddButton(1, "Username")
    'screen.AddButton(2, "Password")
    'screen.AddButtonSeparator()
    'screen.AddButton(3, "Login")
    screen.EnableBackButton(true)
    screen.Show()
    While True
        msg = wait(0, screen.GetMessagePort())        
        If type(msg) = "roMessageDialogEvent"
            if msg.isButtonPressed()
                btnID = msg.GetIndex()
                LogDebug("Handling button select")   
                HandleButtonSelect(btnID, buttons)
            else if msg.isScreenClosed()
                exit while
            end if
        end if
    end while
End Function


'#######################################################################################
'#  roKeyboardScreen
'#######################################################################################
' TODO: Dynamic population of buttons requires assoc. array with following format:
' buttons = { { "id":1, "text": "example", "command":"nameOfFunction" }, ... }
Function RenderKeyboardScreen(title as String, displayText as String, buttons as Object) as void
    screen = CreateObject("roKeyboardScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetTitle(title)     
    screen.SetDisplayText(displayText)
    screen.SetMaxLength(20)            
    AddButtons(screen, buttons)
    screen.Show()
    
    while true
        msg = wait(0, screen.GetMessagePort())        
        if type(msg) = "roKeyboardScreenEvent"
            if msg.isScreenClosed()
                return
            else if msg.isButtonPressed() then
                btnId = msg.GetIndex()
                HandleButtonSelect(btnID, buttons)                
            endif
        endif
    endwhile
End Function


'#######################################################################################
'#  roGridScreen
'#######################################################################################
' Perform search for tv schedule listings based on input filters
Function RenderTVSchedule() as integer
    port = CreateObject("roMessagePort")
    grid = CreateObject("roGridScreen")
    grid.SetMessagePort(port)    
    ' TODO: Below is O(num_keys_visible). Optimization can come from populating rows that aren't visible right before they become
    ' visible instead of populating all of the rows at once.       
    'titles = GetEpisodeTitles(EpisodeFilterTime())    
    episodes = GetEpisodes(EpisodeFilterGenre())
    titles = episodes.keys() 'TODO: Titles should be stored and retrieved. Its much Faster
    
    grid.SetupLists(titles.Count())
    grid.SetListNames(titles)  
    for i = 0 to TempEntityCount() - 1 '=> Linear time ( O(num_keys_visible) ) 
       grid.SetContentList(i,episodes[titles[i]]) '=> keys will hash to list for row. Filtration will occur by storing different title types
       grid.Show()       
    end for                   
    while true
         msg = wait(0, port)
         if type(msg) = "roGridScreenEvent" then
             if msg.isScreenClosed() then
                 return -1
             else if msg.isListItemFocused()
                 print "Focused msg: ";msg.GetMessage();"row: ";msg.GetIndex();
                 print " col: ";msg.GetData()
             else if msg.isListItemSelected()
                 print "Selected msg: ";msg.GetMessage();"row: ";msg.GetIndex();
                 print " col: ";msg.GetData()
             end if
         end if
    end while
End Function  


'#######################################################################################
'#  roParagraphScreen
'#######################################################################################
' TODO: Make dynamic
Function ShowWelcomeScreen() As Void
    port = CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    screen.SetTitle("Roku Streak")
    screen.AddHeaderText("[Header Text]")
    screen.AddParagraph("[Paragraph text 1 - Text in the paragraph screen is justified to the right and left edges]")
    screen.AddParagraph("[Paragraph text 2 - Multiple paragraphs may be added to the screen by simply making additional calls]")
    screen.AddButton(1, "Login to Schedules Direct")
    screen.AddButton(2, "Browse TV Listings")
    screen.SetDefaultMenuItem(1)
    screen.Show()
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roParagraphScreenEvent"
            if msg.isScreenClosed()
                return
            else if msg.isButtonPressed() then                
                if msg.GetIndex() = 1                    
                    buttons = CreateObject("roArray", 2, True)                    
                    args1 = CreateObject("roAssociativeArray")
                    args1.AddReplace("title","Enter Username")
                    args1.AddReplace("displayText","[Sample Display Text]")                    
                    testbutton = ConstructButton(1, "Finished", CommandStoreUsername()) 'TODO: Enter command args
                    testbuttons = CreateObject("roArray", 1, True)                    
                    testbuttons.Push(testbutton)          
                    args1.AddReplace("buttons",testbuttons)
                    button1 = ConstructButton(1, "Enter Username", CommandRenderKeyboardScreen()) 'TODO: Enter command args
                    'button2 = ConstructButton(2, "Password", "storePassword", {})
                    'button3 = ConstructButton(3, "Login", "login", {})                    
                    buttons.Push(button1)
                    'buttons.Push(button2)
                    'buttons.Push(button3) 
                    RenderDialogScreen("Login to Schedules Direct", "[Testing Text]", buttons)
                    return
                else if msg.GetIndex() = 2
                    ' TODO: Refactor so that render TV sched. uses above syntax if possible                   
                    RenderTVSchedule()
                    return
                endif
            endif
        endif
    end while
End Function

Function RenderParagraphScreen(title as String, headerText as String, buttons as Object, paragraphs as Object) As Void
    port = CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    screen.SetTitle(title)
    screen.AddHeaderText(headerText)    
    'AddParagraphs(screen, paragraphs as Object)    
    AddButtons(screen, buttons)
    screen.SetDefaultMenuItem(1)
    screen.Show()
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roParagraphScreenEvent"        
            if msg.isScreenClosed()
                return
            else if msg.isButtonPressed() then                
                btnId = msg.GetIndex()
                HandleButtonSelect(btnID, buttons)
            endif
        endif
    end while
End Function


'#######################################################################################
'#-------------------Facade screen (keeps app from closing) ---------------------------- 
'#  see https://sdkdocs.roku.com/display/sdkdoc/Working+with+Screens
'#######################################################################################
'TODO: Implement facade screen
Function RenderFacadeScreen() as void
    facade = CreateObject("roParagraphScreen")
    port = CreateObject("roMessagePort")
    facade.SetMessagePort(port)
    facade.AddParagraph("please wait...")
    facade.show()
End Function


'#######################################################################################
'#----------------------- Screen path definition functions------------------------------
'#  These functions are used to provide easy construction of screen pathways instead
'#  of having to write code for every new screen that's needed.
'#######################################################################################
Function ParagraphScreen(id as String,title as String, headerText as String, buttons as Object, paragraphs as Object) as void
    screen = CreateObject("roAssociativeArray")
    
    ' TODO: HIGH Better way to do? Achieve more code reuse?
    ' TODO: HIGH Should "factory" be used to handle screen type?
    screen.screenType = "ParagraphScreen"
    screen.title = title
    screen.headerText = headerText
    screen.buttons = buttons
    screen.paragraphs = paragraphs    
    LogDebugObj("Value of Paragraph Screen -> ", screen)
    BufferScreen(id, screen)
End Function

Function RenderNextScreen(nextID as String) as void    
    ' TODO: HIGH Refactor/redesign such that screen differences are
    ' efficiently dealt with. Avoid if? What other designs?
    screen = RetrieveScreen(nextID)
    LogDebug("Rendering next screen -> " + nextID + ", type -> " + screen.screenType)
    if screen.screenType = "ParagraphScreen"
        RenderParagraphScreen(screen.title, screen.headerText, screen.buttons, screen.paragraphs)
    else
        LogError("Screen type either not valid or unimplemented -> " + screen.screenType)
        stop
    end if
End Function

'ParagraphScreen("welcome" ,"Roku Streak", "[this]", pButtons, paragraphs)
'DialogScreen("login", "Login to Schedules Direct", "[Testing text]", dButtons)
'KeyboardScreen("username", "Enter Username", "[displayText]", kButtonsUsername)
'KeyboardScreen("password", "Enter Password", "[displayText]", kButtonsPassword)

Function BufferScreen(screenID as String, screen as Object) as void
    LogDebugObj("Buffering screen -> " + screenID, screen)
    ' TODO: HIGH Determine whether screen key verification should occur here    
    base = GetScreenPathBase()
    base[screenID] = screen
End Function

Function RetrieveScreen(screenID as String) as Object
    LogDebug("Retrieving screen -> " + screenID) 
    base = GetScreenPathBase()
    CreateIfDoesntExist(m, "screenID", "roAssociativeArray")
    return base[screenID]
End Function


Function GetScreenPathBase() as Object
    CreateIfDoesntExist(m, "screenPath", "roAssociativeArray")
    return m.screenPath
End Function

Function SetScreenPathBase(o as Object) as void
    CreateIfDoesntExist(m, "screenPath", "roAssociativeArray")
    m.screenPath = o
End Function

Function RenderScreenSet(startID as String) as void
    ' TODO: Setup so that screen set first is initiated first. Right now, hard coded.
    ExecuteRenderNextScreen(startID)
End Function
    
'#######################################################################################
'#  Helper functions
'#######################################################################################
Function AddParagraphs(screen as Object, paragraphs as Object) as void
    for each paragraph in paragraphs
        screen.AddParagraph(paragraph.text)
    end for
End Function

' buttons = { { "id":integer, "title": "example", "command":"nameOfFunction", "args":{ command_arguments } }, ... }
Function AddButtons(screen as Object, buttons as Object) as void
    LogDebugObj("Printing screen before button add -> ", screen)   
    for each button in buttons
        screen.AddButton(button[ButtonID()], button[ButtonTitle()])
    end for
    LogDebugObj("Printing screen after button add -> ", screen)
End Function

Function HandleButtonSelect(btnID as Integer, buttons as Object) as void
    LogDebugObj("Printing button id ->",btnID)    
    for each button in buttons
        LogDebugObj("Printing button -> ", button)   
        if button[ButtonID()] = btnID
            ExecuteCommand(button[ButtonCommand()])
        end if
    end for
End Function

' TODO: Abstract away button id so that all that matters is command and title
Function ConstructButton(id as integer, title as String, command as String) as Object
    button = CreateObject("roAssociativeArray")
    button[ButtonID()] = id
    button[ButtonTitle()] = title
    button[ButtonCommand()] = command    
    return button
End Function

Function ButtonID() as String
    return "id"    
End Function

Function ButtonTitle() as String
    return "title"    
End Function

Function ButtonCommand() as String
    return "command"    
End Function