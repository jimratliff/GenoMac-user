' This file contains the subset of macro code that is to be pasted inside a module of
' the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`.
' 
' - Open the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`
' - Open the VBA Editor (using ⌥F11, i.e., Option-F11)
' - From the macOS menubar, choose Insert » Module, which opens a new, blank window corresponding to `Module1`
' - Paste only the below code below (beginning with `Option Explicit`) into the `Module1` window
'
' NOTE: Changing this file doesn’t by itself effect the change. The new version of this code must be
'	    reinserted into `Module1` of the macro-enabled Word document 
        `Container_for_VBA_macro_to_set_Word_preferences.docm`

Option Explicit

' Log file location - adjust path as needed
' Using /tmp for simplicity; could also use ~/Library/Logs/ or another location
Private Const LOG_FILE_PATH As String = "/tmp/word_preferences_log.txt"

Public Sub SetMyPreferences()
    ' =============================================================================
    ' Sets Word preferences for executing user
    ' Writes summary of actions taken to a log file to be read by the enveloping shell script
    ' =============================================================================
    
    Dim changesApplied As String
    Dim logMessages As String
    changesApplied = ""
    logMessages = ""

    ' Add timestamp to log
    logMessages = logMessages & "Word Preferences Macro Run: " & Format(Now, "yyyy-mm-dd hh:nn:ss") & vbLf
    
    On Error Resume Next ' Some properties may not exist on all Mac versions
    
    ' -----------------------------------------------------------------
    ' Application.Options settings (stored in user preferences)
    ' -----------------------------------------------------------------
    With Application.Options
        
        ' General > Settings > "Update automatic links at Open"
        ' Default: ON (True) → Desired: OFF (False)
        If .UpdateLinksAtOpen <> False Then
            .UpdateLinksAtOpen = False
            changesApplied = changesApplied & "• Update links at open → OFF" & vbLf
        End If
        
        ' Edit > Editing Options > "Select entire word when selecting text"
        ' Default: ON (True) → Desired: OFF (False)
        If .AutoWordSelection <> False Then
            .AutoWordSelection = False
            changesApplied = changesApplied & "• Select entire word → OFF" & vbLf
        End If
        
        ' Edit > Click and Type > "Enable click and type"
        ' Default: ON (True) → Desired: OFF (False)
        If .AllowClickAndTypeMouse <> False Then
            .AllowClickAndTypeMouse = False
            changesApplied = changesApplied & "• Click and type → OFF" & vbLf
        End If
        
        ' Edit > Editing Options > "Insert/paste pictures as"
        ' Default: 0 (In line with text) → Desired: 4 (Top and bottom)
        ' WdWrapTypeMerged: 0=Inline, 1=Tight, 2=Through, 3=None, 4=TopBottom, 5=Behind, 6=Front, 7=Square
        If .PictureWrapType <> 4 Then
            .PictureWrapType = 4
            changesApplied = changesApplied & "• Picture wrap type → Top and Bottom" & vbLf
        End If
        
        ' Spelling & Grammar > Spelling > "Frequently confused words"
        ' Default: ON (True) → Desired: OFF (False)
        If .EnableMisusedWordsDictionary <> False Then
            .EnableMisusedWordsDictionary = False
            changesApplied = changesApplied & "• Frequently confused words → OFF" & vbLf
        End If
        
        ' Spelling & Grammar > Grammar > "Check grammar as you type"
        ' Default: ON (True) → Desired: OFF (False)
        If .CheckGrammarAsYouType <> False Then
            .CheckGrammarAsYouType = False
            changesApplied = changesApplied & "• Check grammar as you type → OFF" & vbLf
        End If
        
        ' Output and Sharing > Save > "Prompt before saving Normal template"
        ' Default: OFF (False) → Desired: ON (True)
        If .SaveNormalPrompt <> True Then
            .SaveNormalPrompt = True
            changesApplied = changesApplied & "• Prompt before saving Normal → ON" & vbLf
        End If
        
    End With
    
    ' -----------------------------------------------------------------
    ' AutoCorrect settings
    ' -----------------------------------------------------------------
    With Application.AutoCorrect
        
        ' AutoCorrect > "Automatically correct spelling and formatting as you type"
        ' Default: ON (True) → Desired: OFF (False)
        If .ReplaceText <> False Then
            .ReplaceText = False
            changesApplied = changesApplied & "• AutoCorrect replace text → OFF" & vbLf
        End If
        
    End With
    
    ' -----------------------------------------------------------------
    ' Build log message and write to file
    ' -----------------------------------------------------------------
    If changesApplied = "" Then
        logMessages = logMessages & "STATUS: OK - All preferences were already set to desired values." & vbLf
    Else
        logMessages = logMessages & "STATUS: OK - The following preferences were updated:" & vbLf & changesApplied
    End If
    
    ' Write to log file
    WriteToLogFile logMessages
    
    ' Close this document without saving (it's just a container for the macro)
    ' Comment out the next line if you want the document to remain open
    ThisDocument.Close SaveChanges:=wdDoNotSaveChanges
    
End Sub

Private Sub WriteToLogFile(ByVal message As String)
    ' Writes message to log file, overwriting any previous content
    ' Uses VBA file I/O which works on Mac
    
    Dim fileNum As Integer
    
    On Error GoTo WriteError
    
    fileNum = FreeFile
    Open LOG_FILE_PATH For Output As #fileNum
    Print #fileNum, message;
    Close #fileNum
    
    Exit Sub
    
WriteError:
    ' If we can't write to the log file, fail silently
    ' (we're trying to avoid any user interaction)
    On Error Resume Next
    Close #fileNum
    On Error GoTo 0
End Sub
