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
    # EndeavourOS does not come with a cron program, so if timeshift is ever removed from this
    # script, cronie should be added back in.
    yay -S pacseek btop ncdu timeshift fastfetch;
fi

# Enable bluetooth
while true; do
    if [[ $1 = "all" ]]; then
        enable_bt="yes"
        break
    fi

    printf "Enable bluetooth? (Y/n) "
    read yn

    case $yn in
        y | Y | yes | "" ) echo "Enabling bluetooth.";
            enable_bt="yes";
            break;;

        n | N | no ) echo "Skipping enabling bluetooth. You will need to run 'systemctl enable bluetooth && systemctl start bluetooth' to connect bluetooth devices.";
            enable_bt="no";
            break;;
    esac
done

if [[ $enable_bt = "yes" ]]; then
    systemctl enable bluetooth
    systemctl start bluetooth
fi


# TeX installation and packages
while true; do
    if [[ $1 = "all" ]]; then
        echo "Installing texlive-full..."
        yay -S texlive-full
        break;
    fi

    echo ""
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

# Check for AMD hardware + Gigabyte motherboard, and conditional prompt for GPP0 wake fix
# https://wiki.archlinux.org/title/Power_management/Wakeup_triggers#Instantaneous_wakeups_from_suspend

echo ""
echo "The install script will now check your hardware for a few known bugs."
echo "This will require your sudo password."

mb_mfg_check=$(sudo dmidecode -t baseboard | grep -i "manufacturer" | grep -i "gigabyte" | xargs)
mb_model_check=$(sudo dmidecode -t baseboard | grep -i "product name" | grep -i "B550" | xargs)

if [[ $mb_mfg_check != "" ]]; then
    if [[ $mb_model_check != "" ]]; then
        while true; do
            echo ""
            echo "Warning: Gigabyte B550 motherboard detected!"
            echo "There is a known bug with this hardware that wakes the system immediately after sleeping."
            echo "It can be fixed easily in software."
            echo ""
            printf "Implement fix? (Y/n) "
            read yn

            case $yn in
                y | Y | yes | "" ) echo "Fix not yet implemented. Please read the script comments to find the Arch wiki page with the fix.";
                    break;;

                n | N | no ) echo "Skipping fix.";
                    break;;

                * ) echo "Invalid response. Please provide y/n.";;
            esac
        done
    fi
fi

echo ""
echo "Done. Enjoy EndeavourOS!"
