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
                for each button in buttons
                    if button.id = btnId
                        ExecuteCommand(button["command"])
                    end if
                end for                
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
                    testbutton = ConstructButton(1, "Finished", CommandStoreUsername(), CreateObject("roAssociativeArray"))
                    testbuttons = CreateObject("roArray", 1, True)                    
                    testbuttons.Push(testbutton)          
                    args1.AddReplace("buttons",testbuttons)
                    button1 = ConstructButton(1, "Username", CommandRenderKeyboardScreen(), args1)
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
                    buttons = CreateObject("")
                    ShowDialog()
                    return
                else if msg.GetIndex() = 2
                    
                    return
                endif
            endif
        endif
    end while
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
            ExecuteCommand(button[ButtonCommand()], button[ButtonCommandArgs()])
        end if
    end for
End Function

' TODO: Implement dynamically generatable message handling
Function HandleMessage(screen as Object, buttons as Object) as void
    While True
        msg = wait(0, screen.GetMessagePort())
        ' TODO: HIGH Figure out manner of handling multiple events dynamically
        If type(msg) = "roMessageDialogEvent"
            if msg.isButtonPressed()
                if msg.GetIndex() = 1
                    exit while
                end if
            else if dlgMsg.isScreenClosed()
                exit while
            end if
        end if
    end while
End Function