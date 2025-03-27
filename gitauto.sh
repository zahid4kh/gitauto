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
    echo -e "${RED}Not a git repository. Please check your project path.${NC}"
    exit 1
fi

#############################################################################
echo -e "${YELLOW}Adding all files to git...${NC}"
git add .
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully added files.${NC}"
else
    echo -e "${RED}Error adding files. Exiting script.${NC}"
    exit 1
fi

###############################################################
echo -e "${YELLOW}Please enter your commit message:${NC}"
read commit_message

if [ -z "$commit_message" ]; then
    echo -e "${RED}Commit message cannot be empty. Exiting script.${NC}"
    exit 1
fi

#############################################################################
echo -e "${YELLOW}Committing changes with message: '${commit_message}'${NC}"
git commit -m "$commit_message"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully committed changes.${NC}"
else
    echo -e "${RED}Error committing changes. Exiting script.${NC}"
    exit 1
fi

#########################################################################
while true; do
    echo -e "${YELLOW}Would you like to push changes to origin/main? (y/n)${NC}"
    read push_response
    
    case $push_response in
        [Yy]|[Yy][Ee][Ss])
            echo -e "${YELLOW}Pushing changes to origin/main...${NC}"
            git push origin main
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Successfully pushed changes to origin/main.${NC}"
            else
                echo -e "${RED}Error pushing changes. Please check your connection or repository settings.${NC}"
                exit 1
            fi
            break
            ;;
        [Nn]|[Nn][Oo])
            echo -e "${BLUE}Changes were committed but not pushed.${NC}"
            break
            ;;
        *)
            echo -e "${RED}Please answer with 'y' or 'n'.${NC}"
            ;;
    esac
done

echo -e "${GREEN}Git operation completed successfully!${NC}"
exit 0
