## Version: $Id:  $
## 
## 

## Commentary:
## 
## 

## Changelog:
## 
## 

## 
## Code starts here
## #############################################################################

FROM alpine:latest

ENV SHELL=/bin/zsh TERM=xterm-256color

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update

RUN apk add starship
RUN apk add eza
RUN apk add macchina
RUN apk add zsh
RUN apk add zsh-vcs
RUN apk add ripgrep
RUN apk add bat

RUN rm -rf /var/cache/apk/*

RUN sed -i 's|/bin/ash|/bin/zsh|g' /etc/passwd

RUN mkdir -p /etc/zsh

RUN echo 'eval "$(starship init zsh)"' >> /etc/zsh/zshrc && \
    echo 'export STARSHIP_CONFIG=/etc/starship/starship.toml' >> /etc/zsh/zshrc

RUN mkdir -p /etc/starship

# Create a starship configuration file
RUN cat > /etc/starship/starship.toml << 'STARSHIP_EOF'
format = """
$username\
$hostname\
$localip\
$shlvl\
$singularity\
$kubernetes\
$directory\
$character"""

right_format = """$all"""

[line_break]
disabled = false

[hostname]
ssh_only = false
disabled = false
style = 'bold purple'

[username]
disabled = false
show_always = true
format = "[$user]($style) at "

[character]
success_symbol = "[⦿](bold green)"
error_symbol = "[⦿](bold red)"
vicmd_symbol = "[⦿](bold green)"

[git_commit]
tag_symbol = " tag "

[git_status]
ahead = ">"
behind = "<"
diverged = "<>"
renamed = "r"
deleted = "x"

[jobs]
symbol = "◉ "

[aws]
symbol = "aws "

[bun]
symbol = "bun "

[c]
symbol = "C "

[cobol]
symbol = "cobol "

[conda]
symbol = "mamba "
ignore_base = false

[crystal]
symbol = "cr "

[cmake]
symbol = "cmake "

[daml]
symbol = "daml "

[dart]
symbol = "dart "

[deno]
symbol = "deno "

[dotnet]
symbol = ".NET "

[directory]
read_only = " ro"

[docker_context]
symbol = "docker "

[elixir]
symbol = "exs "

[elm]
symbol = "elm "

[git_branch]
symbol = "git "

[golang]
symbol = "go "

[hg_branch]
symbol = "hg "

[java]
symbol = "java "

[julia]
symbol = "jl "

[kotlin]
symbol = "kt "

[lua]
symbol = "lua "

[nodejs]
symbol = "nodejs "

[memory_usage]
symbol = "memory "

[nim]
symbol = "nim "

[nix_shell]
symbol = "nix "

[ocaml]
symbol = "ml "

[package]
symbol = "pkg "

[perl]
symbol = "pl "

[php]
symbol = "php "

[pulumi]
symbol = "pulumi "

[purescript]
symbol = "purs "

[python]
symbol = "py "

[raku]
symbol = "raku "

[ruby]
symbol = "rb "

[rust]
symbol = "rs "

[scala]
symbol = "scala "

[spack]
symbol = "spack "

[sudo]
symbol = "sudo "

[time]
disabled = false

[swift]
symbol = "swift "

[terraform]
symbol = "terraform "

[zig]
symbol = "zig "
STARSHIP_EOF

RUN echo '# Global zsh configuration' > /etc/profile.d/zsh.sh && \
    echo 'export ZDOTDIR=/etc/zsh' >> /etc/profile.d/zsh.sh && \
    echo 'export STARSHIP_CONFIG=/etc/starship/starship.toml' >> /etc/profile.d/zsh.sh && \
    chmod +x /etc/profile.d/zsh.sh

RUN cat >> /etc/zsh/zshrc << 'EOF'

setopt AUTO_CD              # Change directory without typing 'cd'
setopt GLOB_DOTS            # Include dotfiles in globbing
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history items
setopt INC_APPEND_HISTORY   # Save history entries as soon as they are entered
setopt SHARE_HISTORY        # Share history between different instances

HISTFILE=/root/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=always --group-directories-first'
    alias ll='eza -la --color=always --group-directories-first'
    alias la='eza -a --color=always --group-directories-first'
    alias lt='eza -aT --color=always --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
    alias la='ls -a --color=auto'
    alias lt='ls -la --color=auto'
fi
alias cat='bat --style=auto'
alias grep='rg'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias h='history'
alias c='clear'
alias info='macchina'

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

EOF

RUN echo 'export SHELL=/bin/zsh' >> /etc/environment
RUN rm -rf /var/cache/apk/*

WORKDIR /root

SHELL ["/bin/zsh", "-c"]

# RUN echo 'macchina' >> /etc/zsh/zshrc

CMD ["/bin/zsh"]

## #############################################################################
## Code ends here
