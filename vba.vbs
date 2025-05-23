// 1. UPLOAD NEW ATTACHMENT
// Method: POST
const uploadAttachment = async (pageId, file) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('comment', 'Uploaded via API');

  const response = await fetch(`https://your-domain.atlassian.net/wiki/rest/api/content/${pageId}/child/attachment`, {
    method: 'POST',
    headers: {
      'Authorization': 'Basic ' + btoa('email:api-token'),
      'X-Atlassian-Token': 'no-check'
    },
    body: formData
  });

  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
  }
  
  return await response.json();
};

// 2. UPDATE EXISTING ATTACHMENT FILE
// Method: POST (with attachmentId in URL)
const updateAttachmentFile = async (pageId, attachmentId, newFile) => {
  const formData = new FormData();
  formData.append('file', newFile);
  formData.append('comment', 'Updated via API');

  const response = await fetch(`https://your-domain.atlassian.net/wiki/rest/api/content/${pageId}/child/attachment/${attachmentId}/data`, {
    method: 'POST',
    headers: {
      'Authorization': 'Basic ' + btoa('email:api-token'),
      'X-Atlassian-Token': 'no-check'
    },
    body: formData
  });

  return await response.json();
};

// 3. UPDATE ATTACHMENT METADATA (title, comment, etc.)
// Method: PUT
const updateAttachmentMetadata = async (attachmentId, metadata) => {
  const response = await fetch(`https://your-domain.atlassian.net/wiki/rest/api/content/${attachmentId}`, {
    method: 'PUT',
    headers: {
      'Authorization': 'Basic ' + btoa('email:api-token'),
      'Content-Type': 'application/json',
      'X-Atlassian-Token': 'no-check'
    },
    body: JSON.stringify({
      version: {
        number: metadata.currentVersion + 1  // Must increment version
      },
      title: metadata.newTitle,
      type: 'attachment'
    })
  });

  return await response.json();
};

// 4. GET ATTACHMENT INFO
// Method: GET
const getAttachment = async (attachmentId) => {
  const response = await fetch(`https://your-domain.atlassian.net/wiki/rest/api/content/${attachmentId}?expand=version,space`, {
    method: 'GET',
    headers: {
      'Authorization': 'Basic ' + btoa('email:api-token'),
      'Accept': 'application/json'
    }
  });

  return await response.json();
};

// 5. LIST PAGE ATTACHMENTS
// Method: GET
const listPageAttachments = async (pageId) => {
  const response = await fetch(`https://your-domain.atlassian.net/wiki/rest/api/content/${pageId}/child/attachment?expand=version`, {
    method: 'GET',
    headers: {
      'Authorization': 'Basic ' + btoa('email:api-token'),
      'Accept': 'application/json'
    }
  });

  return await response.json();
};

// CURL EXAMPLES:

/* 
// Upload new attachment
curl -X POST \
  "https://your-domain.atlassian.net/wiki/rest/api/content/PAGE_ID/child/attachment" \
  -H "Authorization: Basic BASE64_EMAIL:TOKEN" \
  -H "X-Atlassian-Token: no-check" \
  -F "file=@/path/to/file.pdf" \
  -F "comment=API upload"

// Update attachment metadata
curl -X PUT \
  "https://your-domain.atlassian.net/wiki/rest/api/content/ATTACHMENT_ID" \
  -H "Authorization: Basic BASE64_EMAIL:TOKEN" \
  -H "Content-Type: application/json" \
  -H "X-Atlassian-Token: no-check" \
  -d '{
    "version": {"number": 2},
    "title": "Updated filename.pdf",
    "type": "attachment"
  }'

// Update attachment file
curl -X POST \
  "https://your-domain.atlassian.net/wiki/rest/api/content/PAGE_ID/child/attachment/ATTACHMENT_ID/data" \
  -H "Authorization: Basic BASE64_EMAIL:TOKEN" \
  -H "X-Atlassian-Token: no-check" \
  -F "file=@/path/to/newfile.pdf"
*/

' VBA EXAMPLES FOR CONFLUENCE ATTACHMENTS

' 1. UPDATE ATTACHMENT METADATA (JSON)
Sub UpdateAttachmentMetadata()
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    ' Configuration
    Dim baseUrl As String: baseUrl = "https://your-domain.atlassian.net/wiki"
    Dim email As String: email = "your-email@company.com"
    Dim apiToken As String: apiToken = "your-api-token"
    Dim attachmentId As String: attachmentId = "123456"  ' Get from attachment URL
    
    ' Create Basic Auth
    Dim auth As String
    auth = "Basic " & EncodeBase64(email & ":" & apiToken)
    
    ' JSON payload
    Dim jsonData As String
    jsonData = "{" & _
        """version"": {""number"": 2}," & _
        """title"": ""updated-filename.json""," & _
        """type"": ""attachment""" & _
    "}"
    
    ' Make PUT request
    With http
        .Open "PUT", baseUrl & "/rest/api/content/" & attachmentId, False
        .setRequestHeader "Authorization", auth
        .setRequestHeader "Content-Type", "application/json"
        .setRequestHeader "X-Atlassian-Token", "no-check"
        .send jsonData
        
        Debug.Print "Status: " & .Status
        Debug.Print "Response: " & .responseText
        
        If .Status = 403 Then
            Debug.Print "403 Error - Check API token and permissions"
        ElseIf .Status = 405 Then
            Debug.Print "405 Error - Wrong HTTP method or endpoint"
        End If
    End With
End Sub

' 2. UPLOAD NEW JSON ATTACHMENT
Sub UploadJsonAttachment()
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    ' Configuration
    Dim baseUrl As String: baseUrl = "https://your-domain.atlassian.net/wiki"
    Dim email As String: email = "your-email@company.com"
    Dim apiToken As String: apiToken = "your-api-token"
    Dim pageId As String: pageId = "123456"  ' Confluence page ID
    
    ' Create Basic Auth
    Dim auth As String
    auth = "Basic " & EncodeBase64(email & ":" & apiToken)
    
    ' JSON content to upload
    Dim jsonContent As String
    jsonContent = "{""key"": ""value"", ""updated"": """ & Now & """}"
    
    ' Create multipart form data
    Dim boundary As String: boundary = "----VBAFormBoundary" & CDbl(Now)
    Dim formData As String
    
    formData = "--" & boundary & vbCrLf & _
        "Content-Disposition: form-data; name=""file""; filename=""data.json""" & vbCrLf & _
        "Content-Type: application/json" & vbCrLf & vbCrLf & _
        jsonContent & vbCrLf & _
        "--" & boundary & vbCrLf & _
        "Content-Disposition: form-data; name=""comment""" & vbCrLf & vbCrLf & _
        "Updated via VBA" & vbCrLf & _
        "--" & boundary & "--"
    
    ' Make POST request
    With http
        .Open "POST", baseUrl & "/rest/api/content/" & pageId & "/child/attachment", False
        .setRequestHeader "Authorization", auth
        .setRequestHeader "Content-Type", "multipart/form-data; boundary=" & boundary
        .setRequestHeader "X-Atlassian-Token", "no-check"
        .send formData
        
        Debug.Print "Status: " & .Status
        Debug.Print "Response: " & .responseText
    End With
End Sub

' 3. GET ATTACHMENT INFO
Sub GetAttachmentInfo()
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    Dim baseUrl As String: baseUrl = "https://your-domain.atlassian.net/wiki"
    Dim email As String: email = "your-email@company.com"
    Dim apiToken As String: apiToken = "your-api-token"
    Dim attachmentId As String: attachmentId = "123456"
    
    Dim auth As String
    auth = "Basic " & EncodeBase64(email & ":" & apiToken)
    
    With http
        .Open "GET", baseUrl & "/rest/api/content/" & attachmentId & "?expand=version", False
        .setRequestHeader "Authorization", auth
        .setRequestHeader "Accept", "application/json"
        .send
        
        Debug.Print "Status: " & .Status
        Debug.Print "Response: " & .responseText
        
        ' Parse response to get current version number
        If .Status = 200 Then
            Dim response As String: response = .responseText
            ' Extract version number from JSON response
            Debug.Print "Current version: " & ExtractVersion(response)
        End If
    End With
End Sub

' 4. REPLACE EXISTING ATTACHMENT FILE
Sub ReplaceAttachmentFile()
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    Dim baseUrl As String: baseUrl = "https://your-domain.atlassian.net/wiki"
    Dim email As String: email = "your-email@company.com"
    Dim apiToken As String: apiToken = "your-api-token"
    Dim pageId As String: pageId = "123456"
    Dim attachmentId As String: attachmentId = "789123"
    
    Dim auth As String
    auth = "Basic " & EncodeBase64(email & ":" & apiToken)
    
    ' New JSON content
    Dim jsonContent As String
    jsonContent = "{""updated"": true, ""timestamp"": """ & Now & """}"
    
    ' Create multipart form data
    Dim boundary As String: boundary = "----VBAFormBoundary" & CDbl(Now)
    Dim formData As String
    
    formData = "--" & boundary & vbCrLf & _
        "Content-Disposition: form-data; name=""file""; filename=""updated-data.json""" & vbCrLf & _
        "Content-Type: application/json" & vbCrLf & vbCrLf & _
        jsonContent & vbCrLf & _
        "--" & boundary & "--"
    
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

' HELPER FUNCTIONS

Function EncodeBase64(text As String) As String
    Dim arrData() As Byte
    arrData = StrConv(text, vbFromUnicode)
    
    Dim objXML As Object
    Dim objNode As Object
    
    Set objXML = CreateObject("MSXML2.DOMDocument")
    Set objNode = objXML.createElement("base64")
    
    objNode.dataType = "bin.base64"
    objNode.nodeTypedValue = arrData
    EncodeBase64 = objNode.text
End Function

Function ExtractVersion(jsonText As String) As Integer
    ' Simple JSON parsing to extract version number
    Dim versionPos As Integer
    versionPos = InStr(jsonText, """number"":")
    If versionPos > 0 Then
        Dim numberStart As Integer: numberStart = versionPos + 9
        Dim numberEnd As Integer: numberEnd = InStr(numberStart, jsonText, ",")
        If numberEnd = 0 Then numberEnd = InStr(numberStart, jsonText, "}")
        ExtractVersion = CInt(Trim(Mid(jsonText, numberStart, numberEnd - numberStart)))
    End If
End Function

' EXAMPLE USAGE:
' 1. Set your credentials and IDs in the variables
' 2. Run UpdateAttachmentMetadata() to change attachment title/metadata
' 3. Run ReplaceAttachmentFile() to upload new JSON content
' 4. Check Debug.Print output for responses and errors
