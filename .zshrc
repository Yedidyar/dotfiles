# Agent detection - only activate minimal mode for actual agents  
if [[ -n "$npm_config_yes" ]] || [[ -n "$CI" ]] || [[ "$-" != *i* ]]; then
  export AGENT_MODE=true
else
  export AGENT_MODE=false
fi

# Set the GPG_TTY to be the same as the TTY, either via the env var
# or via the tty command.
if [ -n "$TTY" ]; then
  export GPG_TTY=$(tty)
else
  export GPG_TTY="$TTY"
fi


# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

export PATH="/usr/local/bin:/usr/bin:$PATH"


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ "$AGENT_MODE" == "false" ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit && compinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light ohmyzsh/ohmyzsh
if [[ "$AGENT_MODE" == "false" ]]; then
  zinit ice depth=1; zinit light romkatv/powerlevel10k
fi

zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::rust
zinit snippet OMZP::command-not-found
zinit snippet OMZP::nvm
zinit snippet OMZP::terraform
zinit snippet OMZP::docker

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source $HOME/.profile

setopt auto_cd

#export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="$PATH:$HOME/Library/flutter/bin"

alias sudo='sudo '
export LD_LIBRARY_PATH=/usr/local/lib

# P10k customizations
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

if [[ "$AGENT_MODE" == "false" ]]; then
  [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
fi

# Fix for password store
export PASSWORD_STORE_GPG_OPTS='--no-throw-keyids'

export NVM_DIR="$HOME/.nvm"                            # You can change this if you want.
export NVM_SOURCE="/usr/share/nvm"                     # The AUR package installs it to here.
[ -s "$NVM_SOURCE/nvm.sh" ] && . "$NVM_SOURCE/nvm.sh"  # Load N

bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

[ -s "$HOME/.svm/svm.sh" ] && source "$HOME/.svm/svm.sh"

# Capslock command
alias capslock="sudo killall -USR1 caps2esc"

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

zle_highlight=('paste:none')

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.rd/bin:$PATH"

eval $(thefuck --alias)
alias docker_login='aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ecr-dns-redirect.nextinsurance.io'
alias db_start='docker run --pull=always -v mysql:/var/lib/mysql -p 3306:3306 --name=mysql -e MYSQL_ROOT_HOST=% -e TZ=UTC -d ecr-dns-redirect.nextinsurance.io/mysql-with-data:mysql-8.0.39-oraclelinux9-dataready-loaded --sql_mode=NO_ENGINE_SUBSTITUTION --max_connections=10000 --character-set-server=latin1 --collation-server=latin1_swedish_ci --default-authentication-plugin=mysql_native_password --key_buffer_size=16777216 --innodb_buffer_pool_instances=8 --default-time-zone=-08:00 --innodb_buffer_pool_size=5368709120 --wait_timeout=31536000 --explicit_defaults_for_timestamp=1 --max_allowed_packet=1073741824'

# SDKMAN!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

function add_cluster() {
	PROFILE=$1
	CLUSTER_NAME=$2
	ROLE=${3:-ni-eks-admins}

	KUBE_ALIAS="$PROFILE-$CLUSTER_NAME"

	if [ -z "$CLUSTER_NAME" ]; then
		echo "Cluster name was not specified, using the first cluster from the list, ROLE - $ROLE"
		CLUSTER_NAME="$(aws eks list-clusters --output json --profile "$PROFILE" | jq -r '.clusters[0]')"
		KUBE_ALIAS="$PROFILE-$CLUSTER_NAME"
	fi

	ROLE_ARN="$(aws iam get-role --output json --profile "$PROFILE" --role-name "$ROLE" | jq -r '.Role.Arn')"

	if [ -z "$ROLE_ARN" ]; then
		echo "Role $ROLE not found, exiting"
	else	
        echo "Adding Cluster $CLUSTER_NAME, Kubernetes Alias - $KUBE_ALIAS, Role - $ROLE, Role ARN - $ROLE_ARN"
        aws eks update-kubeconfig --name "$CLUSTER_NAME" --role-arn "$ROLE_ARN" --profile "$PROFILE" --alias "$KUBE_ALIAS"
    fi
}

AWS_CONFIG_FILE=~/.aws/config

# Safe Aliases for alternative tools
alias cat="bat"
alias ls="eza"
alias top="htop"
alias uname="neofetch"
alias man="tldr"
alias grep="rg"
alias gb='(git branch --show-current && git branch --all | grep -v "HEAD" | grep -v "$(git branch --show-current)") | fzf --preview="git log --oneline --graph --decorate --color {1}" | pbcopy'
eval "$(zoxide init --cmd cd zsh)"


source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
alias fzfp="fzf --preview 'bat --style numbers,changes --color=always {} | head -500'"

export TFENV_ARCH=amd64
# Created by `pipx` on 2024-07-18 11:54:49
export PATH="$PATH:$HOME/.local/bin"
alias docker_clean="docker system prune -a --volumes"
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"
export ENVIRONMENT="dev"

[ -f ~/.ghprofiles ] && source ~/.ghprofiles

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'

