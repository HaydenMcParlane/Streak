'
'   This document contains reusable hashing digest functions.
'   @author: Hayden McParlane

Function Sha1Digest(s as String) as String
    ba = CreateObject("roByteArray")
    ba.FromAsciiString(s)
    digest = CreateObject("roEVPDigest")
    digest.Setup("sha1")
    return digest.Process(ba)
End Function