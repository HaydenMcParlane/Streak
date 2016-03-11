'
'   This document contains code related to the main application screen
'   @author: Hayden McParlane
' TODO: HIGH Refactor screen so that they can be reused. Can buttons be passed
' in array or assoc. arr. with value being result of click? How to do?
' TODO: At application Launch, begin populating data
Function RunUserInterface(aa as Object)    
    ConfigureApplication()
    'PopulateTVData()        
    ShowWelcomeScreen()
End Function

' TODO: Is function main actually needed?
'Function Main(aa as Object)    
'    port = CreateObject("roMessagePort")
'    poster = CreateObject("roPosterScreen")
'    poster.SetBreadcrumbText("RokuStreak","Main")
'    poster.SetListStyle("flat-category")
'    poster.SetMessagePort(port)
'    
'    numScreenOptions = 1
'    
'    list = CreateObject("roArray", numScreenOptions, true)
'    for i = 0 to 10
'        aa = CreateObject("roAssociativeArray")
'        aa.ContentType = "episode"
'        aa.Title = "[Title]"
'        aa.ShortDescriptionLine1 = "[ShortDescriptionLine1]"
'        aa.ShortDescriptionLine2 = "[ShortDescriptionLine2]"
'        aa.Description = ""
'        aa.Description = "[Description]"
'        aa.Rating = "NR"
'        aa.StarRating = "75"
'        aa.ReleaseDate = "[mm/dd/yyyy]"
'        aa.Length = 5400
'        aa.Categories = []
'        aa.Categories.Push("[Cat1]")
'        aa.Categories.Push("[Cat2]")
'        aa.Categories.Push("[Cat3]")
'        aa.Actors = []
'        aa.Actors.Push("[Actor1]")
'        aa.Actors.Push("[Actor2]")
'        aa.Actors.Push("[Actor3]")
'        aa.Director = "[Director]"
'        list.Push(aa)
'    endfor
'    aa = CreateObject("roAssociativeArray")
'    aa.ContentType = "episode"   
'    aa.ShortDescriptionLine1 = "Search"
'   list.Push(aa)
'    poster.SetContentList(list)
'    poster.Show()
'            
'    while true
'        msg = wait(0, poster.GetMessagePort())
'        if msg.isScreenClosed() then
'            return -1
'        else if msg.isListItemSelected()
'            ' TODO: Implement check to ensure list item selected was Search Screen            
'            RenderSearchScreen()
'        endif
'    endwhile        
'End Function

Function ConstructButton(id as integer, title as String, command as String, args as Object) as Object
    button = CreateObject("roAssociativeArray")
    button[ButtonID()] = id
    button[ButtonTitle()] = title
    button[ButtonCommand()] = command
    button[ButtonCommandArgs()] = args    
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

Function ButtonCommandArgs() as String
    return "args"    
End Function
