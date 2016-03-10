'
'   Keyboard screen for data entry
'   @author: Hayden McParlane
'   @creation-date: 3.10.2016

' Dynamic population of buttons requires assoc. array with following format:
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