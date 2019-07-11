#!/bin/bash

## global variables
DEBUG=0
SSH_AGENT_ENV_CONFIG="${HOME}/.ssh_agent_env_config"
SSH_AGENT="$(which ssh-agent)"

## functions

# return the ssh-agent pids from user ${USER}
function get_agent_pids
{
  echo $(pgrep -u ${USER} ssh-agent)
  return ${?}
}

# check if a pid matches the list of running ssh-agent pids
function is_agent_pid
{
  pid=${1}

  for p in $(get_agent_pids) 
  do
    if [[ ${p} = ${pid} ]]
    then
      return $(true)
    fi
  done

  return $(false)
}

# print debug message when ${DEBUG} is true
function debug_msg
{
  msg=${1}
  if [[ ${DEBUG} -eq 1 ]]
  then
    echo "debug: ${msg}"
  fi
}

## main

# if script is not sourced, bail out with warning
(return 0 2>/dev/null)
if [[ ${?} -eq 1 ]]
then
  echo "error: script requires to be sourced ... exiting" 
  exit 1
fi

# source the env config when file is present and not empty
if [ -s ${SSH_AGENT_ENV_CONFIG} ]
then
  debug_msg "source ${SSH_AGENT_ENV_CONFIG}"
  source ${SSH_AGENT_ENV_CONFIG} &> /dev/null
fi

# if pids don't match the config pid, start new agent and save env vars
if ! is_agent_pid ${SSH_AGENT_PID}
then
  debug_msg "start a new ssh-agent process"
  ${SSH_AGENT} > ${SSH_AGENT_ENV_CONFIG}

  debug_msg "source ${SSH_AGENT_ENV_CONFIG}"
  source ${SSH_AGENT_ENV_CONFIG} &> /dev/null
else
  debug_msg "ssh-agent already running"
fi

return 0
