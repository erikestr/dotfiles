#!/bin/bash

# config.sh
# This script sets up a development environment on a fresh Ubuntu installation.

# load scripts from lib/
source lib/colors.sh
source lib/messages.sh
print_success "Scripts loaded successfully"

# safe function to run commands depending on DRY_RUN variable
run_command() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${DRYRUN} ${MAGENTA}$1${NC}"
    else
        echo -e "${RUNNING} ${CYAN}$1${NC}"
        eval "$1"
    fi
}

# function to source .zshrc
source_zshrc() {
    print_info "sourcing .zshrc..."
    run_command "source ~/.zshrc"
}

# function to setup .zshrc, backup existing .zshrc if exists with timestamp and 
# copy new one, then apply changes by sourcing .zshrc
setup_zshrc() {
    print_info "setting up .zshrc..."
    # backup existing .zshrc if exists with timestamp
    if [ -f ~/.zshrc ]
    then
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        print_warning "backing up existing .zshrc to .zshrc.bak.$TIMESTAMP"
        run_command "cp ~/.zshrc ~/.zshrc.bak.$TIMESTAMP"
    fi
    run_command "cp .zshrc ~/.zshrc"
    print_info "applying changes by sourcing .zshrc..."
    source_zshrc
}

# function to setup aliases, backup existing aliases.zsh if exists with timestamp and 
# copy new one, then apply changes by sourcing .zshrc
setup_aliases() {
    print_info "setting up aliases..."
    # backup existing aliases.zsh if exists with timestamp
    if [ -f ~/.oh-my-zsh/custom/aliases.zsh ]
    then
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        print_warning "backing up existing aliases.zsh to aliases.zsh.bak.$TIMESTAMP"
        run_command "cp ~/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh.bak.$TIMESTAMP"
    fi
    run_command "cp aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh"
    print_info "applying changes by sourcing .zshrc..."
}

# Check for --zshrc-only argument
if [ "$1" == "--zshrc-only" ];
then
    if [ ! -f .zshrc ]; then
    print_error ".zshrc not found, cannot setup .zshrc."
    exit 1
fi
    setup_zshrc
    exit 0
fi

# Check for --aliases-only argument
if [ "$1" == "--aliases-only" ]; 
then
    if [ ! -f aliases.zsh ]; then
    print_error "aliases.zsh not found, cannot setup aliases."
    exit 1
fi
    setup_aliases
    source_zshrc
    exit 0
fi

# Check for --dry-run argument
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    print_warning "Running in dry-run mode. No changes will be made."
else
    DRY_RUN=false
fi

print_info "starting setup..."

# ask if user wants to apt update and upgrade with message "Do you want to apt update and upgrade? (y/n)"
print_question "Do you want to apt update and upgrade? (y/n)"
read -r -n 1 -s REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    print_info "updating and upgrading..."
    run_command "sudo apt update && sudo apt upgrade -y"
else
    print_warning "skipping apt update and upgrade..."
fi

# install curl
if [ ! command -v curl ] &> /dev/null
then
    print_warning "installing curl..."
    run_command "sudo apt install curl -y"
else
    print_success "curl is installed"
fi

# install homebrew
if [ ! command -v brew ] &> /dev/null
then
    print_warning "installing homebrew..."
    run_command '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    print_info "adding homebrew to path..."
    run_command 'echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc'
    run_command 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
else
    print_success "homebrew is installed"
fi

# install build-essential
if [ ! dpkg -s build-essential ] &> /dev/null
then
    print_warning "installing build-essential..."
    run_command "sudo apt install build-essential -y"
else
    print_success "build-essential is installed"
fi

# install brew packages
if [ -f Brewfile ]
then
    print_info "installing brew packages from Brewfile..."
    run_command "brew bundle --file=Brewfile"
else
    print_warning "Brewfile not found, skipping brew package installation..."
    exit 1
fi

# install sdkman
if [ ! -d "$HOME/.sdkman" ]
then
    print_warning "installing sdkman..."
    run_command "curl -s \"https://get.sdkman.io\" | bash"
    print_info "sourcing sdkman..."
    run_command "source \"$HOME/.sdkman/bin/sdkman-init.sh\""
else
    print_success "sdkman is installed"
fi

# verify zsh installed
if [ ! command -v zsh ] &> /dev/null
then
    print_error "zsh is not installed, exiting..."
    exit 1
else
    print_success "zsh is installed"
fi

# get zsh path
ZSH_PATH=$(which zsh)

# print zsh path in underlined
print_info "zsh path is: $(print_underline "$ZSH_PATH")"

# add zsh to /etc/shells if not already there
if [ ! grep "$ZSH_PATH" /etc/shells ] &> /dev/null
then
    print_warning "adding zsh to /etc/shells..."
    run_command "echo '$ZSH_PATH' | sudo tee -a /etc/shells"
else
    print_success "zsh is already in /etc/shells"
fi

# change default shell to zsh
if [ "$SHELL" != "$ZSH_PATH" ]
then
    print_warning "changing default shell to zsh..."
    run_command "chsh -s $ZSH_PATH"
else
    print_success "default shell is already zsh"
fi

# install oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]
then
    print_warning "installing oh-my-zsh..."
    run_command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
else
    print_success "oh-my-zsh is already installed"
fi

# install nvm if not installed
if [ ! -d "$HOME/.nvm" ]
then
    print_warning "installing nvm..."
    run_command 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
else
    print_success "nvm is installed"
fi

# configure .gitconfig if --copy is passed as argument
if [ -f .gitconfig ] && [ "$1" == "--copy" ]; then
    print_info "configuring .gitconfig..."
    # backup existing .gitconfig if exists with timestamp
    if [ -f ~/.gitconfig ]
    then
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        print_warning "backing up existing .gitconfig to .gitconfig.bak.$TIMESTAMP"
        run_command "cp ~/.gitconfig ~/.gitconfig.bak.$TIMESTAMP"
    fi
    run_command "cp .gitconfig ~/.gitconfig"
elif [ "$1" == "--copy" ]; then
    print_warning ".gitconfig not found, skipping .gitconfig configuration..."
else
    print_info "skipping .gitconfig configuration..."
fi

# configure .zshrc if --copy is passed as argument
if [ -f .zshrc ] && [ "$1" == "--copy" ]; then
    setup_zshrc
elif [ "$1" == "--copy" ]; then
    print_warning ".zshrc not found, skipping .zshrc configuration..."
else
    print_info "skipping .zshrc configuration..."
fi

# configure aliases.zsh if --copy is passed as argument
if [ -f aliases.zsh ] && [ "$1" == "--copy" ]; then
    setup_aliases
elif [ "$1" == "--copy" ]; then
    print_warning "aliases.zsh not found, skipping aliases.zsh configuration..."
else
    print_info "skipping aliases.zsh configuration..."
fi

# configure welcome message if --copy is passed as argument
if [ -f welcome.zsh ] && [ "$1" == "--copy" ]; then
    print_info "configuring welcome message..."
    run_command "cp erikestr.txt ~/erikestr.txt"
    run_command "cp welcome.zsh ~/.oh-my-zsh/custom/welcome.zsh"
elif [ "$1" == "--copy" ]; then
    print_warning "welcome.zsh not found, skipping welcome message configuration..."
else
    print_info "skipping welcome message configuration..."
fi

# check for ssh ed25519 key, if not present create one
if [ ! -f ~/.ssh/id_ed25519 ]
then
    print_warning "ssh ed25519 key not found, creating one..."
    run_command "ssh-keygen -t ed25519 -C \"$(git config --global user.email)\" -f ~/.ssh/id_ed25519 -N \"\""
    print_info "your public key is:"
    cat ~/.ssh/id_ed25519.pub
    print_info "copy it to your clipboard and add it to your github/gitlab/bitbucket account"
else
    print_success "ssh ed25519 key already exists"
fi

# check if ssh-agent is running, if not start it
if ! pgrep -u "$USER" ssh-agent > /dev/null; 
then
    print_warning "ssh-agent is not running, starting it..."
    run_command "eval \"\$(ssh-agent -s)\""
else
    print_success "ssh-agent is already running"
fi

# check if ssh key is added to ssh-agent, if not add it
if ! ssh-add -l | grep "id_ed25519" > /dev/null;
then
    print_warning "ssh key is not added to ssh-agent, adding it..."
    run_command "ssh-add ~/.ssh/id_ed25519"
else
    print_success "ssh key is already added to ssh-agent"
fi

# install java 25 if not installed
if ! command -v java &> /dev/null
then
    print_warning "java 25 is not installed, installing it..."
    run_command "sdk install java 25-tem"
else
    print_success "java 25 is already installed"
fi

# install maven if not installed
if ! command -v mvn &> /dev/null
then
    print_warning "maven is not installed, installing it..."
    run_command "sdk install maven"
else
    print_success "maven is already installed"
fi

# final message
print_success "setup complete! Please restart your terminal or run 'source ~/.zshrc' to apply changes."