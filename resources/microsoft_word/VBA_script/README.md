# Overview
This README file addresses:
- using a VBA macro to implement a user’s preferences for Microsoft Word
- the structure of the contents of this `resources/VBA_script/microsoft_word` directory within this repository

# Contents
- `Container_for_VBA_macro_to_set_Word_preferences.docm`
  - A macro-enabled Word document that exists as a container for a VBA macro,
    which macro runs when `Container_for_VBA_macro_to_set_Word_preferences.docm` is opened
  - This is the only file in this `resources/VBA_script/microsoft_word` directory that *ultimately* matters.
    All of the other files in this directory contribute to the construction of
    `Container_for_VBA_macro_to_set_Word_preferences.docm`
- VBA macro code to be incorporated into `Container_for_VBA_macro_to_set_Word_preferences.docm`
  - The VBA macro editor can be accessed by either (a) ⌥F11 or (b) Tools » Macro » Visual Basic Editor
  - `VBA_macro_part_1_of_2_Insert_into_ThisDocument.bas`
    - Contains 3 lines of VBA code to be pasted into `ThisDocument` of this Word document, within the VBA editor
    - See comments within this file for detailed instructions about how these 3 linese of codes are to be
      pasted within `ThisDocument`
  - `VBA_macro_part_2_of_2_Insert_into_module.bas`
    - Contains the substantive VBA code for implementing the executing user’s preferences for Microsoft Word
    - This code is to be pasted within `Module1` of this Word document, within the VBA editor
    - See comments within this file for detailed instructions about (a) how to create `Module1` and
      (b) how these lines of codes are to be pasted within `Module1`
    - This is the file that should be edited when a revision to the VBA macro is required (either to fix an
      error or because there is change in the desired preferences)
    - But then the revised code must be manually reinserted into `Module1` (replacing the prior code)

