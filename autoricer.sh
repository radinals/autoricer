#!/usr/bin/env bash

check_deps() {

    if [ ! -f "/usr/bin/git" ]; then
        printf "git not found!"
        exit 0
    fi

    if [ ! -f "/usr/bin/make" ]; then
        printf "make not found!"
        exit 0
    fi

    if [ -f "/usr/bin/sudo" ]; then
        root_user="sudo"

    elif [ -f "/usr/bin/doas" ]; then
        root_user="doas"

    else
        printf "both sudo and doas not found, please install either of them first."
        exit 0
    fi
}

get_src() {
    dotfiles_repo="https://github.com/radinals/dotfiles.git"
    scripts_repo="httpa://github.com/radinals/scripts.git"
    dwm_repo="https://github.com/radinals/dwm.git"
    dmenu_repo="https://github.com/radinals/dmenu.git"
    #dwmblocks_repo="https://github.com/radinals/dwmblocks.git"
    st_repo="https://github.com/radinals/st.git"
    wp_repo="https://github.com/radinals/wallpapers.git"

    wp_setter="https://github.com/himdel/hsetroot"
    vol_control="https://github.com/cdemoulins/pamixer"
    #"$dwmblocks_repo"
    my_repo=("$dotfiles_repo" "$dwm_repo" "$dmenu_repo" "$st_repo" "$scripts_repo")

    ext_repo=("$wp_setter" "$vol_control")

    for repo in ${my_repo[*]}
    do
        git clone $repo 
    done

    printf "Download complete!."
    printf "\nDo you want to download extra sources? this include wallpaper setters, volume control, etc..\n"
    read -p "> " answr

    if [ "${answr^^}" == "yes" ] || [ "${answr^^}" == "y" ]; then

        for repo in ${ext_repo[*]}
        do
            git clone $repo
        done

	prinft "External Repos Downloaded"
        ext_repo="Y"

    else
        printf "No Extra Programs.."
        ext_repo="N"

    fi

    printf "\n"
}

install_src() {

    if [ ! -d "$HOME/Pictures" ]; then
	mkdir $HOME/Pictures cp -r wallpapers $HOME/Pictures && printf "Wallpapers Installed" 
    fi

     cd dotfiles &&  cp -r -i . $HOME && cd .. && printf "dotfiles installed"
     printf "\n"
     $root_user cp -r scripts /usr/local/share && printf "scripts installed"
     printf "\n"
     cd dwm && $root_user make install && cd ..
     printf "\n"
     cd dmenu && $root_user make install && cd ..
     printf "\n"
     #cd dwmblocks && $root_user make install && cd ..
     #printf "\n"
     cd st && $root_user make install && cd ..
     printf "\n"
 
     if [ $ext_repo == "Y" ]; then
         cd hsetroot && $root_user make install && cd ..
         cd pamixer && $root_user make install && cd ..
     fi
 
     printf "\n"

}

if [ ! -d "./autoricer" ]; then mkdir autoricer && cd autoricer ; else cd autoricer ; fi

check_deps && get_src && install_src && printf "\nAll Done!"
