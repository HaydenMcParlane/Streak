'
'   This document contains code for the search screen
'   @author: Hayden McParlane

Function RenderSearchScreen() as void
    screen = CreateObject("roKeyboardScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetTitle("Search")     
    screen.SetDisplayText("Enter time of shows you want to watch")
    screen.SetMaxLength(16)
    screen.AddButton(1,"Finished")
    screen.AddButton(2,"Back")    
    screen.Show()
    
    while true
        msg = wait(0, screen.GetMessagePort())        
        if type(msg) = "roKeyboardScreenEvent"
            if msg.isScreenClosed()
                return
            else if msg.isButtonPressed() then                
                if msg.GetIndex() = 1
                    searchText = screen.GetText()
                    LogDebug("Search text: " + searchText)
                    ' TODO: Validate input later
                    ' TODO: Complete implementation of search
                    searchResults = SearchSchedulesDirect()                                        
                    'aa = SearchSchedulesDirect(searchText)                    
                                     
                    'RenderTVSchedule(aa)
                                        
                    return
                else if msg.GetIndex() = 2
                    ' Return to previous screen                    
                    return
                endif
            endif
        endif
    endwhile
End Function