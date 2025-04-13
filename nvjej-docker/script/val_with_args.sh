#!/bin/sh

# Prompt the user for arguments
echo "Please enter the arguments for the program:"
read user_args

# Call make with the provided arguments
make valgrind ARGS="$user_args"
