#!/bin/bash

# config.sh
# This script sets up a development environment on a fresh Ubuntu installation.

# Colorful terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m'
INFO="${BLUE}[INFO]${NC}"
SUCCESS="${GREEN}[SUCCESS]${NC}"
WARNING="${YELLOW}[WARNING]${NC}"
ERROR="${RED}[ERROR]${NC}"
DRYRUN="${MAGENTA}[DRY-RUN]${NC}"
RUNNING="${CYAN}[RUNNING]${NC}"
BOLD_TEXT="${BOLD}BOLD${RESET}"
UNDERLINE_TEXT="${UNDERLINE}UNDERLINE${RESET}"

# print message functions
print_info() {
    echo -e "${INFO} $1"
}

# print success message
print_success() {
    echo -e "${SUCCESS} $1"
}

# print warning message
print_warning() {
    echo -e "${WARNING} $1"
}

# print question message
print_question() {
    echo -e "${CYAN}[QUESTION]${NC} $1"
}

# print error message
print_error() {
    echo -e "${ERROR} $1"
}

# print bold text
print_bold() {
    echo -e "${BOLD} $1 ${RESET}"
}

# print underlined text
print_underline() {
    echo -e "${UNDERLINE}$1${RESET}"
}

# message of the day
if [ -f erikestr.txt ]
then
    cat erikestr.txt
fi

# It installs necessary packages, configures zsh with oh-my-zsh, and sets up
# useful aliases and git configuration.
# Usage: ./config.sh [--dry-run]
# The --dry-run option will print the commands that would be executed without
# actually executing them.

# Check for --dry-run argument
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    print_warning "Running in dry-run mode. No changes will be made."
else
    DRY_RUN=false
fi

# safe function to run commands depending on DRY_RUN variable
run_command() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${DRYRUN} ${MAGENTA}$1${NC}"
    else
        echo -e "${RUNNING} ${CYAN}$1${NC}"
        eval "$1"
    fi
}

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

# configure .gitconfig
if [ -f .gitconfig ]
then
    print_info "configuring .gitconfig..."
    # backup existing .gitconfig if exists with timestamp
    if [ -f ~/.gitconfig ]
    then
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        print_warning "backing up existing .gitconfig to .gitconfig.bak.$TIMESTAMP"
        run_command "cp ~/.gitconfig ~/.gitconfig.bak.$TIMESTAMP"
    fi
    run_command "cp .gitconfig ~/.gitconfig"
else
    print_warning ".gitconfig not found, skipping .gitconfig configuration..."
fi

# configure .zshrc
if [ -f .zshrc ]
then
    print_info "configuring .zshrc..."
    # backup existing .zshrc if exists with timestamp
    if [ -f ~/.zshrc ]
    then
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        print_warning "backing up existing .zshrc to .zshrc.bak.$TIMESTAMP"
        run_command "cp ~/.zshrc ~/.zshrc.bak.$TIMESTAMP"
    fi
    run_command "cp .zshrc ~/.zshrc"
else
    print_warning ".zshrc not found, skipping .zshrc configuration..."
fi

# configure aliases.zsh
if [ -f aliases.zsh ]
then
    print_info "configuring aliases.zsh..."
    # backup existing aliases.zsh if exists with timestamp
    if [ -f ~/.oh-my-zsh/custom/aliases.zsh ]
    then
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        print_warning "backing up existing aliases.zsh to aliases.zsh.bak.$TIMESTAMP"
        run_command "cp ~/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh.bak.$TIMESTAMP"
    fi
    run_command "cp aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh"
else
    print_warning "aliases.zsh not found, skipping aliases.zsh configuration..."
fi

# configure welcome message
if [ -f welcome.zsh ]
then
    print_info "configuring welcome message..."
    run_command "cp erikestr.txt ~/erikestr.txt"
    run_command "cp welcome.zsh ~/.oh-my-zsh/custom/welcome.zsh"
else
    print_warning "welcome.zsh not found, skipping welcome message configuration..."
fi

print_success "setup complete! Please restart your terminal or run 'source ~/.zshrc' to apply changes."