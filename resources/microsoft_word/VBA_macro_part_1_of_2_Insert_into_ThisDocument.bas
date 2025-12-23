' This file contains the subset of macro code that is to be pasted inside `ThisDocument` of
' the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`.
' 
' - Open the macro-enabled Word document `Container_for_VBA_macro_to_set_Word_preferences.docm`
' - Open the VBA Editor (using ⌥F11, i.e., Option-F11)
' - In Project Explorer, find `ThisDocument` under `Project (Container_for…) » Microsoft Word Objects`
' - Double-click `ThisDocument` to open its code window
' - Paste only the three lines of code below into `ThisDocument`

Private Sub Document_Open()
    MsgBox "Document_Open fired!"
    SetMyPreferences
End Sub
