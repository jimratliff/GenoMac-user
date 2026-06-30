# How to configure 1Password for authentication with GitHub

## Make 1Password active and open its Settings
- ❑ Make 1Password active. (GenoMac-user will have already launched 1Password).
- ❑ Open 1Password’s Settings… (⌘,)
  
## Make 1Password persistent (probably already the default)
(Note: The two checkboxes below may indeed be turned on by default, as desired.)
- In the 1Password app, turn on two checkboxes to ensure that 1Password’s SSH Agent will be live even if the 1Password app itself is closed.
  - 1Password » Settings » General
    - ✅ Keep 1Password in the menu bar
    - ✅ Start 1Password at login
## Enable 1Password SSH Agent
- **ENTER YOUR PASSCODE** to unlock the 1Password vault</span>
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
Now return to the terminal and acknowledge you have completed the configuration of 1Password.
## The test to confirm the configuration of the SSH agent
### Authorize the test to confirm the configuration
The script will test that the SSH Agent configuration works. In the terminal, you’ll see something like:
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
❑ **Respond to that question with “yes”.**
### Grant 1Password access to use SSH key for this confirmation test
1Password will then popup a dialog box: “1Password Access Requested” and “Allow iTerm2 to use SSH Key”
- Optionally click “Approve for all applications”
- ❑ Click Authorize
### Success message
If the verification test works, you’ll see:
```
🪚 Testing SSH auth with: ssh -T git@github.com
✅ SSH authentication with GitHub succeeded
✅ Verified: SSH agent is working
```
(In fact, this may replace text you already saw on your screen.)
### Troubleshooting
#### Make sure the 1Password app is running
Instead of the success message, you could see:
```
🚨 SSH authentication failed. Output:
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
git@github.com: Permission denied (publickey).
❌ SSH authentication with GitHub failed
```
One likely cause of this is that the 1Password app was quit prior to the verification test. Make sure 1Password is running and try again.


