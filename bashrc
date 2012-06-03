#.bashrc

#------------------------------#
#           VARIABLES          #
#------------------------------#

DISOWN_SIZE=100
DISOWN_DISPLAY=10

#------------------------------#
#            COLORS            #
#------------------------------#

# Foreground (text) 
BLACK='\[\e[30m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
MAGENTA='\[\e[35m\]'
CYAN='\[\e[36m\]'
WHITE='\[\e[37m\]'

# Background
BBLACK='\[\e[40m\]'
BRED='\[\e[41m\]'
BGREEN='\[\e[42m\]'
BYELLOW='\[\e[43m\]'
BBLUE='\[\e[44m\]'
BMAGENTA='\[\e[45m\]'
BCYAN='\[\e[46m\]'
BWHITE='\[\e[47m\]'

# Foreground, light versions (xterms only)
LBLACK='\[\e[90m\]'
LRED='\[\e[91m\]'
LGREEN='\[\e[92m\]'
LYELLOW='\[\e[93m\]'
LBLUE='\[\e[94m\]'
LMAGENTA='\[\e[95m\]'
LCYAN='\[\e[96m\]'
LWHITE='\[\e[97m\]'

# Background, light versions (xterms only)
BLBLACK='\[\e[100m\]'
BLRED='\[\e[101m\]'
BLGREEN='\[\e[102m\]'
BLYELLOW='\[\e[103m\]'
BLBLUE='\[\e[104m\]'
BLMAGENTA='\[\e[105m\]'
BLCYAN='\[\e[106m\]'
BLWHITE='\[\e[107m\]'

BOLD='\[\e[1m\]'
NORM='\[\e[0m\]'
ULINE='\[\e[4m\]'
NEG='\[\e[52m\]'

#-------------------------------#
#            HISTORY            #
#-------------------------------#

# No duplicate lines
HISTCONTROL=ignoredups:ignorespace

# Append to history rather than overwrite
shopt -s histappend

bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

HISTSIZE=4000
HISTFILESIZE=4000

#------------------------------#
#            EMACS             #
#------------------------------#

EDITOR="emacsclient -t"
VISUAL="emacsclient -c"

#------------------------------#
#            PROMPT            #
#------------------------------#

case "$TERM" in
    xterm-color) 
	color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="$CYAN>$NORM "
else
    PS1="> "
fi

unset color_prompt

#------------------------------#
#          SHORTCUTS           #
#------------------------------#

alias a='./a.out'

alias bd='cd -'
alias bk='bg kon'
alias bgc='bg clementine'
alias bgf='bg firefox'
alias bgg='bg gmsh'
alias bgh='bg chromium-browser'
alias bgt='bg thunderbird'
alias bgs='bgc;bgt;bgh'

alias bkk='bgk kon'
alias bgkc='bgk clementine'
alias bgkf='bgk firefox'
alias bgkg='bgk gmsh'
alias bgkh='bgk chromium-browser'
alias bgks='bgk skype'
alias bgkt='bgk thunderbird'

alias du='/usr/bin/du -hs'

alias e='emacsclient -t'
alias eb='e ~/.bashrc'
alias ec='e ~/.caam.org'
alias ed='e ~/.disown'
alias ee='e ~/.emacs'
alias em='e ~/.muttrc'
alias en='e ~/.notes.org'
alias er='e ~/.restaurants.org'
alias ex='bg emacs23-x'

alias kon='okular'

alias gimp='bg /usr/bin/gimp'
alias grep='/bin/grep --color=auto'

alias ls='/bin/ls --color=auto --group-directories-first'

alias r='reset'
alias rb='source ~/.bashrc'
alias rt='sudo modprobe -r psmouse;sudo modprobe psmouse'

alias tar1='tar xzvf'
alias tar2='tar xjvf'

alias va='valgrind ./a.out'
alias vla='valgrind --leak-check==ful ./a.out'
alias vol='alsamixer'

#------------------------------#
#          FUNCTIONS           #
#------------------------------#

     #----------------#
     #   Completion   #
     #----------------#

complete -c bg bgk bkk killall pf
complete -f bk c sa sr sm

# Find
function dig {
    find / -name "$@" 2> /dev/null
}

# find process running
function pf {
    echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
    ps aux | grep $1
}

# Make application a background application 
#     and add its PID into .disown
# If .disown is bigger than DISOWN_SIZE, delete
#     extra lines
function bg {
    tab1=70
    tab2=85

    eval "$(printf "%q " "$@") &> /dev/null 2> /dev/null & disown -h"
    tmp="[1] [PROCESS = '$@']"

    while [[ ${#tmp} -lt $tab1 ]];
    do
	tmp="${tmp}"' '
    done

    tmp="${tmp}[PID = ${!}]"
    
    while [[ ${#tmp} -lt $tab2 ]];
    do
	tmp="${tmp}"' '
    done

    tmp="${tmp}[DATE = $(date '+%m/%d (%H:%M:%S)')]"

    echo -e "${tmp}" >> ~/.disown

    tmp=$(wc -l < ~/.disown)

    if [ $tmp -gt $DISOWN_SIZE ]; then
	tmp=$(($tmp - $DISOWN_SIZE))
	sed -i "1,${tmp} d" ~/.disown
    fi
}

# Kills process made from using bg
# If the input is blank, tries to kill the last process created
# Otherwise kills the last process with the given input
function bgk {
    tmp="$(grep "\[1\]" ~/.disown | grep -w "${1}" | tail -1)"

    if [ "${#tmp}" -gt 0 ]; then	
    	tmp=$(echo "$tmp" | grep -oh "\[PID = [0-9].*[0-9]\]" | grep -oh "[0-9].*[0-9]")
    	if [ -n "$tmp" ]; then
    	    kill $tmp
    	    bgk-remove-from-list $tmp
    	fi
    fi    
}

# Remove PID from .disown

function bgk-remove-from-list {
    tmp=$(grep -n "\[1\]" ~/.disown | grep -w "${1}" | tail -1 | cut -f1 -d':')

    sed -in "${tmp}s/\[[1]\]/[0]/" ~/.disown
}

# Output .disown [1]
# If input x is given, show the last x lines

function bgo {
    if [ $# = 0 ]; then
	grep "\[1\]" ~/.disown | tail -$DISOWN_DISPLAY
    else
	grep "\[1\]" ~/.disown | tail - $1
    fi
}

# Output .disown all
# If input x is given, show the last x lines

function bga {
    if [ $# = 0 ]; then
	cat ~/.disown | tail -$DISOWN_DISPLAY
    else
	cat ~/.disown | tail -$1
    fi
}

#------------------------------#
#            EMACS             #
#------------------------------#

# Run emacs daemon if it isn't running
if [ "$(ps aux | grep -c 'emacs --daemon')" -ne 2 ]; then
    emacs --daemon
fi