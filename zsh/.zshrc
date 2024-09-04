# autocomplete
autoload -Uz compinit
compinit

# load all rc files
for file in ~/.dotfiles/.{omzrc,pathrc,devrc,aliases}; do
   if [ -f "$file" ]; then
      source "$file"
   else
       echo "WARNING: File '$file' not found."
   fi
done
unset file

if [[ $(uname) == "Linux" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi