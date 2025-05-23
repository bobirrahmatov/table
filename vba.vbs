Sub ReplaceJsonAttachment()
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")

    ' Configuration
    Dim baseUrl As String: baseUrl = "https://your-domain.atlassian.net/wiki"
    Dim email As String: email = "your-email@company.com"
    Dim apiToken As String: apiToken = "your-api-token"
    Dim pageId As String: pageId = "123456"  ' Confluence page ID
    Dim attachmentId As String: attachmentId = "789123"  ' Attachment ID to be updated
    
    ' Create Basic Auth
    Dim auth As String
    auth = "Basic " & EncodeBase64(email & ":" & apiToken)

    ' JSON content to replace with
    Dim jsonContent As String
    jsonContent = "{""status"":""updated"",""timestamp"":""" & Now & """}"

    ' Create multipart form data
    Dim boundary As String: boundary = "----VBAFormBoundary" & Replace(CStr(Timer), ".", "")
    Dim formData As String
    formData = "--" & boundary & vbCrLf & _
        "Content-Disposition: form-data; name=""file""; filename=""updated-data.json""" & vbCrLf & _
        "Content-Type: application/json" & vbCrLf & vbCrLf & _
        jsonContent & vbCrLf & _
        "--" & boundary & "--"

    ' Make POST request
    With http
        .Open "POST", baseUrl & "/rest/api/content/" & pageId & "/child/attachment/" & attachmentId & "/data", False
        .setRequestHeader "Authorization", auth
        .setRequestHeader "Content-Type", "multipart/form-data; boundary=" & boundary
        .setRequestHeader "X-Atlassian-Token", "no-check"
        .send formData
        
        Debug.Print "Status: " & .Status
        Debug.Print "Response: " & .responseText
    End With
End Sub


Function EncodeBase64(input As String) As String
    Dim bytes() As Byte
    bytes = StrConv(input, vbFromUnicode)
    
    Dim objXML As Object
    Set objXML = CreateObject("MSXML2.DOMDocument")
    
    Dim objNode As Object
    Set objNode = objXML.createElement("b64")
    objNode.DataType = "bin.base64"
    objNode.nodeTypedValue = bytes
    EncodeBase64 = Replace(objNode.Text, vbLf, "")
    
    Set objNode = Nothing
    Set objXML = Nothing
End Function
