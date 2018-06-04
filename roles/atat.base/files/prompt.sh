function __prompt_command() {
  EXIT="$?"
  # ^^ This needs to be first (capture last command return code)

  # ANSI color codes
  LIGHT_BLUE='\[\e[1;34m\]'
  LIGHT_GREEN='\[\e[1;32m\]'
  LIGHT_PURPLE='\[\e[1;35m\]'
  LIGHT_RED='\[\e[1;31m\]'
  YELLOW='\[\e[1;33m\]'

  CLEAR_COLOR='\[\e[0m\]'

  # Start the prompt with a newline
  # (add a bit of separation from the previous command's output)
  PS1="\n"

  # Set the user/host color and prompt character
  # based on if the user is root or not
  if [ $EUID -ne 0 ]
  then
    # Use green for the host, and include the username
    PS1+="${LIGHT_GREEN}\u@"
    # Non-root shells get a $ prompt
    PROMPT_CHAR='$'
  else
    # Use red for the host, and don't bother including the username
    PS1+="${LIGHT_RED}"
    # Root shells get a # prompt
    PROMPT_CHAR='#'
  fi

  # Add the host, timestamp, and the full path to the current working directory
  # (for current dir name only, use \W instead)
  PS1+="\h ${LIGHT_PURPLE}\t ${LIGHT_BLUE}\w "

  # If the last command run before this prompt was generated returned a
  # non-zero return code, it most likely failed in some way... make the
  # prompt char red to point that out
  if [[ $EXIT -ne 0 ]]
  then
    PS1+="${LIGHT_RED}"
  fi

  # Put the prompt char followed by a space on a new line
  # (so even if our working dir path takes up a lot of space, we still have a
  # full line to enter new commands on)
  PS1+="\n${PROMPT_CHAR}${CLEAR_COLOR} "
}

PROMPT_COMMAND=__prompt_command
export PROMPT_COMMAND
