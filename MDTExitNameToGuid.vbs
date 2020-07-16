'#########################################################################################
'#   MICROSOFT LEGAL STATEMENT FOR SAMPLE SCRIPTS/CODE
'#########################################################################################
'#   This Sample Code is provided for the purpose of illustration only and is not 
'#   intended to be used in a production environment.
'#
'#   THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY 
'#   OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED 
'#   WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
'#
'#   We grant You a nonexclusive, royalty-free right to use and modify the Sample Code 
'#   and to reproduce and distribute the object code form of the Sample Code, provided 
'#   that You agree: 
'#   (i)      to not use Our name, logo, or trademarks to market Your software product 
'#            in which the Sample Code is embedded; 
'#   (ii)     to include a valid copyright notice on Your software product in which 
'#            the Sample Code is embedded; and 
'#   (iii)    to indemnify, hold harmless, and defend Us and Our suppliers from and 
'#            against any claims or lawsuits, including attorneys’ fees, that arise 
'#            or result from the use or distribution of the Sample Code.
'#########################################################################################
' //***************************************************************************
' // ***** Script Header *****
' //
' // Solution:  Solution Accelerator - Microsoft Deployment Toolkit
' // File:      MDTExitNameToGuid.vbs
' //
' // Purpose:   Funtions to convert friendly name values in properties/list items (e.g.
' //            Applications) to GUIDs.
' //
' // Usage:     To convert single entries, modify CustomSettings.ini similar to this:
' //              [Settings] 
' //              Priority=Default, NameToGuid
' //              Properties=
' //              
' //              [NameToGuid]
' //              UserExit=MDTExitNameToGuid.vbs
' //              Applications001=#ConvertNameToGUID("Contoso Application A 1.0", "Applications")#
' //              Applications002=#ConvertNameToGUID("Contoso Application B 2.0", "Applications")#
' //
' //            The parameters for the ConvertNameToGUID function are:
' //              (<Item Name in Deployment Workbench>, <Control folder XML file base name>)
' //
' //
' //            To convert the entries in a list item, modify CustomSettings.ini 
' //            similar to this:
' //              [Settings]
' //              Priority=Default, NameToGuid
' //              Properties=ConvertList
' //              
' //              [NameToGuid]
' //              UserExit=MDTExitNameToGuid.vbs
' //              Applications001=Contoso Application A 1.0
' //              Applications002=Contoso Application B 2.0
' //              ConvertList=#ConvertNameToGUIDInList("Applications", "Applications")#
' //
' //            The parameters for the ConvertNameToGUIDInList function are:
' //              (<List Item name>, <Control folder XML file base name>)
' //
' // Version:      1.0.0
' //
' // Customer History:
' // 1.0.0   04/12/2010  Created script.
' //
' // ***** End Header *****
' //***************************************************************************

Function UserExit(sType, sWhen, sDetail, bSkip)

    oLogging.CreateEntry "USEREXIT:MDTExitNameToGuid.vbs started: " & sType & " " & sWhen & " " & sDetail, LogTypeInfo

    UserExit = Success

End Function


Function GetGUIDsofFriendlyNames(sControlFileName)

    Dim oFiles
    Dim oFolder
    Dim oXMLFile
    Dim oXMLNode
    Dim sName
    Dim FriendlyNameList
    Dim sLogLinePrefix
    
    sLogLinePrefix = "USEREXIT:MDTExitNameToGuid.vbs|GetGUIDsofFriendlyNames: "

    Set FriendlyNameList = CreateObject("Scripting.Dictionary")
    FriendlyNameList.CompareMode = vbTextCompare

    Set oFolder = oFSO.GetFolder( oEnvironment.Item("DeployRoot") & "\control" )
    If oFolder is nothing then
        oLogging.CreateEntry sLogLinePrefix & "Unable to find DeployRoot!", LogTypeError
        Exit function
    End if

    If (sControlFileName = "") Or (sControlFileName = "*") Then

        ' Create Dictionary from all Control folder XML files

        For each oFiles in oFolder.Files
            If UCase(right(oFIles.Name, 4)) = ".XML" then
                oLogging.CreateEntry sLogLinePrefix & "Loading control file: " & oFiles.Path, LogTypeInfo
                Set oXMLFile = oUtility.CreateXMLDOMObjectEx(oFiles.Path)
                If not oXMLFile is nothing then
                    for each oXMLNode in oXMLFile.selectNodes("//*/*[@guid]")
                        if not oXMLNode.selectSingleNode("./Name") is nothing then
                            sName = oUtility.SelectSingleNodeString(oXMLNode,"./Name")
                            if not oXMLNode.Attributes.getNamedItem("guid") is nothing then
                                if oXMLNode.Attributes.getNamedItem("guid").value <> "" and sName <> "" then
                                    if FriendlyNameList.Exists(sName) then
                                        oLogging.CreateEntry sLogLinePrefix & "Duplicate name detected: " & sName & " (GUID: " & oXMLNode.Attributes.getNamedItem("guid").value & ")" & _
                                                             ".  Entry skipped.  This could lead to unexpected results.", LogTypeWarning
                                    else
                                        FriendlyNameList.Add sName, oXMLNode.Attributes.getNamedItem("guid").value
                                        oLogging.CreateEntry sLogLinePrefix & "Added to dictionary: " & sName & ", " &  oXMLNode.Attributes.getNamedItem("guid").value, LogTypeInfo
                                    end if
                                end if
                            end if
                        end if
                    next
                End if
            End if
        Next
    Else

        ' Create Dictionary from specified Control folder XML file

        oLogging.CreateEntry sLogLinePrefix & "Loading control file: " & oFolder.Path & "\" & sControlFileName & ".xml", LogTypeInfo
        Set oXMLFile = oUtility.CreateXMLDOMObjectEx(oFolder.Path & "\" & sControlFileName & ".xml")
        If not oXMLFile is nothing then
            for each oXMLNode in oXMLFile.selectNodes("//*/*[@guid]")
                if not oXMLNode.selectSingleNode("./Name") is nothing then
                    sName = oUtility.SelectSingleNodeString(oXMLNode,"./Name")
                    if not oXMLNode.Attributes.getNamedItem("guid") is nothing then
                        if oXMLNode.Attributes.getNamedItem("guid").value <> "" and sName <> "" then
                            if FriendlyNameList.Exists(sName) then
                                oLogging.CreateEntry sLogLinePrefix & "Duplicate name detected: " & sName & " (GUID: " & oXMLNode.Attributes.getNamedItem("guid").value & ")" & _
                                                     ".  Entry skipped.  This could lead to unexpected results.", LogTypeWarning
                            else
                                FriendlyNameList.Add sName, oXMLNode.Attributes.getNamedItem("guid").value
                                oLogging.CreateEntry sLogLinePrefix & "Added to dictionary: " & sName & ", " &  oXMLNode.Attributes.getNamedItem("guid").value, LogTypeInfo
                            end if
                        end if
                    end if
                end if
            next
        End if
    End If

    set GetGUIDsofFriendlyNames = FriendlyNameList
    
End function


Function ConvertNameToGUID(sFriendlyName, sControlFileName)

    On Error Resume Next

    Dim sGUID
    Dim sLogLinePrefix
    Dim oFriendlyNameList

    ConvertNameToGUID = sFriendlyName

    sLogLinePrefix = "USEREXIT:MDTExitNameToGuid.vbs|ConvertNameToGUID: "

    oLogging.CreateEntry sLogLinePrefix & "Input Friendly Name: " & sFriendlyName, LogTypeInfo

    Set oFriendlyNameList = GetGUIDsofFriendlyNames(sControlFileName)
    If oFriendlyNameList.Count = 0 Then
        oLogging.CreateEntry sLogLinePrefix & "GetGUIDsofFriendlyNames failed to return any entries.", LogTypeError
        Exit Function
    End if

    if oFriendlyNameList.Exists(sFriendlyName) then
        sGUID = oFriendlyNameList.Item(sFriendlyName)
        oLogging.CreateEntry sLogLinePrefix & "Output GUID: " & sGUID , LogTypeInfo
    else
        sGUID = sFriendlyName
        oLogging.CreateEntry sLogLinePrefix & "Friendly Name not found:" & sFriendlyName, LogTypeWarning
    end if
   
    ConvertNameToGUID = sGUID 

End Function


Function ConvertNameToGUIDInList(sVariable, sControlFileName)

    Dim i
    Dim oListItem
    Dim oFriendlyNameList
    Dim sLogLinePrefix
    Dim sItem
    Dim sPadded
    Dim sIndexed
    Dim sGUID
    Dim sValue

    ConvertNameToGUIDInList = ""

    sLogLinePrefix = "USEREXIT:MDTExitNameToGuid.vbs|ConvertNameToGUIDInList: "

    Set oFriendlyNameList = GetGUIDsofFriendlyNames(sControlFileName)
    If oFriendlyNameList.Count = 0 Then
        oLogging.CreateEntry sLogLinePrefix & "GetGUIDsofFriendlyNames failed to return any entries.", LogTypeError
        Exit Function
    End if

	sGUIDPattern = "\{[a-fA-F0-9]{8}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{4}\-[a-fA-F0-9]{12}\}"

    Set ListItem = CreateObject("Scripting.Dictionary")
    For i = 1 to 999
        sPadded = sVariable & Right("000" & CStr(i), 3)
        sIndexed = sVariable & CStr(i)
        If oEnvironment.Item(sPadded) <> "" then
            sValue = oEnvironment.Item(sPadded)
            oLogging.CreateEntry sLogLinePrefix & "List Item Entry: " & sValue, LogTypeInfo
            If Not TestText(sValue, sGUIDPattern) then
                if oFriendlyNameList.Exists(sValue) then
                    sGUID = oFriendlyNameList.Item(sValue)
                    oLogging.CreateEntry sLogLinePrefix & "- GUID returned: " & sGUID, LogTypeInfo
                    oEnvironment.Item(sPadded) = sGUID
                else
                    oLogging.CreateEntry sLogLinePrefix & "- Friendly Name not found:" & sValue, LogTypeWarning
                end if
            End if
        ElseIf oEnvironment.Item(sIndexed) <> "" then
            sValue = oEnvironment.Item(sIndexed)
            oLogging.CreateEntry sLogLinePrefix & "List Item Entry: " & sValue, LogTypeInfo
            If Not TestText(sValue, sGUIDPattern) then
                if oFriendlyNameList.Exists(sValue) then
                    sGUID = oFriendlyNameList.Item(sValue)
                    oLogging.CreateEntry sLogLinePrefix & "- GUID returned: " & sGUID, LogTypeInfo
                    oEnvironment.Item(sIndexed) = sGUID
                else
                    oLogging.CreateEntry sLogLinePrefix & "- Friendly Name not found:" & sValue, LogTypeWarning
                end if
            End if
        Else
            Exit For  ' Exit on first "not found" entry
        End if
    Next

End Function


Function ReplaceText(strInputString, strPattern, strReplacementString)
    Dim regEx
    Set regEx = New RegExp
    regEx.Pattern = strPattern
    regEx.IgnoreCase = True
    regEx.Global = True
    ReplaceText = regEx.Replace(strInputString, strReplacementString)
End Function


Function TestText(strInputString, strPattern)
    Dim regEx
    Set regEx = New RegExp
    regEx.Pattern = strPattern
    regEx.IgnoreCase = False
    regEx.Global = True
    TestText = regEx.Test(strInputString)
End Function
