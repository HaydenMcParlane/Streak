'
'   Login screen at which one can enter credentials
'   @author: Hayden McParlane
'   @creation-date: 3.10.2016
' TODO: HIGH Test this design !!!
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

Function HangleMessage(screen as Object, buttons as Object) as void
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