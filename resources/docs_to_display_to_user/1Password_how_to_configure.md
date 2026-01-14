# How to configure 1Password for authentication with GitHub

Make 1Password active.

## Make 1Password persistent
(Note: The two checkboxes below may indeed be turned on by default, as desired.)
- In the 1Password app, turn on two checkboxes to ensure that 1Password’s SSH Agent will be live even if the 1Password app itself is closed.
  - 1Password » Settings » General
    - ✅ Keep 1Password in the menu bar
    - ✅ Start 1Password at login
## Enable 1Password SSH Agent
- ENTER YOUR PASSCODE to unlock the 1Password vault
  - Otherwise, you will not be able to access the Developer settings below
- Again in the 1Password app:
  - 1Password » Settings » Developer:
    - Click on "Setup SSH Agent"
      - SSH Agent
        - ✅ Use the SSH Agent
          - You will see a dialog box “Allow 1Password to save SSH key names to disk?”
          - Click the default “Use Key Names” button
      - Advanced
        - Remember key approval: **until 1Password quits**
        - Do **not** check “Generate SSH config file with bookmarked hosts”
      - Command-Line Interface (CLI)
        - ✅ Integrate with 1Password CLI
          - I don’t know much about this, but it seems like a good idea.
          - (“Use the desktop app to sign in to 1Password in the terminal.”)
           
## Return to the terminal
Now return to the terminal and acknowledge you have cpmpleted the configuration of 1Password.

## Respond to question about verifying the configuration
The script will test that the SSH Agent configuration works. Assuming everything works as planned, in the terminal, you’ll see something like:
```
********************************************************************************
Entering: verify_ssh_agent_configuration
********************************************************************************

🪚 Testing SSH auth with: ssh -T git@github.com
The authenticity of host 'github.com (140.82.116.3)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
Respond to that final question with “yes”.

