#!/bin/bash

# ==========================================
# DEFINE COLORS
# ==========================================

# Reset
NC='\033[0m'       # No Color / Reset

# Regular colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold colors
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Bright colors
BRIGHT_BLACK='\033[0;90m'   # Gray
BRIGHT_RED='\033[0;91m'
BRIGHT_GREEN='\033[0;92m'
BRIGHT_YELLOW='\033[0;93m'
BRIGHT_BLUE='\033[0;94m'
BRIGHT_MAGENTA='\033[0;95m'
BRIGHT_CYAN='\033[0;96m'
BRIGHT_WHITE='\033[0;97m'

# Backgrounds
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Styles
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
HIDDEN='\033[8m'

# ==========================================
# USEFUL FUNCTIONS
# ==========================================

# Print with color
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Status messages
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_header() {
    echo -e "\n${BOLD_CYAN}==>${NC} ${BOLD}$1${NC}\n"
}

# ==========================================
# USAGE EXAMPLES
# ==========================================

echo -e "${BOLD}=== Basic Colors ===${NC}\n"

echo -e "${RED}Red text${NC}"
echo -e "${GREEN}Green text${NC}"
echo -e "${YELLOW}Yellow text${NC}"
echo -e "${BLUE}Blue text${NC}"
echo -e "${MAGENTA}Magenta text${NC}"
echo -e "${CYAN}Cyan text${NC}"
echo -e "${WHITE}White text${NC}"

echo -e "\n${BOLD}=== Bold Colors ===${NC}\n"

echo -e "${BOLD_RED}Bold red${NC}"
echo -e "${BOLD_GREEN}Bold green${NC}"
echo -e "${BOLD_YELLOW}Bold yellow${NC}"
echo -e "${BOLD_BLUE}Bold blue${NC}"

echo -e "\n${BOLD}=== Bright Colors ===${NC}\n"

echo -e "${BRIGHT_RED}Bright red${NC}"
echo -e "${BRIGHT_GREEN}Bright green${NC}"
echo -e "${BRIGHT_YELLOW}Bright yellow${NC}"
echo -e "${BRIGHT_CYAN}Bright cyan${NC}"

echo -e "\n${BOLD}=== Backgrounds ===${NC}\n"

echo -e "${BG_RED}${WHITE}White text on red background${NC}"
echo -e "${BG_GREEN}${BLACK}Black text on green background${NC}"
echo -e "${BG_BLUE}${WHITE}White text on blue background${NC}"

echo -e "\n${BOLD}=== Styles ===${NC}\n"

echo -e "${BOLD}Bold text${NC}"
echo -e "${DIM}Dim text${NC}"
echo -e "${ITALIC}Italic text${NC}"
echo -e "${UNDERLINE}Underlined text${NC}"
echo -e "${REVERSE}Reversed text${NC}"

echo -e "\n${BOLD}=== Combinations ===${NC}\n"

echo -e "${BOLD}${RED}Red and bold${NC}"
echo -e "${UNDERLINE}${GREEN}Green and underlined${NC}"
echo -e "${BOLD}${UNDERLINE}${BLUE}Blue, bold and underlined${NC}"
echo -e "${BG_YELLOW}${BLACK}${BOLD}Bold black on yellow background${NC}"

echo -e "\n${BOLD}=== Status Functions ===${NC}\n"

print_success "Operation completed successfully"
print_error "An error occurred during the process"
print_warning "Warning: check your configuration"
print_info "Additional information available"

echo -e "\n${BOLD}=== Headers ===${NC}"

print_header "Installing packages"
echo "  → Installing package 1..."
echo "  → Installing package 2..."

print_header "Configuring system"
echo "  → Applying configuration..."

echo -e "\n${BOLD}=== Script Example ===${NC}\n"

# Process simulation
print_header "Starting installation"
sleep 1
print_info "Downloading files..."
sleep 1
print_success "Files downloaded"
sleep 1
print_info "Installing dependencies..."
sleep 1
print_warning "Some dependencies are outdated"
sleep 1
print_success "Dependencies installed"
sleep 1
print_header "Installation completed"

echo -e "\n${BOLD}=== RGB Color Table (256 colors) ===${NC}\n"

# Show some colors from the 256 palette
echo "Extended colors (256 colors):"
for i in {0..15}; do
    echo -en "\033[48;5;${i}m  "
done
echo -e "${NC}"

echo -e "\n${BOLD}=== Usage in Scripts ===${NC}\n"

cat << 'EOF'
# In your scripts, you can use:

# Define colors at the beginning
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Use in messages
echo -e "${GREEN}✓${NC} Everything is fine"
echo -e "${RED}✗${NC} Something failed"

# In functions
error_msg() {
    echo -e "${RED}Error:${NC} $1" >&2
}

success_msg() {
    echo -e "${GREEN}Success:${NC} $1"
}
EOF

echo -e "\n${GREEN}${BOLD}End of demonstration!${NC}\n"