if [ -f ~/.omzrc ]; then
    source ~/.omzrc
else
   echo "WARNING: File ~/.omzrc not found."
fi

# autocomplete
autoload -Uz compinit
compinit


if [ -f ~/.devrc ]; then
    source ~/.devrc
else
   echo "WARNING: File ~/.devrc not found."
fi


if [ -f ~/.pathrc ]; then
    source ~/.pathrc
else
   echo "WARNING: File ~/.pathrc not found."
fi


if [ -f ~/.aliases ]; then
    source ~/.aliases
else
   echo "WARNING: File ~/.aliases not found."
fi


. "$HOME/.cargo/env"
