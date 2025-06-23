# GenoMac-bootstrap

## Overview
### Context
This repository is the first stop for configuring a Mac under Project GenoMac.

At this point, we assume the following:
- An essentially pristine Mac:
  - Fresh install of macOS
  - Only two users are defined:
    - USER_VANILLA
    - USER_CONFIGURER
  - - ***No other configurations or installations have been performed***
- USER_CONFIGURER is signed into its account

### Preview of process
- Install Homebrew (and therefore also Git)
- Modify PATH to add Homebrew
- Clone this public repo to `~/bootstrap`
- Run a script that executes a bunch of `defaults` commands for USER_CONFIGURER to deal with the most-annoying macOS default settings.
- Prepare USER_CONFIGURER to be able to clone the *next* repo in Project GenoMac, which is private and therefore requires authentication:
  - Install 1Password
    - Log into your 1Password account
    - Enable the 1Password SSH Agent
    - Change two settings to ensure the 1Password SSH Agent runs in the background.
  - Install 1Password CLI
  - Test the SSH connection to GitHub.
- Clone the *next* repo: GenoMac
- Delete *this* repo: `~/bootstrap`. It is no longer needed.

## Install Homebrew and update PATH
### Install Homebrew
Installing Homebrew will automatically install Xcode Command Line Tools (CLT), the 
installation of which will install a version of Git, which will permit cloning this repo.

To install Homebrew, launch Terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
(This is the same command as going to [brew.sh](https://brew.sh/) and copying the command from near the top of the page under “Install Homebrew.”)
### Add Homebrew to PATH
In Terminal, sequentially execute each of the following three commands:
```shell
echo >> /Users/configurer/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/configurer/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```
## Clone this repo to `~/bootstrap`
In Terminal:
```shell
mkdir -p ~/bootstrap
cd ~/bootstrap
git clone https://github.com/jimratliff/GenoMac-bootstrap.git .
```
**Note the trailing “.” at the end of the `git clone` command.**

## Set better user preferences
In Terminal, still in `~/bootstrap`:
```shell
make better-prefs
```

## Install and configure 1Password
### Install 1Password and `1Password-CLI`
In Terminal, still in `~/bootstrap`:
```shell
make install-1password
```

### Log into your 1Password account.
1Password should at this point be the active app. If not, launch it and/or make it active.

### Adjust settings of 1Password
Make 1Password active.

#### Make 1Password persistent
In the 1Password app, turn on two checkboxes to ensure that 1Password’s SSH Agent will be live even if the 1Password app itself is closed.
- 1Password » Settings » General
  - ✅ Keep 1Password in the menu bar
  - ✅ Start 1Password at login
 
#### Enable 1Password SSH Agent
Again in the 1Password app:
- 1Password » Settings » Developer:
  - SSH Agent
    - ✅ Use the SSH Agent
  - Advanced
    - Remember key approval: **until 1Password quits**


