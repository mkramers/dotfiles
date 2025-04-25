# Dervied from https://github.com/Daydreamer-riri/dotfiles/blob/main/nushell/modules/fnm.nu
# Export environment variable settings
export-env {
    # Define a function to get fnm environment variable settings
    def fnm-env [] {
        # Create a mutable empty record to store environment variables
        mut env_vars = {}
        
        # Get fnm environment variable settings under PowerShell
        # Parse the output into key-value pairs through pipeline processing
        let pwsh_vars = (
            ^fnm env --version-file-strategy=recursive --corepack-enabled --shell powershell | 
            lines | 
            parse "$env:{key} = \"{value}\""
        )

        # Process fnm-related environment variables
        # Iterate through all variables except the first element (PATH) and add them to env_vars
        for v in ($pwsh_vars | slice 1..) { 
            $env_vars = ($env_vars | insert $v.key $v.value) 
        }

        # Special handling for PATH environment variable
        # Get the actual PATH variable name used in the current environment (considering case sensitivity)
        let env_used_path = ($env | columns | where {str downcase | $in == "path"} | get 0)
        # Get and split PATH value into array
        let path_value = ($pwsh_vars | get 0.value | split row (char esep))
        # Add the processed PATH to the environment variable collection
        $env_vars = ($env_vars | insert $env_used_path $path_value)

        return $env_vars
    }

    if not (which fnm | is-empty) {
        # Load fnm environment variables
        fnm-env | load-env
    }
}
