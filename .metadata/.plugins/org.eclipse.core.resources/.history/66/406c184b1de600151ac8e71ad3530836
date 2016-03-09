'
'   This document contains the television schedule object which will
'   be used to encapsulate scheduling functionality such as record show,
'   search, etc.
'   @author: Hayden McParlane
'   @creation-date: 2.18.2016

' Perform search for tv schedule listings based on input filters
Function RenderTVSchedule() as integer
    port = CreateObject("roMessagePort")
    grid = CreateObject("roGridScreen")
    grid.SetMessagePort(port)
    rowTitles = CreateObject("roArray", 10, true)
    for j = 0 to TempEntityCount()
        rowTitles.Push("[Row Title " + j.toStr() + " ] ")
    end for
    grid.SetupLists(rowTitles.Count())
    grid.SetListNames(rowTitles)    
    list = GetEpisodeList()    
    for j = 0 to TempEntityCount()
        grid.SetContentList(j, list)
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