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
        print "message received"
        if type(msg) = "roKeyboardScreenEvent"
            if msg.isScreenClosed()
                return
            else if msg.isButtonPressed() then
                print "Event: "; msg.GetMessage();" idx: ";msg.GetIndex()
                if msg.GetIndex() = 1
                    searchText = screen.GetText()
                    LogDebug("Search text: " + searchText)
                    SearchSchedulesDirect() ' TODO: Complete implementation of search
                    ' Query Schedules Direct API
                    ' Validate input later ***
                    'aa = SearchSchedulesDirect(searchText)                    
                                     
                    'RenderTVSchedule(aa)
                                        
                    return
                else if msg.GetIndex() = 2
                    print "returning to home screen"
                    return
                endif
            endif
        endif
    endwhile
End Function