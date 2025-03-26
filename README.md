# Git Commit & Push Script

A simple bash script to automate your Git workflow by automating the commit and push process with guided prompts and feedback.

## Features

- Automatic `git add .` for all changes
- Interactive commit message prompt
- Option to push changes to `origin main` or exit
- Colored output for better readability
- Error handling and validation
- Project directory targeting

## Installation

### Quick Setup

1. Download the script:
   
   ```bash
   curl -o gitauto.sh https://raw.githubusercontent.com/zahid4kh/gitauto/main/gitauto.sh
   ```

2. Make the script executable:
   
   ```bash
   chmod +x gitauto.sh
   ```

3. Move to a convenient location (optional):
   
   ```bash
   # Option A: Move to your project directory
   mv gitauto.sh /pathtoyourproject/
   
   # Option B: Move to your personal bin directory(create if it doesnt exist)
   mkdir -p ~/bin
   mv gitauto.sh ~/bin/
   
   # Option C: Move to system-wide location (requires sudo)
   sudo mv gitauto.sh /usr/local/bin/gitauto
   ```

### Adding to Your PATH (Optional)

If you chose Option B, ensure your `~/bin` directory is in your PATH:

1. Check if it's already in your PATH:
   
   ```bash
   echo $PATH
   ```

2. If not, add it by editing your `~/.bashrc` file:
   
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Configuration

You can configure the script to always target a specific project:

1. Open the script with nano, or any text editor:
   
   ```bash
   nano gitauto.sh
   ```

2. Find the `PROJECT_PATH` variable near the top:
   
   ```bash
   PROJECT_PATH=""
   ```

3. Set it to your project's absolute path:
   
   ```bash
   PROJECT_PATH="/home/user/projects/myproject"
   ```

4. Save and exit the editor.

## Usage

### How to run

#### If you haven't set a PROJECT_PATH:

1. Navigate to your project directory:
   
   ```bash
   cd /pathtoyourproject
   ```

2. Run the script:
   
   ```bash
   # If the script is in your current directory
   ./gitauto.sh
   
   # If the script is in your PATH
   gitauto.sh
   
   # If the script is in a specific location
   /path/to/gitauto.sh
   ```

#### If you've set a PROJECT_PATH:

Run the script from anywhere:

```bash
gitauto.sh
```

### Workflow

1. The script will automatically add all changes (`git add .`)
2. You'll be prompted to enter a commit message
3. The script will commit your changes with the provided message
4. You'll be asked if you want to push the changes to `origin main`
   - Enter `y` or `yes` to push
   - Enter `n` or `no` to exit without pushing

## Troubleshooting

- **"Permission denied"**: Make sure the script is executable with `chmod +x gitauto.sh`
- **"Command not found"**: Make sure the script is in your PATH or you're using the correct path
- **"Not a git repository"**: Make sure you're in a git repository or the `PROJECT_PATH` is set correctly
- **"Failed to change to project directory"**: Check if the `PROJECT_PATH` exists and is accessible

## Customization :)

You can modify the script to suit your needs:

- Change the branch name from `main` to something else
- Add more Git commands
- Customize the colors and messages
