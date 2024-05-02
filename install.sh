#!/usr/bin/env bash

# TODO: Change default make jobs to $(nproc)
# TODO: Add prompt for chaotic-aur
# TODO: Add prompt for enabling bluetooth

# General Purpose Utilities
while true; do
    if [[ $1 = "all" ]]; then
        utils="yes";
        break;
    fi

    printf "Install general purpose utilities? (Y/n) "
    read yn

    case $yn in
        y | Y | yes | "" ) echo "Installing general purpose utilities...";
            utils="yes";
            break;;

        n | N | no ) echo "Skipping installation of general purpose utilities."
            utils="no";
            break;;

        * ) echo "Invalid response. Please provide y/n.";;
    esac
done

if [ $utils = "yes" ]; then
    # Note: timeshift requires cronie which conflicts with fcron
    yay -S pacseek btop ncdu timeshift;
fi


# TeX installation and packages
while true; do
    if [[ $1 = "all" ]]; then
        echo "Installing texlive-full..."
        yay -S texlive-full
        break;
    fi

    echo "Do you want to install TeX?"
    echo "(If you don't know what this is, skip it.)"
    echo "0. Skip (Default)"
    echo "1. Basic (only texlive-basic)"
    echo "2. Recommended"
    echo "3. Full"
    echo ""
    printf "Select option (0/1/2/3) "
    read yn

    case $yn in
        0 | "" ) echo "Skipping TeX installation.";
            break;;

        1 ) echo "Installing texlive-basic.";
            break;;

        2 ) echo "Installing TeX and recommended packages.";
            yay -S texlive-basic texlive-latex texlive-latexextra texlive-latexrecommended texlive-mathscience texlive-xelatex latex-mk;
            break;;

        3 ) echo "Installing texlive-full.";
            yay -S texlive-full;
            break;;

        * ) echo "Invalid response. Please provide 0/1/2/3.";;
    esac
done

# TODO: Add check for AMD hardware + Gigabyte motherboard, and conditional prompt for GPP0 wake fix
# https://wiki.archlinux.org/title/Power_management/Wakeup_triggers#Instantaneous_wakeups_from_suspend
