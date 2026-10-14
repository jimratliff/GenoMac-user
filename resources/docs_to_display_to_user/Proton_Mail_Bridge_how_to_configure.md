# How to configure Proton Mail Bridge

> [!NOTE]
> Don’t want to deal with this right this sec? Return to the terminal and enter 'punt'.
> This task will be re-presented to you next time you run the Hypervisor.

> [!TIP]
> - [Proton Mail Bridge Apple Mail setup guide](https://proton.me/support/protonmail-bridge-clients-apple-mail), Proton Support.

# Make Proton Mail Bridge active
Hypervisor will have launched Proton Mail Bridge.

# Configure Proton Mail Bridge with your Proton Mail account
- You’ll see a large dialog box: “Welcome to Proton Mail Bridge: Bridge is the gateway between your Proton account and your email client. It runs in the background and encrypts and decrypts your message seamlessly.”
  - Step 1: Connect Bridge to your Proton Account
  - Step 2: Connect your email client to Bridge
  - Button: “Start Setup”
- ❑ Click the “Start Setup” button
- The right pane of the same large dialog box changes to “Sign in: Enter your Proton Account details” with “Email or username” and “Password” fields, and a “Sign in” button
- ❑ Enter your Proton account credentials and press the “Sign in” button

# Configure Proton Mail Bridge specifically for the Apple Mail client
## Select Apple Mail as your client
- You’ll see a new dialog box.
  - The left pane says “Bridge is now connected to Proton, and has already started downloading your messages. Let’s now connect your email client to Bridge.
  - The right pane says “Select your email client”, offering Apple Mail, Microsoft Outlook, Mozilla Thunderbird, and “Other”
- Click the “Apple Mail” button

## Install the bridge certificate
- You’ll see a new dialog box
  - The left pane says “Apple Mail configuration is mostly automated, but in order to work, Bridge needs to install a certificate in your keychain.
  - The right pane says “Install the bridge certificate: After clicking the button below, a system pop-up will ask you for your credentials, please enter your macOS user credentials (not your Proton account’s) and validate.
- ❑ Click the “Install the certificate” button.
  - ❑ Touch ID can be used to authenticate

## Install the profile
- You’ll see a new dialog box
  - The left pane says “The final step before you can start using Apple Mail is to install the Bridge server profile in the system preferences. Adding a server profile is necessary to ensure that your Mac can receive and send Proton Mail messages.”
  - The right pane says “Install the profile: A series of pop-ups will appear. Follow the instructions to install the profile”
- ❑ Click the “Install the profile” button
- A pop-up will pop up (😉) and say (It disappeared before I could transcribe it)
- The System Settings » General » Device Management pane will open
  - Under “Downloaded” will be a line item with a ⚙️ icon, saying “Profile not installed. Double-click to review”
  - ❑ Double-click on the line item under “Downloaded”
- A new dialog box will appear: “Are you sure you want to install this profile?”
  - Click the “Install…” button
- Yet another confirmatory dialog box pops up: “Are you sure you want to install the profile ‘email address’?”
  - Click the “Install” button
- ❑ Return to the Proton Mail Bridge dialog box and click on the button that now says “I have installed the profile” (**check wording**)
  - You’ll now see “Congratulations! You’re all setup: Your client has been configured. While complete synchronization might take some time, you can already send encrypted emails.”
  - Click the “Done” button.
 
## Extra information about using Proton Mail Bridge. No action necessary at this time
### Dealing with spam
Using Mail’s built-in spam filters in addition to using Proton Mail’s spam filters provides additional spam filtering that uses the body of your messages to help detect spam. Any spam senders detected in this way will be added to your Proton Mail blacklist.

Mail’s built-in spam filters are disabled by default. You can Enable junk mail filtering by going to Mail (in the menu bar) → Preferences… → Junk Mail tab.

## Return to terminal and acknowledge
- ❑ Type `done` to acknowledge that you’ve completed signing into 1Password.

## Be tidy: Close this document
- ❑ Close this document
