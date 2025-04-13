#!/bin/bash

# Prompt the user to enter the path to the folder
read -p "Please enter the path to your folder: " FOLDER_PATH

# Extract the folder name from the provided path
FOLDER_NAME=$(basename "$FOLDER_PATH")

# Run the docker-compose command with the provided folder path
docker-compose run --rm \
  -v "$FOLDER_PATH":/root/projects/"$FOLDER_NAME" \
  -w /root/projects/"$FOLDER_NAME" \
  claude_docker
