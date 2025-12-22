' This file contains the subset of macro code that is to be pasted inside a module of
' the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`.
' 
' - Open the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`
' - Open the VBA Editor (using ⌥F11, i.e., Option-F11)
' - From the macOS menubar, choose Insert » Module, which opens a new, blank window corresponding to `Module1`
' - Paste only the below code below (beginning with `Option Explicit`) into the `Module1` window
'
' NOTE: Changing this file doesn’t by itself effect the change. The new version of this code must be
'			  reinserted into `Module1` of the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`

Option Explicit

Public Sub SetMyPreferences()
    ' =============================================================================
    ' Sets Word preferences for executing user
    ' =============================================================================
    
    Dim changesApplied As String
    changesApplied = ""
    
    On Error Resume Next ' Some properties may not exist on all Mac versions
    
    ' -----------------------------------------------------------------
    ' Application.Options settings (stored in user preferences)
    ' -----------------------------------------------------------------
    With Application.Options
        
        ' General > Settings > "Update automatic links at Open"
        ' Default: ON (True) → Desired: OFF (False)
        If .UpdateLinksAtOpen <> False Then
            .UpdateLinksAtOpen = False
            changesApplied = changesApplied & "• Update links at open → OFF" & vbCrLf
        End If
        
        ' Edit > Editing Options > "Select entire word when selecting text"
        ' Default: ON (True) → Desired: OFF (False)
        If .AutoWordSelection <> False Then
            .AutoWordSelection = False
            changesApplied = changesApplied & "• Select entire word → OFF" & vbCrLf
        End If
        
        ' Edit > Click and Type > "Enable click and type"
        ' Default: ON (True) → Desired: OFF (False)
        If .AllowClickAndTypeMouse <> False Then
            .AllowClickAndTypeMouse = False
            changesApplied = changesApplied & "• Click and type → OFF" & vbCrLf
        End If
        
        ' Edit > Editing Options > "Insert/paste pictures as"
        ' Default: 0 (In line with text) → Desired: 4 (Top and bottom)
        ' WdWrapTypeMerged: 0=Inline, 1=Tight, 2=Through, 3=None, 4=TopBottom, 5=Behind, 6=Front, 7=Square
        If .PictureWrapType <> 4 Then
            .PictureWrapType = 4
            changesApplied = changesApplied & "• Picture wrap type → Top and Bottom" & vbCrLf
        End If
        
        ' Spelling & Grammar > Spelling > "Frequently confused words"
        ' Default: ON (True) → Desired: OFF (False)
        If .EnableMisusedWordsDictionary <> False Then
            .EnableMisusedWordsDictionary = False
            changesApplied = changesApplied & "• Frequently confused words → OFF" & vbCrLf
        End If
        
        ' Spelling & Grammar > Grammar > "Check grammar as you type"
        ' Default: ON (True) → Desired: OFF (False)
        If .CheckGrammarAsYouType <> False Then
            .CheckGrammarAsYouType = False
            changesApplied = changesApplied & "• Check grammar as you type → OFF" & vbCrLf
        End If
        
        ' Output and Sharing > Save > "Prompt before saving Normal template"
        ' Default: OFF (False) → Desired: ON (True)
        If .SaveNormalPrompt <> True Then
            .SaveNormalPrompt = True
            changesApplied = changesApplied & "• Prompt before saving Normal → ON" & vbCrLf
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
            changesApplied = changesApplied & "• AutoCorrect replace text → OFF" & vbCrLf
        End If
        
    End With
    
    ' -----------------------------------------------------------------
    ' View settings - NOTE: FieldShading is per-window, see notes below
    ' -----------------------------------------------------------------
    ' The FieldShading property is a VIEW setting, not an application preference.
    ' It applies to the current window and new windows inherit from a default.
    ' This may need to be in Normal.dotm to truly persist, or set here as a
    ' "best effort" that applies to any open windows.
    
    If Application.Documents.Count > 0 Then
        Dim doc As Document
        For Each doc In Application.Documents
            On Error Resume Next
            If doc.ActiveWindow.View.FieldShading <> 1 Then  ' 1 = wdFieldShadingAlways
                doc.ActiveWindow.View.FieldShading = 1
                changesApplied = changesApplied & "• Field shading → Always (current windows)" & vbCrLf
            End If
            On Error GoTo 0
        Next doc
    End If
    
    On Error GoTo 0
    
    ' -----------------------------------------------------------------
    ' Report results
    ' -----------------------------------------------------------------
    If changesApplied = "" Then
        MsgBox "All preferences were already set to your desired values.", _
               vbInformation, "Word Preferences"
    Else
        MsgBox "The following preferences were updated:" & vbCrLf & vbCrLf & changesApplied, _
               vbInformation, "Word Preferences Applied"
    End If
    
End Sub

' =============================================================================
' Optional: Manual trigger and diagnostic tools
' =============================================================================

Public Sub ShowCurrentPreferences()
    ' Displays current values for verification
    Dim msg As String
    
    On Error Resume Next
    
    msg = "Current Word Preferences:" & vbCrLf & vbCrLf
    
    With Application.Options
        msg = msg & "UpdateLinksAtOpen: " & .UpdateLinksAtOpen & " (want: False)" & vbCrLf
        msg = msg & "AutoWordSelection: " & .AutoWordSelection & " (want: False)" & vbCrLf
        msg = msg & "AllowClickAndTypeMouse: " & .AllowClickAndTypeMouse & " (want: False)" & vbCrLf
        msg = msg & "PictureWrapType: " & .PictureWrapType & " (want: 4)" & vbCrLf
        msg = msg & "EnableMisusedWordsDictionary: " & .EnableMisusedWordsDictionary & " (want: False)" & vbCrLf
        msg = msg & "CheckGrammarAsYouType: " & .CheckGrammarAsYouType & " (want: False)" & vbCrLf
        msg = msg & "SaveNormalPrompt: " & .SaveNormalPrompt & " (want: True)" & vbCrLf
    End With
    
    msg = msg & "AutoCorrect.ReplaceText: " & Application.AutoCorrect.ReplaceText & " (want: False)" & vbCrLf
    
    If Application.Documents.Count > 0 Then
        msg = msg & "FieldShading: " & ActiveWindow.View.FieldShading & " (want: 1)" & vbCrLf
    End If
    
    On Error GoTo 0
    
    MsgBox msg, vbInformation, "Current Preferences"
End Sub
