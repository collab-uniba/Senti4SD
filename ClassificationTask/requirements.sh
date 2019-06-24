#!/bin/bash
if [ -n $(which java) ]; then
	echo "Java is installed"
	if [ -n $(which R) ]; then
                echo "R is installed"
		#this will install R library caret and LiblineaR if not already installed
		Rscript requirements.R
        else echo "R is not installed!"
	fi
else echo "Java is not installed!"
fi
