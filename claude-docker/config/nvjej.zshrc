export DEFAULT_USER="nvjej"
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
export GIT_USER_DEFAULT="jeportie"
export GIT_BRANCH_DEFAULT="main"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

ZSH_COMPDUMP=/tmp/zcompdump

plugins=(
    git
    dirhistory 
    copypath 
    web-search 
    sudo 
    npm
)

VENV_PATH="/root/venv/bin/activate"

if [ -f "$VENV_PATH" ]; then
    source "$VENV_PATH"
    echo "Virtual environment activated."
else
    echo "Virtual environment not found at $VENV_PATH"
fi

source $ZSH/oh-my-zsh.sh

alias venv="source /root/venv/bin/activate"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ensure Node.js and mcp-hub are installed on terminal start
# if ! nvm ls 22.14.0 > /dev/null 2>&1; then
#     nvm install v22.14.0
# fi
#
# if ! npm list -g mcp-hub@1.8.0 > /dev/null 2>&1; then
#     npm install -g mcp-hub@1.8.0
# fi

alias vi="vim"

vim() {
    FLAG="/root/.cache/nvim/mason_installed.flag"
    if [ ! -f "$FLAG" ]; then
        nvim -c 'MasonInstall clang-format codelldb' -c "TSInstall c cpp bash cmake make" "$@"
        # Create the flag file so we don't run initialization again
        touch "$FLAG"
    else
        nvim "$@"
    fi
}

pause() {
    if [ -n "$1" ]; then
        COMMIT=$(basename "$1")
    else
        COMMIT="push pause"
    fi
    git add . && git commit -m "$COMMIT" && git push && git status
}

sepcat() {
  # If no arguments, use the default glob pattern
  if [ "$#" -eq 0 ]; then
    set -- */*
  fi

  for file in "$@"; do
    if [ -f "$file" ]; then
      echo "===== $file ====="
      cat "$file"
    fi
  done
}

cform() {
  local builtin_styles=("LLVM" "Google" "Chromium" "Mozilla" "WebKit" "Microsoft" "GNU")
  local custom_styles_dir="$HOME/.clang-format-styles"
  local custom_styles=($(ls "$custom_styles_dir"))
  local styles=("${builtin_styles[@]}" "${custom_styles[@]}")

  echo "Select a clang-format style:"
  select style in "${styles[@]}"; do
    if [[ -z "$style" ]]; then
      echo "Invalid selection. Please try again."
      continue
    fi

    if [[ " ${builtin_styles[@]} " =~ " ${style} " ]]; then
      ~/.local/share/nvim/mason/bin/clang-format --style "$style" --dump-config > .clang-format
      echo ".clang-format file created with built-in style: $style"
    elif [[ -f "${custom_styles_dir}/${style}" ]]; then
      cp "${custom_styles_dir}/${style}" .clang-format
      echo ".clang-format file created with custom style: $style"
    else
      echo "Selected style not found. Please try again."
      continue
    fi
    break
  done
}

getgit() {
  local user="$GIT_USER_DEFAULT"
  local branch="$GIT_BRANCH_DEFAULT"
  local repo=""
  local file_path=""

  # Parse arguments using a while loop
  while (( $# )); do
    case "$1" in
      -u|--user)
        user="$2"
        shift 2
        ;;
      -b|--branch)
        branch="$2"
        shift 2
        ;;
      -*)
        echo "Unknown option: $1" >&2
        return 1
        ;;
      *)
        if [ -z "$repo" ]; then
          repo="$1"
        elif [ -z "$file_path" ]; then
          file_path="$1"
        else
          echo "Too many arguments." >&2
          return 1
        fi
        shift
        ;;
    esac
  done

  if [ -z "$repo" ] || [ -z "$file_path" ]; then
    echo "Usage: getgit <repo> <path/to/file> [-u user] [-b branch]" >&2
    return 1
  fi

  local url="https://raw.githubusercontent.com/${user}/${repo}/${branch}/${file_path}"
  echo "Fetching: $url"
  echo "PATH is: $PATH"
  echo "wget: $(command -v wget)"
  echo "curl: $(command -v curl)"

  if type wget &>/dev/null; then
    wget "$url"
  elif type curl &>/dev/null; then
    curl -O "$url"
  else
    echo "Error: neither wget nor curl is installed." >&2
    return 1
  fi
}

alias maj="bash /sh/update_makefile.sh"
alias run_with_args="bash /sh/run_with_args.sh"
alias val_with_args="bash /sh/val_with_args.sh"
