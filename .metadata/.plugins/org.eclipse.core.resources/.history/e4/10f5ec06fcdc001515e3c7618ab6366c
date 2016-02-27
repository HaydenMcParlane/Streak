'
'   This document contains functions to help with json construction
'   @author: Hayden McParlane
Function ConstructJSONStr(aa as Object) as String    
    firstKey = GetRandomKey(aa)
    json = "{ " + EmbedInQuotes(firstKey) + ": " + EmbedInQuotes(aa[firstKey])  
    for each key in aa
        if key <> firstKey
            json = json + ", " + EmbedInQuotes(key) + ":" + EmbedInQuotes(aa[key])
        end if
    end for
    json = json + " }"
    return json
End Function
