'
'   This document contains utility functions to increase code reuse
'   @author: Hayden McParlane

'######################################################################
'   STRING HELPER FUNCTIONS
'######################################################################

Function EmbedBetweenChr(s as String, ch as Integer) as String
    return Chr(ch) + s + Chr(ch)
End Function

Function EmbedBetweenStr(inside as String, encap as String) as String
    return encap + inside + encap
End Function

Function EmbedInQuotes(s as String) as String
    return EmbedBetweenStr(s, DoubleQuotes())
End Function

Function NewLine() as String
    return Chr(10)
End Function

Function DoubleQuotes() as String
    return Chr(34)
End Function

'######################################################################
'   ASSOCIATIVE ARRAY HELPER FUNCTIONS
'######################################################################

' Get an arbitrary key in an associative array. This can be used to start for loops to construct
' strings iteratively. Otherwise, there's no way to retrieve the key on 2.20.2016.
Function GetRandomKey(aa as Object) as Object
    for each key in aa
        return key
    end for
End Function