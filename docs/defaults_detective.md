# Determining the `defaults write` commands that correspond to desired changes in settings
(This is part of the documentation for the [GenoMac-user repository](https://github.com/jimratliff/GenoMac-user).)

## Table of contents
- [Running the “detective script”]
- [Using the output to construct `defaults write` commands]
- [Caveats]

The following addresses how to figure out what `defaults write` commands to add to the scripts in this repository (i.e., the ones reached via `make initial_prefs`) that correspond to changes in user-scoped settings.

This repo contains a script that helps you figure out what `defaults write` commands to add to the scripts in this repository to achieve a desired change in user-scoped settings.

(Note that the referenced script will *not* find the changed settings for *system-wide* commands, because those are located at `/Library/Preferences` rather than `~/Library/Preferences`.)

## Running the “detective script”
Suppose you want to find the `defaults write` command(s) that correspond to particular change(s) in the settings for Application X:
- `cd ~/.genomac-user`
- Launch Application X
- Open the Settings for Application X, but do not yet make the desired changes
- In the terminal, type `make defaults-detective`, which will launch the script `defaults_detective.sh`, which will:
  - record a snapshot of the *pre-change* state of your user’s entire `defaults` plists
  - tell you to that it is ready for you to make the desired changes to the application’s settings
- In Application X, make the desired settings to the application’s settings
- In the terminal, hit *any key* to tell the script that you have finished making the desired changes to settings
- The script will then:
  - record a snapshot of the *post-change* state of your user’s entire `defaults` plists
  - compute and present to you two “diffs” of the two states, which will highlight the changes in the user’s `defaults` plists that occurred between the pre-change and post-change snapshots
      - the first diff reflects changes in the user-scoped settings that are *not* specific to a host, i.e., these would correspond to `defaults write` commands that do *not* include the `-currentHost` switch
      - the second diff reflects changes in the user-scoped settings that *are* specific to the current host, i.e., these would correspond to `defaults write -currentHost` commands
     
## Using the output to construct `defaults write` commands
Each of the two diffs will highlight changes to one or more *keys* in your user’s defaults.

In many cases, the surrounding context in the diff’s output will be too limited to see the *domain* to which the changed key belongs. To find the domain to which a changed key belongs, it is helpful to use either:
```shell
defaults find *key*
```
or
```shell
defaults -currentHost find *key*
```
depending on whether the changed key showed up in the first diff or the second diff, respectively.

When a *key* belonging to a *domain* changes between the pre-change and post-change snapshots, there are two cases:
- the domain/key pair did not appear in the pre-change snapshot but did appear in the post-change snapshot
- the domain/key pair appeared in both the pre-change and post-change snapshots, with different values
In either case, you’ll be interested in the value associated with the domain/key pair in the post-change snapshot.

Although the diff will show you the *value* of the domain/key pair, it will not explicitly show the *type* of that value. To find the type, use one of:
```shell
defaults read-type *domain* *key*
defaults -currentHost read-type *domain* *key*
```

Then you can construct the ultimate command, either of:
```shell
defaults write *domain* *key* *type* *value*
defaults -currentHost write *domain* *key* *type* *value*
```
where *type* could be, for example, `-bool`, `-str`, or `-int`.

## Caveats
- Not every key change actually corresponds to the change in settings. Some changes in key will be inconsequential/irrelevant. You’ll need judgement to know to ignore them.
- Not every change in settings will correspond to a key that can be reached with a simple-form `defaults write`. Instead, a change in settings might result in changes deeper than a simple-form `defaults write` can replicate.
