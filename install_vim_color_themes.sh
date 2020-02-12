#!/bin/sh

# Make directory if it doesn't exist
mkdir -p ~/.vim/colors

# Copy theme vim scripts to previous location
cp vim_color_themes/*.vim ~/.vim/colors
