if status is-interactive
# Commands to run in interactive sessions can go here
end

# Avvia fastfetch all'apertura
fastfetch

# Alias (In Fish gli alias creano automaticamente delle funzioni)
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ff='fastfetch'
alias apps='cat /home/vollpe/APPS.txt'

# L'alias 'fuck' richiede una sintassi diversa in Fish per recuperare l'ultimo comando
#alias fuck='sudo $history[1]'
thefuck --alias | source

# PS1 non serve più perché usi Starship
# Inizializzazione di Starship per Fish
starship init fish | source
