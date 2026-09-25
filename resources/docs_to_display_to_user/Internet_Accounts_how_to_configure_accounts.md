# How to specify Internet Accounts 

> [!NOTE]
> Don’t want to deal with this right this sec? Return to the terminal and enter 'punt'.
> This task will be re-presented to you next time you run the Hypervisor.

> [!TIP]
> “[Add and manage email accounts in Mail on Mac](https://support.apple.com/en-kg/guide/mail/mail35803/mac),” Mail User Guide, Apple.

## Introduction
Running Mail.app for the first time (for a particular user on a particular startup volume) requires either:
- At least one email account has already been defined via System Settings » Internet Accounts
- You immediately define one or more email accounts from within Mail.app

> [!IMPORTANT]
> **Project GenoMac chooses to specify these accounts in System Settings » Internet Accounts, not directly in Mail.app.**

## Make the Internet Accounts pane of System Settings active
The Hypervisor will have opened this panel for you.

## Add at least one email account to Internet Accounts
- ❑ Click the “Add Account…” button
- You’ll see “Enter your email address” and “or choose from a list”.
- If you “choose from a list” you’ll see a list of offered options:
  - iCloud
  - Microsoft Exchange
  - Google
  - Yahoo!
  - Aol
  - Other Mail Account…
 
### Procedure to add an iCloud account to Internet Accounts
> [!TIP]
> - “[Use two-factor authentication for your Apple Account on iPhone](https://support.apple.com/guide/iphone/use-two-factor-authentication-iphd709a3c46/ios),” Apple Support.

#### Signing in

It is assumed you already have at least one trusted device, at least [typically an iPhone](https://support.apple.com/guide/iphone/use-two-factor-authentication-iphd709a3c46/ios).

When you sign into an iCloud account on a device that is a non-trusted device,[^WHAT'S_A_DEVICE_IN_TRUSTED_CONTEXT] the following two things will occur simultaneously:
- a dialog box will appear asking you to enter a six-digit verification code
- iCloud will send a six-digit verification code to each of your trusted devices.

Then:
- Enter the six-digit verification code you received on a trusted device into the dialog box showing on your display on the macOS user account being configured.
- You may then see a dialog box: “**Enter Mac Password** The password you use to unlock this Mac will also be used to access saved passwords and other sensitive data you store in iCloud.”
  - The “User Name:” text field will be pre-populated. This will clue you to what password is expected in the “Password:” text field.[^IMPROVEMENT_PERHAPS]
  - You might then see another dialog box: “**Apple Account Password** Enter the Apple Account password for ‘some-email@icloud.com’ to turn off Find My Mac. (I don’t know why or in what circumstances this occurs.)
    - In this case, you might yet another dialog box: “**Internet Accounts** ‘Find My Mac’ is trying to authenticate this user. Enter the password for the selected user to allow this.” You will see a dropdown menu of users on this device and a password field.
    - In this branch, there would be yet another dialog box: “**Allow Find My Mac to use the location of this Mac** Find My Mac is part of iCloud and helps you locate, lock, or erase a lost Mac.” You can click “Allow”.

[^WHAT'S_A_DEVICE_IN_TRUSTED_CONTEXT]: I have an open question: In the context of iCloud two-factor authentication, and further in the context of a Mac, is a “device” (a) the Mac itself (or more narrowly a particular startup volume?)? or (b) each particular user account that signs into that iCloud account?

[^IMPROVEMENT_PERHAPS]: This is how it appeared in macOS 26 Tahoe, and is an improvement over what I recall on earlier versions of macOS, where it merely asked for the “password you use to unlock this Mac,” without specifying a user name. In some scenarios I found that confusingly ambiguous.

#### Selecting which iCloud services to adopt
- ✅ iCloud Mail
- ❑ Contacts
- ❑ iCloud Calendar
- ❑ Reminders
 
### Procedure to add a Fastmail email address to Mail.app
See “[How to add a Fastmail email account to Mail.app](https://github.com/jimratliff/GenoMac-user/blob/main/resources/docs_to_display_to_user/FastMail_how_to_add_account_to_Mail_app.md).”


## Return to terminal and acknowledge
- ❑ Type `done` to acknowledge that you’ve completed these manual steps.

## Be tidy: Close this document
- ❑ Close this document

> [!NOTE]
> This is the default document that is displayed to guide the user through the interactive configuration of Internet Accounts. It is located at `GenoMac-user/resources/docs_to_display_to_user/Internet_Accounts_how_to_configure_accounts.md`.
> 
> This default document is displayed when, and only when, no user-specific document is provided. Alternatively, a user-specific document can be provided in that user’s Dropbox directory, specifically in the user’s `$USER_SPECIFIC_META_DIRECTORY` directory and, more specifically, the file `$USER_SPECIFIC_EMAIL_ACCOUNTS_FOR_MAIL_APP_SPECIFICATIONS_FILE`.
