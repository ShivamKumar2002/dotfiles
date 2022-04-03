## Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
source /usr/share/doc/find-the-command/ftc.fish
# Apply .profile
source ~/.profile

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
#if test -d ~/Applications/depot_tools
#    if not contains -- ~/Applications/depot_tools $PATH
#        set -p PATH ~/Applications/depot_tools
#    end
#end


## Starship prompt
#if status --is-interactive
#   source ("/usr/bin/starship" init fish --print-full-init | psub)
#end


## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Flatpak
set -l xdg_data_home $XDG_DATA_HOME ~/.local/share
set -gx --path XDG_DATA_DIRS $xdg_data_home[1]/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share

for flatpakdir in ~/.local/share/flatpak/exports/bin /var/lib/flatpak/exports/bin
    if test -d $flatpakdir
        contains $flatpakdir $PATH; or set -a PATH $flatpakdir
    end
end

## Import colorscheme from 'wal' asynchronously
#if type "wal" >> /dev/null 2>&1
#   cat ~/.cache/wal/sequences
#end

## Useful aliases
# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles

# Replace some more things with better alternatives
alias cat='bat --style header --style rules --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Common use
alias grubup="sudo update-grub"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias upd='/usr/bin/update'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                   # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB (expac must be installed)
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'			# List amount of -git packages

# Get fastest mirrors 
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist" 
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist" 
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist" 
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist" 

alias helpme='cht.sh --shell'
alias please='sudo'
alias tb='nc termbin.com 9999'
alias py='python'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

set -gx GPG_TTY (tty)

## Run paleofetch if session is interactive
#if status --is-interactive
#   neofetch
#end

# For kitty
alias d="kitty +kitten diff"              # d file1 file2 -> Show files difference
alias icat="kitty +kitten icat"           # icat image -> Show image file in terminal
alias hg='kitty +kitten hyperlinked_grep' # hg text -> Search your files using ripgrep and open the results directly in your favorite editor in the terminal, at the line containing the search result, simply by clicking on the result you want.
alias panel='kitty +kitten panel'         # panel command -> Draw a GPU accelerated dock panel on your desktop showing the output from an arbitrary terminal program, top edge of screen
alias panell='kitty +kitten panel --edge left'         # panell command -> Draw a GPU accelerated dock panel on your desktop showing the output from an arbitrary terminal program, left edge of screen
alias panelb='kitty +kitten panel --edge bottom'         # panelb command -> Draw a GPU accelerated dock panel on your desktop showing the output from an arbitrary terminal program, bottom edge of screen
alias panelr='kitty +kitten panel --edge right'         # panelr command -> Draw a GPU accelerated dock panel on your desktop showing the output from an arbitrary terminal program, right edge of screen


# yt-dlp Shortcuts
alias ytdl_formats='yt-dlp --list-formats'
alias ytdl_download='yt-dlp --write-subs --write-auto-subs --sub-format best --sub-langs "en,hi,en.*" --audio-format best --audio-quality 0 --embed-subs --embed-thumbnail --write-thumbnail --embed-chapters --embed-metadata --write-info-json --merge-output-format mkv --recode-video mkv'

# Aria2c
alias aria2c_4p='aria2c -s4 -x4 -j4 -k 1M'

# wget2
alias wget2_full_ios="wget2 -r --progress=bar -nH -E -U 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1' --compression=gzip -k -l inf -p"

# dotdrop
alias dotdrop="/home/shivam/.dotfiles/dotdrop.sh --cfg=/home/shivam/.dotfiles/config-user.yaml"
alias dotdropr="sudo /home/shivam/.dotfiles/dotdrop.sh --cfg=/home/shivam/.dotfiles/config-root.yaml"  # For managing root dotfiles


