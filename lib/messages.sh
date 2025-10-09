

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

# print message of the day with file txt parameter
print_motd() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo -e "${BOLD}$(cat "$file")${RESET}"
    else
        print_error "MOTD file not found: $file"
    fi
}
