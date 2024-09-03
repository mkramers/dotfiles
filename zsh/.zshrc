# autocomplete
autoload -Uz compinit
compinit

for file in ~/.dotfiles/.{omzrc,devrc,pathrc,aliases}; do
   if [ -f "$file" ]; then
      source "$file"
   else
       echo "WARNING: File '$file' not found."
   fi
done
unset file