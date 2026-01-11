# Disable greeting
set -g fish_greeting

# Homebrew
eval (/opt/homebrew/bin/brew shellenv fish)

starship init fish | source

# Atuin - AI-powered command history
atuin init fish --disable-up-arrow | source

if status is-interactive
    # Editor
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # Better history
    set -g fish_history_size 50000

    # Zoxide (better cd)
    if command -v zoxide &> /dev/null
        zoxide init fish | source
    end

    # Abbreviations (expand on space - better than aliases)
    abbr -a g git
    abbr -a gs git status
    abbr -a ga git add
    abbr -a gc git commit
    abbr -a gp git push
    abbr -a gl git pull
    abbr -a gd git diff
    abbr -a gco git checkout
    abbr -a gb git branch
    abbr -a glog 'git log --oneline --graph --decorate'

    # Kubernetes abbreviations
    abbr -a k kubectl
    abbr -a kgp 'kubectl get pods'
    abbr -a kgs 'kubectl get svc'
    abbr -a kgd 'kubectl get deployments'
    abbr -a kl 'kubectl logs'
    abbr -a kdesc 'kubectl describe'
    abbr -a kex 'kubectl exec -it'

    # Docker abbreviations
    abbr -a d docker
    abbr -a dc docker-compose
    abbr -a dps 'docker ps'
    abbr -a dimg 'docker images'
    abbr -a dstop 'docker stop'
    abbr -a drm 'docker rm'

    # Terraform abbreviations
    abbr -a tf terraform
    abbr -a tfi 'terraform init'
    abbr -a tfp 'terraform plan'
    abbr -a tfa 'terraform apply'
    abbr -a tfd 'terraform destroy'

    # System abbreviations
    abbr -a ll 'eza -lah'
    abbr -a la 'eza -A'
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'

    # Editor abbreviations
    abbr -a vim nvim
    abbr -a vi nvim

    # CLI tool abbreviations
    abbr -a cc claude
end

# Aliases (for non-expanding commands)
alias kns=kubens
alias ktx=kubectx
alias claudio=claude
alias l 'eza -lah'

# Modern CLI replacements
alias ls=eza
alias cat=bat
alias find=fd

# Path additions (if needed)
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.gem/ruby/2.6.0/bin
fish_add_path /Users/kuala/.local/bin
fish_add_path $JAVA_HOME/bin
fish_add_path /opt/homebrew/opt/python@3.13/libexec/bin
fish_add_path /usr/local/lib
fish_add_path /opt/homebrew/opt/openssl@3/bin
fish_add_path /Users/kuala/.dotnet/tools

# Bun
fish_add_path $HOME/.bun/bin

# Go
set -gx GO_PATH "$HOME/go"
fish_add_path $GO_PATH/bin

# Pyenv
set -gx PYENV_ROOT "$HOME/.pyenv"
fish_add_path $PYENV_ROOT/bin
pyenv init - | source

# OpenSSL
set -gx LDFLAGS "-L/opt/homebrew/opt/openssl@3/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/openssl@3/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/openssl@3/lib/pkgconfig"

# Obsidian
set -gx VAULT_ROOT "/Users/kuala/.config/obsidian"

# Plugin manager (Fisher) - install with: curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# Recommended plugins to install after Fisher:
# fisher install jorgebucaran/nvm.fish         # Node version manager
# fisher install PatrickF1/fzf.fish            # FZF integration
# fisher install franciscolourenco/done        # Notifications for long-running commands
fish_add_path /Library/TeX/texbin
