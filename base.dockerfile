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

## #############################################################################
## Environment setup
## #############################################################################

ENV SHELL=/bin/zsh TERM=xterm-256color

## #############################################################################
## Setup repositories 
## #############################################################################

RUN rm -f /etc/apk/repositories && \
    touch /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade

## #############################################################################
## Install base packages 
## #############################################################################

RUN apk add starship
RUN apk add cmatrix
RUN apk add eza
RUN apk add zsh
RUN apk add zsh-autosuggestions
RUN apk add zsh-vcs
RUN apk add ripgrep
RUN apk add bat
RUN apk add fastfetch
RUN apk add onefetch
RUN apk add gum
RUN apk add glances

## #############################################################################
## Configure zsh as the default shell 
## #############################################################################

RUN sed -i 's|/bin/ash|/bin/zsh|g' /etc/passwd

## #############################################################################
## Configure shell utilities globally
## #############################################################################

RUN mkdir -p /etc/zsh
RUN mkdir -p /etc/fastfetch
RUN mkdir -p /etc/starship

RUN echo 'eval "$(starship init zsh)"' >> /etc/zsh/zshrc && \
    echo 'export STARSHIP_CONFIG=/etc/starship/starship.toml' >> /etc/zsh/zshrc

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

setopt GLOB_DOTS            # Include dotfiles in globbing
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history items
setopt INC_APPEND_HISTORY   # Save history entries as soon as they are entered
setopt SHARE_HISTORY        # Share history between different instances

HISTFILE=/root/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

alias ls='eza --color=always --group-directories-first'
alias ll='eza -la --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
alias grep='rg'
alias info='fastfetch'
alias lnfo='onefetch'
alias more='bat --style=auto'

autoload -Uz compinit
compinit

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

EOF

RUN cat >> /etc/fastfetch/config.jsonc << 'FF_EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "source": "alpine3_small", // search for logos: fastfetch --list-logos or --print-logos
        "padding": {
                "top": 1
        },
    },
    "display": {
        "separator": "  "
    },
    "modules": [
        "break",
        "title",
        {
            "type": "os",
            "key": "os    ",
            "keyColor": "33",  // = color3
        },
        {
            "type": "kernel",
            "key": "kernel",
            "keyColor": "33",
        },
        {
            "type": "host",
            "format": "{5} {1}",
            "key": "host  ",
            "keyColor": "33",
        },
        {
            "type": "packages",
            "key": "pkgs  ",
            "keyColor": "33",
        },
        {
            "type": "disk",
            "key": "disk  ",
            "keyColor": "33"
        },{
            "type": "memory",
            "key": "memory",
            "keyColor": "33",
        },
        "break",
    ]
}
FF_EOF

RUN echo 'export SHELL=/bin/zsh' >> /etc/environment

## #############################################################################
## Cleanup 
## #############################################################################

# RUN rm -rf /var/cache/apk/*

## #############################################################################
## Setup workspace 
## #############################################################################

WORKDIR /root

## #############################################################################

CMD ["sh", "-c", "fastfetch && /bin/zsh"]

## #############################################################################
## Code ends here
