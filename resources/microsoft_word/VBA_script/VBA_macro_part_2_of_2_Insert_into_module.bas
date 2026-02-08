' This file contains the subset of macro code that is to be pasted inside a module of
' the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`.
' 
' - Open the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`
' - Open the VBA Editor (using ⌥F11, i.e., Option-F11)
' - From the macOS menubar, choose Insert » Module, which opens a new, blank window corresponding to `Module1`
' - Paste only the below code below (beginning with `Option Explicit`) into the `Module1` window
'
' NOTE: Changing this file doesn't by itself effect the change. The new version of this code must be
'       reinserted into `Module1` of the macro-enabled Word document 
'       `Container_for_VBA_macro_to_set_Word_preferences.docm`

Option Explicit

Private Function GetLogFilePath() As String
    GetLogFilePath = Environ("HOME") & "/tmp/genomac/word_preferences_log.txt"
End Function

Private Function ReportSetting(settingName As String, actionTaken As String) As String
    ReportSetting = "• " & settingName & " (" & actionTaken & ")" & vbLf
End Function

Public Sub SetMyPreferences()
    ' =============================================================================
    ' Sets Word preferences for executing user
    ' Writes summary of actions taken to a log file to be read by the enveloping shell script
    ' =============================================================================
    
    Dim logMessages As String
    logMessages = ""

    ' Add timestamp to log
    logMessages = logMessages & "Word Preferences Macro Run: " & Format(Now, "yyyy-mm-dd hh:nn:ss") & vbLf
    
    On Error Resume Next ' Some properties may not exist on all Mac versions
    
    Dim actionTaken As String

    ' -----------------------------------------------------------------
    ' Application.Options settings (stored in user preferences)
    ' -----------------------------------------------------------------
    With Application.Options
        
        ' General > Settings > "Update automatic links at Open"
        ' Default: ON (True) → Desired: OFF (False)
        If .UpdateLinksAtOpen <> False Then
            .UpdateLinksAtOpen = False
            actionTaken = "CHANGED"
        Else
            actionTaken = "already set"
        End If
        logMessages = logMessages & ReportSetting("General > Update automatic links at Open → OFF", actionTaken)
        
        ' Edit > Editing Options > "Select entire word when selecting text"
        ' Default: ON (True) → Desired: OFF (False)
        If .AutoWordSelection <> False Then
            .AutoWordSelection = False
            actionTaken = "CHANGED"
        Else
            actionTaken = "already set"
        End If
        logMessages = logMessages & ReportSetting("Edit > Select entire word when selecting text → OFF", actionTaken)
        
        ' Edit > Click and Type > "Enable click and type"
        ' Default: ON (True) → Desired: OFF (False)
        If .AllowClickAndTypeMouse <> False Then
            .AllowClickAndTypeMouse = False
            actionTaken = "CHANGED"
        Else
            actionTaken = "already set"
        End If
        logMessages = logMessages & ReportSetting("Edit > Enable click and type → OFF", actionTaken)
        
        ' Edit > Editing Options > "Insert/paste pictures as"
        ' Default: 0 (In line with text) → Desired: 6 (Top and bottom) [Mac-specific value]
        If .PictureWrapType <> 6 Then
            .PictureWrapType = 6
            actionTaken = "CHANGED"
        Else
            actionTaken = "already set"
        End If
        logMessages = logMessages & ReportSetting("Edit > Insert/paste pictures as → Top and bottom", actionTaken)
        
        ' Spelling & Grammar > Grammar > "Check grammar as you type"
        ' Default: ON (True) → Desired: OFF (False)
        If .CheckGrammarAsYouType <> False Then
            .CheckGrammarAsYouType = False
            actionTaken = "CHANGED"
        Else
            actionTaken = "already set"
        End If
        logMessages = logMessages & ReportSetting("Grammar > Check grammar as you type → OFF", actionTaken)
        
        ' Output and Sharing > Save > "Prompt before saving Normal template"
        ' Default: OFF (False) → Desired: ON (True)
        If .SaveNormalPrompt <> True Then
            .SaveNormalPrompt = True
            actionTaken = "CHANGED"
        Else
            actionTaken = "already set"
        End If
        logMessages = logMessages & ReportSetting("Save > Prompt before saving Normal template → ON", actionTaken)
        
    End With
    
    ' -----------------------------------------------------------------
    ' Write logMessages to file
    ' -----------------------------------------------------------------
    WriteToLogFile logMessages
    
    ' Close this document without saving (it's just a container for the macro)
    ThisDocument.Close SaveChanges:=wdDoNotSaveChanges
    
End Sub

Private Sub WriteToLogFile(ByVal message As String)
    Dim fileNum As Integer
    Dim filePath As String
    
    filePath = GetLogFilePath()
    
    On Error GoTo WriteError
    
    fileNum = FreeFile
    Open filePath For Output As #fileNum
    Print #fileNum, message;
    Close #fileNum

    Exit Sub
    
WriteError:
    On Error Resume Next
    Close #fileNum
    On Error GoTo 0
End Sub
