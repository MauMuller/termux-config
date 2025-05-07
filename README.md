# termux-config

Manipulate your [termux](https://github.com/termux/termux-app) file configurations with command line.

- Change just specific configurion without modify any other;
- Rapidly make changes on your file;

Exemple:
```console
foo@bar:~$ termux-config set extra-keys='[[{ key: RIGHT, popup: END }]]'
foo@bar:~$ cat .termux/termux.properties
...
extra-keys = [[{ key: RIGHT, popup: END }]]
...
foo@bar:~$
```

# Summary

1. [Why](#why)
2. [Install](#install)
    1. [Depedences](#install-depedences)
    2. [Download](#install-download)
4. [Usage](#usage)

# Why

We alredy have **termux.properties** inside **~/.termux**, it's works well and is easy to manager, but isnt fast to make changes.
This is why i have created this project, to be faster to make modifies at config.

Another motivation is to automate some configs by command line without replace another configurations.
Using **termux-config** you can automatic set every configurations that you can, without just append on the bottom of file and replace another existent configurations (just the set by command line).

# Install

Here you can see how install this tool. Before at all, it's just a **Shell Script** that any linux shell should exec,
like (bash, zsh, fish, ...).

Now you will need to have some dependences, just toolings that you probably already have,

## Dependences

1. sed [required]
2. grep [required]
3. curl (or wget) [required]
4. git [optional]

## Download

Here you have 2 ways to follow, see below to choice your alternative.

### Download Tool

Observations:
- You can replace **bash** for any other shell like **zsh**, **fish**, ...
- Branch MASTER will be stable, but you can change for DEV to newer features

```console
# curl
foo@bar:~$ bash <(curl -fsSL "https://raw.githubusercontent.com/MauMuller/termux-config/refs/heads/master/installer.sh")

# wget
foo@bar:~$ bash <(wget -O- -o /dev/null "https://raw.githubusercontent.com/MauMuller/termux-config/refs/heads/master/installer.sh")
```

### GIT

Here you will need to have manually add the schell script into your PATH to have global access.

**Observation**: *.bashrc* can be replaced by *.zshrc*, *.config/fish/fish.config*, etc

#### 
```console
foo@bar:~$ git clone https://github.com/MauMuller/termux-config.git ~/.termux-config
foo@bar:~$ cd .termux-config
foo@bar:~$ rm $(ls | grep -vi "termux-config.sh")
foo@bar:~$ mkdir bin
foo@bar:~$ mv termux-config.sh ./bin/
foo@bar:~$ echo 'export PATH="$PATH:/$HOME/.termux-config/bin"' >> .bashrc
foo@bar:~$ source .bashrc
```

# Usage 

```console
foo@bar:~$ termux-config get extra
...
extra-keys = [[{ key: RIGHT, popup: END }]]
...
foo@bar:~$ termux-config set use-black-ui=true
foo@bar:~$ termux-config show-all
...
extra-keys = [[{ key: RIGHT, popup: END }]]
use-black-ui = true
...
foo@bar:~$ 
```
