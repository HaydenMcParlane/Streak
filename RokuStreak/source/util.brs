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

'   TODO: Figure out better NoneType Implementation to avoid comparisons testing for None()
'   before invalid and introducing massive bugs into the code that are hard to find.
'   A function to represent "No Assigned Value," similar to python None
Function None() as Object
    'return Chr(96)
    return invalid
End Function

'######################################################################
'   ASSOCIATIVE ARRAY HELPER FUNCTIONS
'######################################################################

' Get an arbitrary key in an associative array. This can be used to start for loops to construct
' strings iteratively. Otherwise, there's no way to retrieve the key on 2.20.2016. I decided not
' to use the provided Keys() method because the results are sorted in lexicographical order which
' adds heavy computation to a simple use case.
Function GetRandomKey(aa as Object) as Object
    for each key in aa
        return key
    end for
End Function

Function LinkAssociativeArrays(array as Object) as Object
    aa = CreateObject("roAssociativeArray")
    for each row in array
        aa.Append(row)
    end for
    return aa
End Function

'######################################################################
'   ARRAY HELPER FUNCTIONS
'######################################################################

' TODO: Review for correctness. Particularly to ensure that the ordering of returned strings is
' static. If used with headers and order not consistent, could result in header value and header
' name being swapped.
Function MakeAssociative(array as Object, splitChar as String) as Object
    regex = CreateObject("roRegex", splitChar, "")
    aa = CreateObject("roAssociativeArray")
    for each row in array    
        tempArr = regex.Split(row)
        for each entry in tempArr            
            entry = entry.trim()
        end for        
        aa.AddReplace(tempArr[0],tempArr[1])
    end for
End Function

'######################################################################
'   MAINTENANCE HELPER FUNCTIONS
'######################################################################
' TODO: Implement function to print the m.... hierarchy so that developers
' can visualize system.
Function PrintMHierarchy() as void
End Function
