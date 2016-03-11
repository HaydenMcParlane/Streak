'
'   Welcome screen to greet users
'   @author: Hayden McParlane
'   @creation-date: 3.10.2016
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