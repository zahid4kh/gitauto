#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
NC='\033[0m'


PROJECT_PATH=""

#############################################################################
# FUNCTIONS FOR TUI
draw_line() {
    printf "${CYAN}%$(tput cols)s${NC}\n" | tr ' ' '─'
}

center_text() {
    local text="$1"
    local color="$2"
    local width=$(tput cols)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s" ""
    printf "${color}${BOLD}%s${NC}\n" "$text"
}
###########################################################################

clear
draw_line
center_text "GIT AUTOMATION TOOL" "${MAGENTA}"
draw_line
echo ""

echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} Starting Git automation..."
echo ""


if [ -z "$PROJECT_PATH" ]; then
    PROJECT_PATH=$(pwd)
    echo -e "${YELLOW}${BOLD}▶ Using current directory:${NC} ${UNDERLINE}${PROJECT_PATH}${NC}"
else
    if [ ! -d "$PROJECT_PATH" ]; then
        echo -e "${RED}${BOLD}✖ ERROR:${NC} Project directory does not exist: ${UNDERLINE}${PROJECT_PATH}${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}${BOLD}▶ Using configured project path:${NC} ${UNDERLINE}${PROJECT_PATH}${NC}"
    
    cd "$PROJECT_PATH"
    if [ $? -ne 0 ]; then
        echo -e "${RED}${BOLD}✖ ERROR:${NC} Failed to change to project directory. Exiting script."
        exit 1
    fi
fi

if [ ! -d .git ]; then
    echo -e "${RED}${BOLD}✖ ERROR:${NC} Not a git repository. Please check your project path."
    exit 1
fi

#############################################################################
if [[ -z $(git status -s) ]]; then
    echo -e "   ${YELLOW}No changes detected in the repository.${NC}"
    echo -e "   ${YELLOW}Would you like to continue anyway? (y/n)${NC}"
    read -p "   > " continue_response
    
    case $continue_response in
        [Nn]|[Nn][Oo])
            echo -e "\n${BLUE}${BOLD}✓ Operation canceled.${NC}"
            exit 0
            ;;
    esac
fi
############################################################################

git add .
if [ $? -eq 0 ]; then
    echo -e "   ${GREEN}${BOLD}✓ Successfully added files to git...${NC}"
else
    echo -e "   ${RED}${BOLD}✖ Error adding files. Exiting script.${NC}"
    exit 1
fi

###############################################################
echo ""
echo -e "${CYAN}${BOLD}[2/3]${NC} ${YELLOW}Committing changes...${NC}"

echo -e "   ${YELLOW}Enter your commit message:${NC}"
echo -e "   ${CYAN}─────────────────────────────────────────${NC}"
read -p "   > " commit_message
echo -e "   ${CYAN}─────────────────────────────────────────${NC}"

if [ -z "$commit_message" ]; then
    echo -e "   ${RED}${BOLD}✖ Commit message cannot be empty. Exiting script.${NC}"
    exit 1
fi

#############################################################################
echo -e "   ${YELLOW}Committing with message:${NC} ${MAGENTA}\"${commit_message}\"${NC}"
git commit -m "$commit_message"
if [ $? -eq 0 ]; then
    echo -e "   ${GREEN}${BOLD}✓ Successfully committed changes.${NC}"
else
    echo -e "   ${RED}${BOLD}✖ Error committing changes. Exiting script.${NC}"
    exit 1
fi

#########################################################################
echo ""
echo -e "${CYAN}${BOLD}[3/3]${NC} ${YELLOW}Push options${NC}"

while true; do
    echo -e "   ${YELLOW}Would you like to push changes to origin/main?${NC}"
    echo -e "   ${GREEN}[y]${NC} Yes  ${RED}[n]${NC} No"
    read -p "   > " push_response
    
    case $push_response in
        [Yy]|[Yy][Ee][Ss])
            echo -e "   ${YELLOW}Pushing changes to origin/main...${NC}"
            git push origin main
            if [ $? -eq 0 ]; then
                echo -e "   ${GREEN}${BOLD}✓ Successfully pushed changes to origin/main.${NC}"
            else
                echo -e "   ${RED}${BOLD}✖ Error pushing changes.${NC}"
                echo -e "   ${YELLOW}Please check your connection or repository settings.${NC}"
                exit 1
            fi
            break
            ;;
        [Nn]|[Nn][Oo])
            echo -e "   ${BLUE}${BOLD}ℹ Changes were committed but not pushed.${NC}"
            break
            ;;
        *)
            echo -e "   ${RED}Please answer with 'y' or 'n'.${NC}"
            ;;
    esac
done

echo ""
draw_line
center_text "OPERATION SUMMARY" "${GREEN}"
echo ""
echo -e "  ${GREEN}${BOLD}✓ Git operation completed successfully!${NC}"
echo -e "  ${YELLOW}▶ Repository:${NC} $(basename $(git rev-parse --show-toplevel))"
echo -e "  ${YELLOW}▶ Branch:${NC} $(git branch --show-current)"
echo -e "  ${YELLOW}▶ Commit:${NC} $(git rev-parse --short HEAD)"
echo -e "  ${YELLOW}▶ Time:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
draw_line
exit 0