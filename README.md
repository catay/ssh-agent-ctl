# Introduction

The script ssh-agent-ctl manages the ssh-agent process when an 
interactive shell is invoked.

# Installation

Fetch the script with wget and save it to your prefered location.

```bash
mkdir ~/bin && cd ~/bin
wget https://raw.githubusercontent.com/catay/ssh-agent-ctl/master/ssh-agent-ctl.sh
chmod +x ssh-agent-ctl.sh
```

# Configuration

Source the script in your ~/.bashrc file.

```bash
source bin/ssh-agent-ctl.sh
```
# Usage

Use `ssh-add` to add a private key to the authentication agent.   
The same private key can now be used across interactive shells to log
in to remote servers.

# How it works

When a new interactive shell is invoked the script gets executed.  
It checks if there is an ssh-agent process running with the same
pid as in `~/.ssh_agent_env_config`.

If that is the case it will source the `~/.ssh_agent_env_config` in the 
current shell. 

If not, it will start a new ssh-agent and store the pid and socket 
information in `~/.ssh_agent_env_config`.

