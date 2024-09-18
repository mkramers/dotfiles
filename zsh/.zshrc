# load all rc files
for file in ~/.dotfiles/.{pathrc,omzrc,devrc,aliases}; do
   if [ -f "$file" ]; then
      source "$file"
   else
       echo "WARNING: File '$file' not found."
   fi
done
unset file

# autocomplete
autoload -Uz compinit
compinit

