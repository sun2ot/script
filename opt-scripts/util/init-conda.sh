#!/bin/bash
# Initialize user's shell to use a shared conda installation

# exit when any command fails
set -e
# import error handler
. ./error_handler.sh
source ./tips.sh

# Check if conda path is provided
if [ $# -gt 1 ]; then
    echo "Usage: $0 [path_to_conda]"
    echo "e.g. $0 /opt/miniconda3"
    echo "If no path is provided, it defaults to /opt/miniconda3"
    exit 1
fi

if [ $# -eq 0 ]; then
    # No arguments, use default
    set -- "/opt/miniconda3"
    echo "No conda path provided, using default: $1"
fi

CONDA_PATH=$1

# Check if the provided conda path is valid
if [ ! -f "${CONDA_PATH}/bin/conda" ]; then
    echo "Error: conda executable not found at ${CONDA_PATH}/bin/conda"
    exit 1
fi

init_shell() {
    # 执行conda初始化
    echo "Initializing conda for current shell..."
    if [[ $SHELL == *"/bash" ]]; then
      # 初始化bash
      echo "Bash detected. Initializing..."
      ${CONDA_PATH}/bin/conda init bash
      remind
    elif [[ $SHELL == *"/zsh" ]]; then
      # 初始化zsh
      echo "Zsh detected. Initializing..."
      ${CONDA_PATH}/bin/conda init zsh
      remind
    else
      echo -e "\e[31m Your shell ($SHELL) is not supported for auto-initialization.\e[0m"
      echo "You may need to initialize it manually."
      exit 1
    fi
}

init_shell

echo "Conda initialization complete."
